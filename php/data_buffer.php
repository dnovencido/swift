<?php
require_once __DIR__ . '/db.php';
class DataBuffer {
    private $bufferFile;
    private $transferLogFile;
    private $transferStateFile;
    private $maxBufferSize = 1000; 
    private $transferInterval = 300; 
    public function __construct() {
        $this->bufferFile = __DIR__ . '/data/sensor_buffer.txt';
        $this->transferLogFile = __DIR__ . '/data/transfer.log';
        $this->transferStateFile = __DIR__ . '/data/transfer_state.json';
        $dataDir = dirname($this->bufferFile);
        if (!is_dir($dataDir)) {
            mkdir($dataDir, 0755, true);
        }
    }
    public function saveSensorData($sensorData) {
        try {
            if (empty($sensorData['temperature']) && empty($sensorData['humidity']) && empty($sensorData['ammonia'])) {
                return false;
            }
            if (empty($sensorData['timestamp'])) {
                $sensorData['timestamp'] = date('Y-m-d H:i:s');
            }
            $bufferLine = json_encode($sensorData) . "\n";
            $result = file_put_contents($this->bufferFile, $bufferLine, FILE_APPEND | LOCK_EX);
            if ($result === false) {
                error_log("Failed to write to sensor buffer file");
                return false;
            }
            $this->checkAndTransfer();
            return true;
        } catch (Exception $e) {
            error_log("Error saving sensor data to buffer: " . $e->getMessage());
            return false;
        }
    }
    private function checkAndTransfer() {
        $transferState = $this->getTransferState();
        $now = time();
        if (($now - $transferState['last_transfer']) >= $this->transferInterval) {
            $this->transferToDatabase();
        }
        $bufferSize = $this->getBufferSize();
        if ($bufferSize >= $this->maxBufferSize) {
            $this->transferToDatabase();
        }
    }
    public function forceTransfer() {
        return $this->transferToDatabase();
    }
    private function transferToDatabase() {
        try {
            if (!file_exists($this->bufferFile)) {
                return 0;
            }
            $backupFile = $this->bufferFile . '.backup';
            $tempFile = $this->bufferFile . '.temp';
            if (!copy($this->bufferFile, $backupFile)) {
                error_log("Failed to create backup file");
                return 0;
            }
            $bufferContent = file_get_contents($backupFile);
            if (empty($bufferContent)) {
                unlink($backupFile);
                return 0;
            }
            $lines = explode("\n", trim($bufferContent));
            $transferredCount = 0;
            $failedLines = [];
            $clientDb = DatabaseConnectionProvider::client();
            foreach ($lines as $line) {
                if (empty($line)) continue;
                $sensorData = json_decode($line, true);
                if (!$sensorData) continue;
                try {
                    $stmt = $clientDb->prepare("
                        INSERT INTO raw_sensor_data (
                            temperature, humidity, ammonia, timestamp, 
                            pump_temp, pump_trigger, heat, mode, device_ip, source, data_quality
                        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'buffer', 'good')
                    ");
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
                        $sensorData['mode'] ?? null,
                        $sensorData['device_ip'] ?? null
                    ]);
                    if ($result) {
                        $transferredCount++;
                    } else {
                        $failedLines[] = $line; 
                    }
                } catch (Exception $e) {
                    error_log("Failed to insert line: " . $line . " - " . $e->getMessage());
                    $failedLines[] = $line; 
                }
            }
            if ($transferredCount > 0) {
                if (count($failedLines) > 0) {
                    file_put_contents($this->bufferFile, implode("\n", $failedLines) . "\n", LOCK_EX);
                    error_log("Kept " . count($failedLines) . " failed lines for retry");
                } else {
                    file_put_contents($this->bufferFile, '', LOCK_EX);
                }
                $this->logTransfer($transferredCount);
                $this->updateTransferState($transferredCount);
            }
            if (file_exists($backupFile)) {
                unlink($backupFile);
            }
            return $transferredCount;
        } catch (Exception $e) {
            error_log("Error transferring data to database: " . $e->getMessage());
            if (file_exists($backupFile)) {
                unlink($backupFile);
            }
            return 0;
        }
    }
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
    private function updateTransferState($transferredCount = 0) {
        $state = $this->getTransferState();
        $state['last_transfer'] = time();
        $state['total_transferred'] += $transferredCount;
        file_put_contents($this->transferStateFile, json_encode($state), LOCK_EX);
    }
    private function logTransfer($count) {
        $logEntry = date('Y-m-d H:i:s') . " - Transferred {$count} records to database\n";
        file_put_contents($this->transferLogFile, $logEntry, FILE_APPEND | LOCK_EX);
    }
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
    private function parseArduinoTimestamp($arduinoTimestamp) {
        if (!$arduinoTimestamp) {
            return date('Y-m-d H:i:s');
        }
        if (preg_match('/^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}$/', $arduinoTimestamp)) {
            return $arduinoTimestamp;
        }
        if (preg_match('/^(\d{1,2})\/(\d{1,2})\/(\d{4}) (\d{1,2}):(\d{1,2}):(\d{1,2}) (AM|PM)$/', $arduinoTimestamp, $matches)) {
            $day = $matches[1];
            $month = $matches[2];
            $year = $matches[3];
            $hour = (int)$matches[4];
            $minute = $matches[5];
            $second = $matches[6];
            $ampm = $matches[7];
            if ($ampm === 'PM' && $hour != 12) {
                $hour += 12;
            } elseif ($ampm === 'AM' && $hour == 12) {
                $hour = 0;
            }
            return sprintf('%04d-%02d-%02d %02d:%02d:%02d', $year, $month, $day, $hour, $minute, $second);
        }
        if ($arduinoTimestamp === 'RTC_ERROR' || $arduinoTimestamp === 'TIME_ERROR') {
            return date('Y-m-d H:i:s');
        }
        $parts = explode(':', $arduinoTimestamp);
        if (count($parts) === 4) {
            $days = (int)$parts[0];
            $hours = (int)$parts[1];
            $minutes = (int)$parts[2];
            $seconds = (int)$parts[3];
            $totalSeconds = ($days * 24 * 3600) + ($hours * 3600) + ($minutes * 60) + $seconds;
            $currentTime = time();
            $estimatedStartTime = $currentTime - $totalSeconds;
            return date('Y-m-d H:i:s', $estimatedStartTime);
        }
        return date('Y-m-d H:i:s');
    }
}
?>