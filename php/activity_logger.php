<?php
require_once __DIR__ . '/db.php';
class ActivityLogger {
    private $db;
    public function __construct() {
        $this->db = DatabaseConnectionProvider::admin();
    }
    public function logActivity($action, $description = null, $userId = null, $deviceId = null, $ipAddress = null, $userAgent = null) {
        try {
            // Only allow specific admin actions
            $allowedActions = [
                'login', 
                'logout', 
                'admin_action',
                'device_manual_check',
                'device_all_check'
            ];
            
            if (!in_array($action, $allowedActions)) {
                error_log("ActivityLogger: Attempted to log non-admin action '$action' - rejected");
                return false;
            }
            
            // Skip automatic system events (like device data transmission)
            if ($action === 'system') {
                return false; // Don't log automatic system events
            }
            
            if (!$ipAddress) {
                $ipAddress = $this->getClientIP();
            }
            if (!$userAgent) {
                $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? null;
            }
            $stmt = $this->db->prepare("
                INSERT INTO activity_logs (user_id, action, description, ip_address, created_at)
                VALUES (?, ?, ?, ?, NOW())
            ");
            $stmt->execute([
                $userId,
                $action,
                $description,
                $ipAddress
            ]);
            return true;
        } catch (Exception $e) {
            error_log("Activity logging failed: " . $e->getMessage());
            return false;
        }
    }
    public function logLogin($userId, $username) {
        return $this->logActivity(
            'login',
            "Admin user '{$username}' logged in",
            $userId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logLogout($userId, $username) {
        return $this->logActivity(
            'logout',
            "Admin user '{$username}' logged out",
            $userId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logUserCreate($adminUserId, $newUserId, $username) {
        return $this->logActivity(
            'admin_action',
            "Created new user '{$username}' (ID: {$newUserId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logUserUpdate($adminUserId, $targetUserId, $username, $changes = []) {
        $changeDesc = !empty($changes) ? ' (' . implode(', ', $changes) . ')' : '';
        return $this->logActivity(
            'admin_action',
            "Updated user '{$username}' (ID: {$targetUserId}){$changeDesc}",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logUserDelete($adminUserId, $targetUserId, $username) {
        return $this->logActivity(
            'admin_action',
            "Deleted user '{$username}' (ID: {$targetUserId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logFarmCreate($adminUserId, $farmId, $farmName) {
        return $this->logActivity(
            'admin_action',
            "Created new farm '{$farmName}' (ID: {$farmId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logFarmUpdate($adminUserId, $farmId, $farmName, $changes = []) {
        $changeDesc = !empty($changes) ? ' (' . implode(', ', $changes) . ')' : '';
        return $this->logActivity(
            'admin_action',
            "Updated farm '{$farmName}' (ID: {$farmId}){$changeDesc}",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logFarmDelete($adminUserId, $farmId, $farmName) {
        return $this->logActivity(
            'admin_action',
            "Deleted farm '{$farmName}' (ID: {$farmId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logDeviceChecker($action, $description, $userId = null) {
        return $this->logActivity(
            'system',
            $description,
            $userId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logDeviceManagement($adminUserId, $action, $description) {
        return $this->logActivity(
            'admin_action',
            $description,
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    public function logSystemEvent($action, $description) {
        // System events are no longer logged to reduce activity log clutter
        // Only log critical system events like unauthorized access attempts
        if (strpos($description, 'Unauthorized') !== false || strpos($description, 'denied') !== false) {
            return $this->logActivity('admin_action', $description, null);
        }
        return false; // Don't log routine system events
    }
    
    // Device management logging methods
    public function logDeviceAssign($adminUserId, $deviceId, $deviceName, $username, $ipAddress) {
        return $this->logActivity(
            'admin_action',
            "Assigned device '{$deviceName}' (IP: {$ipAddress}) to user '{$username}' (Device ID: {$deviceId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    public function logDeviceUpdate($adminUserId, $deviceId, $deviceName, $username, $ipAddress) {
        return $this->logActivity(
            'admin_action',
            "Updated device '{$deviceName}' (IP: {$ipAddress}) assignment for user '{$username}' (Device ID: {$deviceId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    public function logDeviceDelete($adminUserId, $deviceId, $deviceName) {
        return $this->logActivity(
            'admin_action',
            "Deleted device '{$deviceName}' (Device ID: {$deviceId})",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }

    /**
     * Log manual individual device check
     */
    public function logDeviceManualCheck($adminUserId, $deviceId, $deviceName, $ipAddress) {
        return $this->logActivity(
            'device_manual_check',
            "Manually checked device '{$deviceName}' (IP: {$ipAddress})",
            $adminUserId,
            $deviceId,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }

    /**
     * Log manual all devices check
     */
    public function logDeviceAllCheck($adminUserId, $deviceCount) {
        return $this->logActivity(
            'device_all_check',
            "Manually checked all devices ({$deviceCount} devices)",
            $adminUserId,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    private function getClientIP() {
        $ipKeys = ['HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR'];
        foreach ($ipKeys as $key) {
            if (!empty($_SERVER[$key])) {
                $ip = $_SERVER[$key];
                if (strpos($ip, ',') !== false) {
                    $ip = trim(explode(',', $ip)[0]);
                }
                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) {
                    return $ip;
                }
            }
        }
        return $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    }
}
?>