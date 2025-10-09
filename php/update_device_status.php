<?php
/**
 * Device Status Update Script
 * Automatically marks devices as offline if they haven't been seen recently
 */

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/activity_logger.php';

class DeviceStatusUpdater {
    private $db;
    private $offlineThresholdSeconds = 10; // Mark as offline if not seen for 10 seconds (very responsive)
    private $logger;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::admin();
        $this->logger = new ActivityLogger();
    }
    
    public function updateDeviceStatus($deviceId = null) {
        try {
            $now = new DateTime();
            $updated = 0;
            
            if ($deviceId) {
                // Check specific device
                $stmt = $this->db->prepare('SELECT id, device_name, ip_address, status, last_seen FROM devices WHERE id = ?');
                $stmt->execute([$deviceId]);
                $device = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if (!$device) {
                    return ['success' => false, 'message' => 'Device not found'];
                }
                
                $devices = [$device];
                
                // Log individual device check (only for manual checks)
                $this->logger->logDeviceManagement(null, 'check_device', "Admin manually checked device '{$device['device_name']}' (ID: {$deviceId}) for status and component health");
            } else {
                // Get all devices
                $stmt = $this->db->query('SELECT id, device_name, ip_address, status, last_seen FROM devices');
                $devices = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                // Only log if this is a manual check (not automatic)
                if (isset($_GET['manual']) && $_GET['manual'] === 'true') {
                    $this->logger->logDeviceManagement(null, 'check_all_devices', 'Admin manually checked all devices for status and component health');
                }
            }
            
            foreach ($devices as $device) {
                // Always check if device is currently reachable first
                $isReachable = $this->isDeviceReachable($device['ip_address']);
                
                if (!$isReachable) {
                    // Device is not reachable, mark as offline immediately
                    $this->updateDevice($device['id'], 'down', $now);
                    $updated++;
                    continue;
                }
                
                // Device is reachable, get component status and mark as up
                $componentStatus = $this->getDeviceComponentStatus($device['ip_address']);
                $deviceStatus = $this->determineDeviceStatusFromComponents($componentStatus);
                $this->updateDeviceWithComponents($device['id'], $deviceStatus, $now, $componentStatus);
                $updated++;
            }
            
            $message = $deviceId ? "Updated device ID $deviceId" : "Updated $updated devices";
            return ['success' => true, 'updated' => $updated, 'message' => $message];
            
        } catch (Exception $e) {
            return ['success' => false, 'message' => $e->getMessage()];
        }
    }
    
    private function determineDeviceStatus($device, $now) {
        // If device has never been seen, mark as down
        if (empty($device['last_seen'])) {
            return 'down';
        }
        
        // Parse last_seen timestamp
        $lastSeen = new DateTime($device['last_seen']);
        $diffSeconds = $now->getTimestamp() - $lastSeen->getTimestamp();
        
        // If last seen more than threshold seconds ago, mark as down
        if ($diffSeconds > $this->offlineThresholdSeconds) {
            return 'down';
        }
        
        return 'up';
    }
    
    private function updateDevice($deviceId, $status, $now) {
        // When device is offline, set all components to offline as well
        if ($status === 'down') {
            $stmt = $this->db->prepare('
                UPDATE devices SET 
                    status = ?, 
                    updated_at = ?,
                    temp_humidity_sensor = "offline",
                    ammonia_sensor = "offline", 
                    thermal_camera = "offline",
                    sd_card_module = "offline",
                    component_last_checked = ?
                WHERE id = ?
            ');
            $stmt->execute([$status, $now->format('Y-m-d H:i:s'), $now->format('Y-m-d H:i:s'), $deviceId]);
        } else {
            $stmt = $this->db->prepare('UPDATE devices SET status = ?, updated_at = ? WHERE id = ?');
            $stmt->execute([$status, $now->format('Y-m-d H:i:s'), $deviceId]);
        }
    }
    
    private function getDeviceComponentStatus($ipAddress) {
        try {
            $context = stream_context_create([
                'http' => [
                    'timeout' => 3, // 3 second timeout for more reliable connection
                    'method' => 'GET',
                    'ignore_errors' => true,
                    'user_agent' => 'SWIFT-DeviceChecker/1.0'
                ]
            ]);
            
            $url = "http://$ipAddress/data";
            $result = @file_get_contents($url, false, $context);
            
            if ($result !== false && $result !== '') {
                $data = json_decode($result, true);
                if ($data && isset($data['temp']) && isset($data['hum']) && isset($data['ammonia'])) {
                    // Valid sensor data received - device is definitely online
                    if (isset($data['components'])) {
                        return $data['components'];
                    } else {
                        // Device is responding with valid data but no component info
                        return [
                            'temp_humidity_sensor' => 'active',
                            'ammonia_sensor' => 'active',
                            'thermal_camera' => 'active',
                            'sd_card_module' => 'active'
                        ];
                    }
                }
            }
            
            // If we reach here, device is not responding to HTTP request
            // This means device is turned off or not responding
            return [];
            
        } catch (Exception $e) {
            // Any exception means device is not responding properly
            return [];
        }
    }
    
    private function isDeviceReachable($ipAddress) {
        // Try HTTP port check first (more reliable for Arduino devices)
        if ($this->checkHttpPort($ipAddress)) {
            return true;
        }
        
        // If HTTP fails, try ping as backup
        return $this->pingDevice($ipAddress);
    }
    
    private function pingDevice($ipAddress) {
        // Use different ping commands based on OS
        $isWindows = (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN');
        
        if ($isWindows) {
            $command = "ping -n 1 -w 1000 $ipAddress 2>nul"; // 1 second timeout
        } else {
            $command = "ping -c 1 -W 1 $ipAddress 2>/dev/null"; // 1 second timeout
        }
        
        $output = [];
        $returnCode = 0;
        exec($command, $output, $returnCode);
        
        // Return true if ping was successful (return code 0)
        return $returnCode === 0;
    }
    
    private function checkHttpPort($ipAddress, $port = 80, $timeout = 1) {
        // Try to make an actual HTTP request to the device's data endpoint with very short timeout
        $context = stream_context_create([
            'http' => [
                'timeout' => $timeout, // 1 second timeout for immediate response
                'method' => 'GET',
                'ignore_errors' => true,
                'user_agent' => 'SWIFT-DeviceChecker/1.0'
            ]
        ]);
        
        $url = "http://$ipAddress/data";
        $result = @file_get_contents($url, false, $context);
        
        // Only consider device online if we get valid JSON data with sensor readings
        if ($result !== false && $result !== '') {
            $data = json_decode($result, true);
            if ($data && isset($data['temp']) && isset($data['hum']) && isset($data['ammonia'])) {
                return true; // Valid sensor data received
            }
        }
        
        return false; // No valid response or invalid data
    }
    
    private function determineDeviceStatusFromComponents($componentStatus) {
        // Check if we got any response from the device at all
        if (empty($componentStatus)) {
            // No response means device is completely offline (turned off)
            return 'down';
        }
        
        // If we got component data, check if device is actually responding
        // If all components are offline, it might mean device is turned off
        // We need to distinguish between "device on but components offline" vs "device off"
        
        // Check if we have any active components
        $hasActiveComponents = false;
        foreach ($componentStatus as $status) {
            if ($status === 'active') {
                $hasActiveComponents = true;
                break;
            }
        }
        
        // If we have any active components, device is definitely online
        if ($hasActiveComponents) {
            return 'up';
        }
        
        // If all components are offline, we need to check if device is reachable
        // This is handled by the getDeviceComponentStatus method
        // If we reach here with component data, device is responding but all components are offline
        return 'up';
    }
    
    private function updateDeviceWithComponents($deviceId, $status, $now, $componentStatus) {
        // Update device with component status and sensor IDs
        $stmt = $this->db->prepare('
            UPDATE devices SET 
                status = ?, 
                updated_at = ?,
                last_seen = ?,
                temp_humidity_sensor = ?,
                ammonia_sensor = ?,
                thermal_camera = ?,
                sd_card_module = ?,
                component_last_checked = ?
            WHERE id = ?
        ');
        
        $stmt->execute([
            $status,
            $now->format('Y-m-d H:i:s'),
            $now->format('Y-m-d H:i:s'),
            $componentStatus['temp_humidity_sensor'] ?? 'offline',
            $componentStatus['ammonia_sensor'] ?? 'offline',
            $componentStatus['thermal_camera'] ?? 'offline',
            $componentStatus['sd_card_module'] ?? 'offline',
            $now->format('Y-m-d H:i:s'),
            $deviceId
        ]);
    }
    
    public function checkDeviceOnline($ipAddress) {
        try {
            // Try to reach the device's data endpoint with a short timeout
            $context = stream_context_create([
                'http' => [
                    'timeout' => 2, // 2 second timeout for faster response
                    'method' => 'GET',
                    'ignore_errors' => true // Don't treat HTTP errors as exceptions
                ]
            ]);
            
            // Try to reach the device's data endpoint
            $url = "http://$ipAddress/data";
            $result = @file_get_contents($url, false, $context);
            
            // Only consider device online if we get valid sensor data
            if ($result !== false && $result !== '') {
                $data = json_decode($result, true);
                if ($data && isset($data['temp']) && isset($data['hum']) && isset($data['ammonia'])) {
                    return true; // Valid sensor data received
                }
            }
            
            return false; // No valid response or invalid data
            
        } catch (Exception $e) {
            // If we can't reach the device, it's offline
            return false;
        }
    }
    
    private function markDeviceOnline($ipAddress) {
        $stmt = $this->db->prepare('UPDATE devices SET status = "up", last_seen = NOW() WHERE ip_address = ?');
        $stmt->execute([$ipAddress]);
    }
    
    private function markDeviceOffline($ipAddress) {
        $stmt = $this->db->prepare('UPDATE devices SET status = "down" WHERE ip_address = ?');
        $stmt->execute([$ipAddress]);
    }
}

// Run the update if called directly
if (php_sapi_name() === 'cli' || (isset($_GET['run']) && $_GET['run'] === 'update')) {
    header('Content-Type: application/json');
    $updater = new DeviceStatusUpdater();
    
    // Check if specific device ID is provided
    $deviceId = isset($_GET['device_id']) ? (int)$_GET['device_id'] : null;
    $result = $updater->updateDeviceStatus($deviceId);
    echo json_encode($result);
} else {
    // Web interface for manual testing
    echo "<h1>Device Status Updater</h1>";
    echo "<p><a href='?run=update'>Update All Devices</a></p>";
    echo "<p><a href='admin_lists.php?type=devices'>View Devices</a></p>";
}
?>
