<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/activity_logger.php';

class DeviceAccessControl {
    private $adminDb;
    private $logger;

    public function __construct() {
        $this->adminDb = DatabaseConnectionProvider::admin();
        $this->logger = new ActivityLogger();
    }

    /**
     * Validate if a user has access to a specific device
     * 
     * @param int $userId User ID
     * @param string $deviceIP Device IP address
     * @return array|false Returns device info if authorized, false if not
     */
    public function validateDeviceAccess($userId, $deviceIP) {
        try {
            $stmt = $this->adminDb->prepare("
                SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status,
                       d.user_id, d.farm_id, f.farm_name, u.username
                FROM devices d
                LEFT JOIN farms f ON f.id = d.farm_id
                LEFT JOIN users u ON u.id = d.user_id
                WHERE d.ip_address = ? AND d.user_id = ?
            ");
            $stmt->execute([$deviceIP, $userId]);
            $device = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($device) {
                $this->logger->logSystemEvent('device_access_granted', "User {$userId} accessed device {$deviceIP} ({$device['device_name']})");
                return $device;
            } else {
                $this->logger->logSystemEvent('device_access_denied', "User {$userId} denied access to device {$deviceIP}");
                return false;
            }
        } catch (Exception $e) {
            error_log("DeviceAccessControl::validateDeviceAccess error: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Check if a device IP is assigned to any user (for data transmission)
     * This is different from user-based access control
     * 
     * @param string $deviceIP Device IP address
     * @return array|false Returns device info if assigned, false if not
     */
    public function checkDeviceAssignment($deviceIP) {
        try {
            $stmt = $this->adminDb->prepare("
                SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status,
                       d.user_id, d.farm_id, f.farm_name, u.username
                FROM devices d
                LEFT JOIN farms f ON f.id = d.farm_id
                LEFT JOIN users u ON u.id = d.user_id
                WHERE d.ip_address = ?
            ");
            $stmt->execute([$deviceIP]);
            $device = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($device) {
                // Device data transmission - no longer logging to reduce activity log clutter
                return $device;
            } else {
                // Only log unauthorized access attempts
                $this->logger->logSystemEvent('device_access_denied', "Unauthorized data transmission attempt from unassigned device IP: {$deviceIP}");
                return false;
            }
        } catch (Exception $e) {
            error_log("DeviceAccessControl::checkDeviceAssignment error: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Get device information by IP address
     * 
     * @param string $deviceIP Device IP address
     * @return array|false Returns device info if found, false if not
     */
    public function getDeviceByIP($deviceIP) {
        $stmt = $this->adminDb->prepare("
            SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status,
                   d.user_id, d.farm_id, f.farm_name, u.username
            FROM devices d
            LEFT JOIN farms f ON f.id = d.farm_id
            LEFT JOIN users u ON u.id = d.user_id
            WHERE d.ip_address = ?
        ");
        $stmt->execute([$deviceIP]);
        $device = $stmt->fetch(PDO::FETCH_ASSOC);
        return $device ? $device : false;
    }

    /**
     * Get all devices assigned to a specific user
     * 
     * @param int $userId User ID
     * @return array Array of device information
     */
    public function getDevicesByUserId($userId) {
        $stmt = $this->adminDb->prepare("
            SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status,
                   d.last_seen, d.farm_id, f.farm_name,
                   d.temp_humidity_sensor, d.ammonia_sensor, d.thermal_camera, 
                   d.sd_card_module, d.rtc_module, d.component_last_checked
            FROM devices d
            LEFT JOIN farms f ON f.id = d.farm_id
            WHERE d.user_id = ?
            ORDER BY d.device_name
        ");
        $stmt->execute([$userId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Update device status and component information
     * 
     * @param string $deviceIP Device IP address
     * @param string $status Device status (up/down/maintenance)
     * @param array $componentStatus Component status array
     * @return bool True if updated successfully, false otherwise
     */
    public function updateDeviceStatus($deviceIP, $status, $componentStatus) {
        $device = $this->getDeviceByIP($deviceIP);
        if (!$device) {
            error_log("DeviceAccessControl: Attempted to update status for unassigned device IP: {$deviceIP}");
            return false;
        }

        $stmt = $this->adminDb->prepare("
            UPDATE devices SET
                status = ?,
                last_seen = NOW(),
                temp_humidity_sensor = ?,
                ammonia_sensor = ?,
                thermal_camera = ?,
                sd_card_module = ?,
                rtc_module = ?,
                arduino_timestamp = ?,
                component_last_checked = NOW(),
                updated_at = NOW()
            WHERE id = ?
        ");

        $stmt->execute([
            $status,
            $componentStatus['temp_humidity_sensor'] ?? 'offline',
            $componentStatus['ammonia_sensor'] ?? 'offline',
            $componentStatus['thermal_camera'] ?? 'offline',
            $componentStatus['sd_card_module'] ?? 'offline',
            $componentStatus['rtc_module'] ?? 'offline', // Assuming RTC module status is passed or derived
            $componentStatus['arduino_timestamp'] ?? 'active', // Arduino timestamp is always active
            $device['id']
        ]);
        return true;
    }

    /**
     * Get current user ID from session or headers
     * 
     * @return int|null User ID if found, null otherwise
     */
    public function getCurrentUserId() {
        // Check session first
        if (session_status() === PHP_SESSION_ACTIVE && isset($_SESSION['user_id'])) {
            return (int)$_SESSION['user_id'];
        }
        
        // Check for API token in headers
        $headers = function_exists('getallheaders') ? getallheaders() : [];
        if (empty($headers)) {
            // Fallback for CLI or when getallheaders() is not available
            $headers = [];
            foreach ($_SERVER as $key => $value) {
                if (strpos($key, 'HTTP_') === 0) {
                    $headerName = str_replace('_', '-', substr($key, 5));
                    $headers[$headerName] = $value;
                }
            }
        }
        if (isset($headers['Authorization'])) {
            $auth = $headers['Authorization'];
            if (strpos($auth, 'Bearer ') === 0) {
                $token = substr($auth, 7);
                // Here you would validate the token and get user ID
                // For now, we'll implement a simple token validation
                // This is a placeholder - implement proper JWT or API key validation
                return null;
            }
        }
        
        return null;
    }

    /**
     * Log device access attempt
     * 
     * @param int $userId User ID
     * @param string $deviceIP Device IP address
     * @param string $action Action being performed
     * @param bool $success Whether the access was successful
     * @return bool True if logged successfully
     */
    public function logDeviceAccess($userId, $deviceIP, $action, $success) {
        $message = $success 
            ? "Device access granted: {$action} from {$deviceIP}"
            : "Device access denied: {$action} from {$deviceIP}";
            
        return $this->logger->logActivity(
            'device_access',
            $message,
            $userId,
            null,
            $deviceIP,
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
}

/**
 * Check if a user has access to a specific device
 * 
 * @param string $deviceIP Device IP address
 * @param string $action Action being performed
 * @return array|false Returns device info if authorized, false if not
 */
function checkDeviceAccess($deviceIP, $action = 'access') {
    $accessControl = new DeviceAccessControl();
    $userId = $accessControl->getCurrentUserId();
    
    if (!$userId) {
        $accessControl->logDeviceAccess(0, $deviceIP, $action, false);
        return false;
    }
    
    $device = $accessControl->validateDeviceAccess($userId, $deviceIP);
    
    if ($device) {
        $accessControl->logDeviceAccess($userId, $deviceIP, $action, true);
        return $device;
    } else {
        $accessControl->logDeviceAccess($userId, $deviceIP, $action, false);
        return false;
    }
}

/**
 * Check if a device is assigned to any user (for data transmission from Arduino)
 * This bypasses user session requirements
 */
function checkDeviceAssignment($deviceIP) {
    $accessControl = new DeviceAccessControl();
    return $accessControl->checkDeviceAssignment($deviceIP);
}

/**
 * Get all devices for current user
 * 
 * @return array Array of device information
 */
function getUserDevices() {
    $accessControl = new DeviceAccessControl();
    $userId = $accessControl->getCurrentUserId();
    
    if (!$userId) {
        return [];
    }
    
    return $accessControl->getDevicesByUserId($userId);
}
?>
