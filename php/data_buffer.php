<?php
/**
 * Data Buffer
 * Handles buffering of sensor data before transferring to database
 */

require_once __DIR__ . '/db.php';

class DataBuffer {
    private $bufferFile;
    private $transferLogFile;
    private $transferStateFile;
    private $maxBufferSize = 1000; // Maximum number of records to buffer
    private $transferInterval = 300; // Transfer every 5 minutes (300 seconds)
    
    public function __construct() {
        $this->bufferFile = __DIR__ . '/data/sensor_buffer.txt';
        $this->transferLogFile = __DIR__ . '/data/transfer.log';
        $this->transferStateFile = __DIR__ . '/data/transfer_state.json';
        
        // Ensure data directory exists
        $dataDir = dirname($this->bufferFile);
        if (!is_dir($dataDir)) {
            mkdir($dataDir, 0755, true);
        }
    }
    
    /**
     * Save sensor data to buffer
     */
    public function saveSensorData($sensorData) {
        try {
            // Validate required fields
            if (empty($sensorData['temperature']) && empty($sensorData['humidity']) && empty($sensorData['ammonia'])) {
                return false;
            }
            
            // Add timestamp if not provided
            if (empty($sensorData['timestamp'])) {
                $sensorData['timestamp'] = date('Y-m-d H:i:s');
            }
            
            // Append to buffer file
            $bufferLine = json_encode($sensorData) . "\n";
            $result = file_put_contents($this->bufferFile, $bufferLine, FILE_APPEND | LOCK_EX);
            
            if ($result === false) {
                error_log("Failed to write to sensor buffer file");
                return false;
            }
            
            // Check if we should transfer data
            $this->checkAndTransfer();
            
            return true;
            
        } catch (Exception $e) {
            error_log("Error saving sensor data to buffer: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Check if it's time to transfer data and do so if needed
     */
    private function checkAndTransfer() {
        $transferState = $this->getTransferState();
        $now = time();
        
        // Check if it's time to transfer (every 5 minutes)
        if (($now - $transferState['last_transfer']) >= $this->transferInterval) {
            $this->transferToDatabase();
        }
        
        // Also check buffer size
        $bufferSize = $this->getBufferSize();
        if ($bufferSize >= $this->maxBufferSize) {
            $this->transferToDatabase();
        }
    }
    
    /**
     * Force transfer all buffered data to database
     */
    public function forceTransfer() {
        return $this->transferToDatabase();
    }
    
    /**
     * Transfer buffered data to database
     */
    private function transferToDatabase() {
        try {
            if (!file_exists($this->bufferFile)) {
                return 0;
            }
            
            $bufferContent = file_get_contents($this->bufferFile);
            if (empty($bufferContent)) {
                return 0;
            }
            
            $lines = explode("\n", trim($bufferContent));
            $transferredCount = 0;
            
            $clientDb = DatabaseConnectionProvider::client();
            
            foreach ($lines as $line) {
                if (empty($line)) continue;
                
                $sensorData = json_decode($line, true);
                if (!$sensorData) continue;
                
                // Insert into database
                $stmt = $clientDb->prepare("
                    INSERT INTO raw_sensor_data (
                        temperature, humidity, ammonia, timestamp, 
                        pump_temp, pump_trigger, heat, mode, source, data_quality
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'buffer', 'good')
                ");
                
                // Parse Arduino timestamp format (days:hours:minutes:seconds)
                $arduinoTimestamp = $sensorData['timestamp'] ?? null;
                $mysqlTimestamp = $this->parseArduinoTimestamp($arduinoTimestamp);
                
                $result = $stmt->execute([
                    $sensorData['temperature'] ?? null,
                    $sensorData['humidity'] ?? null,
                    $sensorData['ammonia'] ?? null,
                    $mysqlTimestamp,
                    $sensorData['pump_temp'] ?? null,
                    $sensorData['pump_trigger'] ?? null,
                    $sensorData['heat'] ?? null,
                    $sensorData['mode'] ?? null
                ]);
                
                if ($result) {
                    $transferredCount++;
                }
            }
            
            // Clear buffer file after successful transfer
            if ($transferredCount > 0) {
                file_put_contents($this->bufferFile, '');
                
                // Log transfer
                $this->logTransfer($transferredCount);
                
                // Update transfer state
                $this->updateTransferState();
            }
            
            return $transferredCount;
            
        } catch (Exception $e) {
            error_log("Error transferring data to database: " . $e->getMessage());
            return 0;
        }
    }
    
    /**
     * Get current buffer size (number of lines)
     */
    private function getBufferSize() {
        if (!file_exists($this->bufferFile)) {
            return 0;
        }
        
        $content = file_get_contents($this->bufferFile);
        if (empty($content)) {
            return 0;
        }
        
        return substr_count($content, "\n");
    }
    
    /**
     * Get transfer state
     */
    private function getTransferState() {
        if (!file_exists($this->transferStateFile)) {
            return [
                'last_transfer' => 0,
                'total_transferred' => 0
            ];
        }
        
        $content = file_get_contents($this->transferStateFile);
        $state = json_decode($content, true);
        
        return $state ?: [
            'last_transfer' => 0,
            'total_transferred' => 0
        ];
    }
    
    /**
     * Update transfer state
     */
    private function updateTransferState() {
        $state = $this->getTransferState();
        $state['last_transfer'] = time();
        
        file_put_contents($this->transferStateFile, json_encode($state), LOCK_EX);
    }
    
    /**
     * Log transfer activity
     */
    private function logTransfer($count) {
        $logEntry = date('Y-m-d H:i:s') . " - Transferred {$count} records to database\n";
        file_put_contents($this->transferLogFile, $logEntry, FILE_APPEND | LOCK_EX);
    }
    
    /**
     * Get buffer status
     */
    public function getBufferStatus() {
        return [
            'buffer_size' => $this->getBufferSize(),
            'max_buffer_size' => $this->maxBufferSize,
            'transfer_interval' => $this->transferInterval,
            'last_transfer' => $this->getTransferState()['last_transfer'],
            'buffer_file_exists' => file_exists($this->bufferFile),
            'buffer_file_size' => file_exists($this->bufferFile) ? filesize($this->bufferFile) : 0
        ];
    }
    
    /**
     * Parse Arduino timestamp format to MySQL timestamp
     * Arduino format: "YYYY-MM-DD HH:MM:SS" (RTC) or "RTC_ERROR" (fallback)
     * Matching original swift/swift implementation
     */
    private function parseArduinoTimestamp($arduinoTimestamp) {
        if (!$arduinoTimestamp) {
            return date('Y-m-d H:i:s');
        }
        
        // Check if it's RTC format (YYYY-MM-DD HH:MM:SS) - matching original implementation
        if (preg_match('/^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}$/', $arduinoTimestamp)) {
            return $arduinoTimestamp;
        }
        
        // Check if it's RTC_ERROR (fallback from original implementation)
        if ($arduinoTimestamp === 'RTC_ERROR') {
            return date('Y-m-d H:i:s');
        }
        
        // Check if it's Arduino fallback format (days:hours:minutes:seconds) - legacy support
        $parts = explode(':', $arduinoTimestamp);
        if (count($parts) === 4) {
            $days = (int)$parts[0];
            $hours = (int)$parts[1];
            $minutes = (int)$parts[2];
            $seconds = (int)$parts[3];
            
            // Calculate total seconds since Arduino startup
            $totalSeconds = ($days * 24 * 3600) + ($hours * 3600) + ($minutes * 60) + $seconds;
            
            // Estimate Arduino startup time (assume it started recently)
            $currentTime = time();
            $estimatedStartTime = $currentTime - $totalSeconds;
            
            return date('Y-m-d H:i:s', $estimatedStartTime);
        }
        
        // If format is unrecognized, use current time (matching original implementation)
        return date('Y-m-d H:i:s');
    }
}
?>
