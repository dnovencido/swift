<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/activity_logger.php';
class DeviceStatusUpdater {
    private $db;
    private $offlineThresholdSeconds = 10; 
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
                $stmt = $this->db->prepare('SELECT id, device_name, ip_address, status, last_seen FROM devices WHERE id = ?');
                $stmt->execute([$deviceId]);
                $device = $stmt->fetch(PDO::FETCH_ASSOC);
                if (!$device) {
                    return ['success' => false, 'message' => 'Device not found'];
                }
                $devices = [$device];
                $this->logger->logDeviceManagement(null, 'check_device', "Admin manually checked device '{$device['device_name']}' (ID: {$deviceId}) for status and component health");
            } else {
                $stmt = $this->db->query('SELECT id, device_name, ip_address, status, last_seen FROM devices');
                $devices = $stmt->fetchAll(PDO::FETCH_ASSOC);
                if (isset($_GET['manual']) && $_GET['manual'] === 'true') {
                    $this->logger->logDeviceManagement(null, 'check_all_devices', 'Admin manually checked all devices for status and component health');
                }
            }
            foreach ($devices as $device) {
                $isReachable = $this->isDeviceReachable($device['ip_address']);
                if (!$isReachable) {
                    $this->updateDevice($device['id'], 'down', $now);
                    $updated++;
                    continue;
                }
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
        if (empty($device['last_seen'])) {
            return 'down';
        }
        $lastSeen = new DateTime($device['last_seen']);
        $diffSeconds = $now->getTimestamp() - $lastSeen->getTimestamp();
        if ($diffSeconds > $this->offlineThresholdSeconds) {
            return 'down';
        }
        return 'up';
    }
    private function updateDevice($deviceId, $status, $now) {
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
                    'timeout' => 3, 
                    'method' => 'GET',
                    'ignore_errors' => true,
                    'user_agent' => 'SWIFT-DeviceChecker/1.0'
                ]
            ]);
            $url = "http://192.168.1.100/checkdevice";//192.168.1.100/checkdevice";
            $result = @file_get_contents($url, false, $context);
            if ($result !== false && $result !== '') {
                $data = json_decode($result, true);
                if ($data && isset($data['temp']) && isset($data['hum']) && isset($data['ammonia'])) {
                    if (isset($data['components'])) {
                        return $data['components'];
                    } else {
                        return [
                            'temp_humidity_sensor' => 'active',
                            'ammonia_sensor' => 'active',
                            'thermal_camera' => 'active',
                            'sd_card_module' => 'active'
                        ];
                    }
                }
            }
            return [];
        } catch (Exception $e) {
            return [];
        }
    }
    private function isDeviceReachable($ipAddress) {
        if ($this->checkHttpPort($ipAddress)) {
            return true;
        }
        return $this->pingDevice($ipAddress);
    }
    private function pingDevice($ipAddress) {
        $isWindows = (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN');
        if ($isWindows) {
            $command = "ping -n 1 -w 1000 $ipAddress 2>nul"; 
        } else {
            $command = "ping -c 1 -W 1 $ipAddress 2>/dev/null"; 
        }
        $output = [];
        $returnCode = 0;
        exec($command, $output, $returnCode);
        return $returnCode === 0;
    }
    private function checkHttpPort($ipAddress, $port = 80, $timeout = 1) {
        $context = stream_context_create([
            'http' => [
                'timeout' => $timeout, 
                'method' => 'GET',
                'ignore_errors' => true,
                'user_agent' => 'SWIFT-DeviceChecker/1.0'
            ]
        ]);
        $url = "http://192.168.1.100/checkdevice";
        $result = @file_get_contents($url, false, $context);
        if ($result !== false && $result !== '') {
            $data = json_decode($result, true);
            if ($data && isset($data['temp']) && isset($data['hum']) && isset($data['ammonia'])) {
                return true; 
            }
        }
        return false; 
    }
    private function determineDeviceStatusFromComponents($componentStatus) {
        if (empty($componentStatus)) {
            return 'down';
        }
        $hasActiveComponents = false;
        foreach ($componentStatus as $status) {
            if ($status === 'active') {
                $hasActiveComponents = true;
                break;
            }
        }
        if ($hasActiveComponents) {
            return 'up';
        }
        return 'up';
    }
    private function updateDeviceWithComponents($deviceId, $status, $now, $componentStatus) {
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
            $context = stream_context_create([
                'http' => [
                    'timeout' => 2, 
                    'method' => 'GET',
                    'ignore_errors' => true 
                ]
            ]);
            $url = "http://192.168.1.100/checkdevice";//192.168.1.100/checkdevice";
            $result = @file_get_contents($url, false, $context);
            if ($result !== false && $result !== '') {
                $data = json_decode($result, true);
                if ($data && isset($data['temp']) && isset($data['hum']) && isset($data['ammonia'])) {
                    return true; 
                }
            }
            return false; 
        } catch (Exception $e) {
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
if (php_sapi_name() === 'cli' || (isset($_GET['run']) && $_GET['run'] === 'update')) {
    header('Content-Type: application/json');
    $updater = new DeviceStatusUpdater();
    $deviceId = isset($_GET['device_id']) ? (int)$_GET['device_id'] : null;
    $result = $updater->updateDeviceStatus($deviceId);
    echo json_encode($result);
} else {
    echo "<h1>Device Status Updater</h1>";
    echo "<p><a href='?run=update'>Update All Devices</a></p>";
    echo "<p><a href='admin_lists.php?type=devices'>View Devices</a></p>";
}
?>