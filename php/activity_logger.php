<?php
/**
 * Activity Logger (ADMIN-ONLY)
 * Handles logging of admin interface activities ONLY.
 * This logger is specifically designed for admin-side activities and should not be used for:
 * - User-side activities
 * - System-level operations
 * - Device operations
 * - Sensor data logging
 * 
 * Only logs: login, logout, admin_action, and system events within admin interface
 */

require_once __DIR__ . '/db.php';

class ActivityLogger {
    private $db;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::admin();
    }
    
    /**
     * Log an activity (ADMIN-ONLY)
     * Only logs activities that happen within the admin interface
     * @param string $action The action performed (must be admin-related)
     * @param string $description Description of the activity
     * @param int $userId User ID (null for system activities)
     * @param int $deviceId Device ID (null if not device-related)
     * @param string $ipAddress IP address of the user
     * @param string $userAgent User agent string
     */
    public function logActivity($action, $description = null, $userId = null, $deviceId = null, $ipAddress = null, $userAgent = null) {
        try {
            // Validate that this is an admin-only action
            $allowedActions = ['login', 'logout', 'admin_action', 'system'];
            if (!in_array($action, $allowedActions)) {
                error_log("ActivityLogger: Attempted to log non-admin action '$action' - rejected");
                return false;
            }
            
            // Get IP address if not provided
            if (!$ipAddress) {
                $ipAddress = $this->getClientIP();
            }
            
            // Get user agent if not provided
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
            // Log error but don't break the main functionality
            error_log("Activity logging failed: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Log admin login
     */
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
    
    /**
     * Log admin logout
     */
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
    
    /**
     * Log user creation
     */
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
    
    /**
     * Log user update
     */
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
    
    /**
     * Log user deletion
     */
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
    
    /**
     * Log farm creation
     */
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
    
    /**
     * Log farm update
     */
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
    
    /**
     * Log farm deletion
     */
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
    
    
    /**
     * Log device checker activities
     */
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
    
    /**
     * Log admin device management activities
     */
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
    
    /**
     * Log system events
     */
    public function logSystemEvent($action, $description) {
        return $this->logActivity(
            'system',
            $description,
            null,
            null,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    /**
     * Get client IP address
     */
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
