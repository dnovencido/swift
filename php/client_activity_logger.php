<?php
/**
 * Client Activity Logger
 * Handles logging of client-side activities ONLY.
 * This logger is specifically designed for client-side activities and should not be used for:
 * - Admin-side activities
 * - System-level operations
 * - Device operations
 * - Sensor data logging
 * 
 * Only logs: client actions like dashboard access, report viewing, etc.
 */

require_once __DIR__ . '/db.php';

class ClientActivityLogger {
    private $db;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::client();
    }
    
    /**
     * Log a client activity (CLIENT-ONLY)
     * Only logs activities that happen within the client interface
     * @param string $action The action performed (must be client-related)
     * @param string $description Description of the activity
     * @param int $userId User ID (null for anonymous activities)
     * @param string $ipAddress IP address of the user
     * @param string $userAgent User agent string
     */
    public function logActivity($action, $description = null, $userId = null, $ipAddress = null, $userAgent = null) {
        try {
            // Validate that this is a client-only action
            $allowedActions = ['dashboard_access', 'report_view', 'data_export', 'chart_interaction', 'client_action'];
            if (!in_array($action, $allowedActions)) {
                error_log("ClientActivityLogger: Attempted to log non-client action '$action' - rejected");
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
            error_log("Client activity logging failed: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Log dashboard access
     */
    public function logDashboardAccess($userId = null) {
        return $this->logActivity(
            'dashboard_access',
            'Client accessed dashboard',
            $userId,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    /**
     * Log report viewing
     */
    public function logReportView($reportType, $userId = null) {
        return $this->logActivity(
            'report_view',
            "Client viewed $reportType report",
            $userId,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    /**
     * Log data export
     */
    public function logDataExport($exportType, $userId = null) {
        return $this->logActivity(
            'data_export',
            "Client exported $exportType data",
            $userId,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    /**
     * Log chart interaction
     */
    public function logChartInteraction($chartType, $interaction, $userId = null) {
        return $this->logActivity(
            'chart_interaction',
            "Client interacted with $chartType chart: $interaction",
            $userId,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    /**
     * Log general client action
     */
    public function logClientAction($action, $description, $userId = null) {
        return $this->logActivity(
            'client_action',
            $description,
            $userId,
            $this->getClientIP(),
            $_SERVER['HTTP_USER_AGENT'] ?? null
        );
    }
    
    /**
     * Get client IP address
     */
    private function getClientIP() {
        $ipKeys = ['HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP', 'HTTP_CLIENT_IP', 'REMOTE_ADDR'];
        
        foreach ($ipKeys as $key) {
            if (!empty($_SERVER[$key])) {
                $ip = $_SERVER[$key];
                // Handle comma-separated IPs (from proxies)
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
