<?php
require_once __DIR__ . '/db.php';
class ControlEventLogger {
    private $db;
    public function __construct() {
        $this->db = DatabaseConnectionProvider::client();
    }
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