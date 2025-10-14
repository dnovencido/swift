<?php
require_once __DIR__ . '/control_event_logger.php';
require_once __DIR__ . '/client_activity_logger.php';
class SystemEventLogger {
    private $controlLogger;
    private $activityLogger;
    public function __construct() {
        $this->controlLogger = new ControlEventLogger();
        $this->activityLogger = new ClientActivityLogger();
    }
    public function logPumpEvent($deviceId, $action, $reason, $temperature = null) {
        $eventType = $action === 'ON' ? 'pump_on' : 'pump_off';
        $this->controlLogger->logControlEvent(
            $deviceId,
            $eventType,
            $reason,
            $temperature,
            $action === 'ON' ? 'OFF' : 'ON',
            $action
        );
    }
    public function logHeatEvent($deviceId, $action, $reason, $temperature = null) {
        $eventType = $action === 'ON' ? 'heat_on' : 'heat_off';
        $this->controlLogger->logControlEvent(
            $deviceId,
            $eventType,
            $reason,
            $temperature,
            $action === 'ON' ? 'OFF' : 'ON',
            $action
        );
    }
    public function logModeChange($deviceId, $newMode, $previousMode = null) {
        $this->controlLogger->logControlEvent(
            $deviceId,
            'mode_change',
            'Manual mode change',
            null,
            $previousMode,
            $newMode
        );
    }
    public function logDashboardAccess($userId = null) {
        $this->activityLogger->logActivity(
            'dashboard_access',
            'User accessed dashboard',
            $userId
        );
    }
    public function logSensorDataReceived($deviceId, $dataCount = 1) {
        $this->activityLogger->logActivity(
            'sensor_data_received',
            "Received $dataCount sensor readings from device",
            null
        );
    }
}
?>