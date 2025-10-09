<?php
/**
 * Control Event Logger
 * Handles logging of device control events (pump, heat, mode changes)
 */

require_once __DIR__ . '/db.php';

class ControlEventLogger {
    private $db;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::client();
    }
    
    /**
     * Log a control event
     * @param int $deviceId Device ID
     * @param string $eventType Type of event (pump_on, pump_off, heat_on, heat_off, mode_change)
     * @param string $triggerReason Reason for the event
     * @param float|null $triggerValue The value that triggered the event
     * @param string|null $previousState Previous state
     * @param string $newState New state
     */
    public function logControlEvent($deviceId, $eventType, $triggerReason, $triggerValue = null, $previousState = null, $newState) {
        try {
            $stmt = $this->db->prepare("
                INSERT INTO control_events (device_id, event_type, trigger_reason, trigger_value, previous_state, new_state, event_timestamp, created_at)
                VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())
            ");
            
            $stmt->execute([
                $deviceId,
                $eventType,
                $triggerReason,
                $triggerValue,
                $previousState,
                $newState
            ]);
            
            return true;
        } catch (Exception $e) {
            error_log("Control event logging failed: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Get control events for a device
     * @param int $deviceId Device ID
     * @param int $limit Number of events to retrieve
     * @return array Array of control events
     */
    public function getControlEvents($deviceId = null, $limit = 50) {
        try {
            if ($deviceId) {
                $stmt = $this->db->prepare("
                    SELECT * FROM control_events 
                    WHERE device_id = ? 
                    ORDER BY event_timestamp DESC 
                    LIMIT ?
                ");
                $stmt->execute([$deviceId, $limit]);
            } else {
                $stmt = $this->db->prepare("
                    SELECT * FROM control_events 
                    ORDER BY event_timestamp DESC 
                    LIMIT ?
                ");
                $stmt->execute([$limit]);
            }
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            error_log("Failed to get control events: " . $e->getMessage());
            return [];
        }
    }
}
?>