<?php

require_once __DIR__ . '/db.php';

class AlertManager {
    private $db;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::client();
    }

    public function createAlert($alertData) {
        try {
            $required = ['alert_type', 'alert_category', 'severity', 'parameter_name', 'alert_message', 'alert_timestamp'];
            foreach ($required as $field) {
                if (!isset($alertData[$field])) {
                    throw new Exception("Missing required field: $field");
                }
            }
            
            $sql = "INSERT INTO alerts (
                device_id, alert_type, alert_category, severity, parameter_name,
                current_value, threshold_value, threshold_type, alert_message,
                alert_description, trigger_reason, device_response, status,
                alert_timestamp, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            
            $stmt = $this->db->prepare($sql);
            $result = $stmt->execute([
                $alertData['device_id'] ?? 1,
                $alertData['alert_type'],
                $alertData['alert_category'],
                $alertData['severity'],
                $alertData['parameter_name'],
                $alertData['current_value'] ?? null,
                $alertData['threshold_value'] ?? null,
                $alertData['threshold_type'] ?? null,
                $alertData['alert_message'],
                $alertData['alert_description'] ?? null,
                $alertData['trigger_reason'] ?? null,
                $alertData['device_response'] ?? null,
                $alertData['status'] ?? 'active',
                $alertData['alert_timestamp']
            ]);
            
            if ($result) {
                $alertId = $this->db->lastInsertId();
                
                error_log("Alert created: ID $alertId, Type: {$alertData['alert_type']}, Severity: {$alertData['severity']}");
                
                return $alertId;
            }
            
            return false;
        } catch (Exception $e) {
            error_log("Alert creation failed: " . $e->getMessage());
            return false;
        }
    }

    public function checkThresholds($sensorData, $deviceId = 1) {
        $createdAlerts = [];
        
        try {
            $stmt = $this->db->prepare("
                SELECT * FROM alert_thresholds 
                WHERE device_id = ? AND is_active = 1
            ");
            $stmt->execute([$deviceId]);
            $thresholds = $stmt->fetchAll();
            
            foreach ($thresholds as $threshold) {
                $parameter = strtolower($threshold['parameter_type']);
                $value = $sensorData[$parameter] ?? null;
                
                if ($value === null) continue;
                
                $alertCreated = false;
                
                if ($threshold['critical_min'] !== null && $value < $threshold['critical_min']) {
                    $alertCreated = $this->createAlert([
                        'device_id' => $deviceId,
                        'alert_type' => $parameter,
                        'alert_category' => 'threshold_violation',
                        'severity' => 'critical',
                        'parameter_name' => $threshold['parameter_name'],
                        'current_value' => $value,
                        'threshold_value' => $threshold['critical_min'],
                        'threshold_type' => 'min',
                        'alert_message' => "Critical: {$threshold['parameter_name']} below critical minimum ({$threshold['critical_min']}{$threshold['unit']})",
                        'alert_description' => "Current value: {$value}{$threshold['unit']} is below critical minimum threshold of {$threshold['critical_min']}{$threshold['unit']}",
                        'trigger_reason' => 'Critical threshold violation',
                        'alert_timestamp' => date('Y-m-d H:i:s')
                    ]);
                    if ($alertCreated) $createdAlerts[] = $alertCreated;
                }
                
                if ($threshold['critical_max'] !== null && $value > $threshold['critical_max']) {
                    $alertCreated = $this->createAlert([
                        'device_id' => $deviceId,
                        'alert_type' => $parameter,
                        'alert_category' => 'threshold_violation',
                        'severity' => 'critical',
                        'parameter_name' => $threshold['parameter_name'],
                        'current_value' => $value,
                        'threshold_value' => $threshold['critical_max'],
                        'threshold_type' => 'max',
                        'alert_message' => "Critical: {$threshold['parameter_name']} above critical maximum ({$threshold['critical_max']}{$threshold['unit']})",
                        'alert_description' => "Current value: {$value}{$threshold['unit']} is above critical maximum threshold of {$threshold['critical_max']}{$threshold['unit']}",
                        'trigger_reason' => 'Critical threshold violation',
                        'alert_timestamp' => date('Y-m-d H:i:s')
                    ]);
                    if ($alertCreated) $createdAlerts[] = $alertCreated;
                }
                
                if (!$alertCreated) {
                    if ($threshold['warning_min'] !== null && $value < $threshold['warning_min']) {
                        $alertCreated = $this->createAlert([
                            'device_id' => $deviceId,
                            'alert_type' => $parameter,
                            'alert_category' => 'threshold_violation',
                            'severity' => 'warning',
                            'parameter_name' => $threshold['parameter_name'],
                            'current_value' => $value,
                            'threshold_value' => $threshold['warning_min'],
                            'threshold_type' => 'min',
                            'alert_message' => "Warning: {$threshold['parameter_name']} below warning minimum ({$threshold['warning_min']}{$threshold['unit']})",
                            'alert_description' => "Current value: {$value}{$threshold['unit']} is below warning minimum threshold of {$threshold['warning_min']}{$threshold['unit']}",
                            'trigger_reason' => 'Warning threshold violation',
                            'alert_timestamp' => date('Y-m-d H:i:s')
                        ]);
                        if ($alertCreated) $createdAlerts[] = $alertCreated;
                    }
                    
                    if ($threshold['warning_max'] !== null && $value > $threshold['warning_max']) {
                        $alertCreated = $this->createAlert([
                            'device_id' => $deviceId,
                            'alert_type' => $parameter,
                            'alert_category' => 'threshold_violation',
                            'severity' => 'warning',
                            'parameter_name' => $threshold['parameter_name'],
                            'current_value' => $value,
                            'threshold_value' => $threshold['warning_max'],
                            'threshold_type' => 'max',
                            'alert_message' => "Warning: {$threshold['parameter_name']} above warning maximum ({$threshold['warning_max']}{$threshold['unit']})",
                            'alert_description' => "Current value: {$value}{$threshold['unit']} is above warning maximum threshold of {$threshold['warning_max']}{$threshold['unit']}",
                            'trigger_reason' => 'Warning threshold violation',
                            'alert_timestamp' => date('Y-m-d H:i:s')
                        ]);
                        if ($alertCreated) $createdAlerts[] = $alertCreated;
                    }
                }
            }
            
        } catch (Exception $e) {
            error_log("Threshold checking failed: " . $e->getMessage());
        }
        
        return $createdAlerts;
    }

    public function logDeviceResponse($deviceType, $action, $reason, $triggerValue = null, $deviceId = 1) {
        $deviceNames = [
            'pump' => 'Water Sprinkler',
            'heat' => 'Heat Bulb',
            'fan' => 'Ventilation Fan',
            'light' => 'Light System'
        ];
        
        $deviceName = $deviceNames[$deviceType] ?? ucfirst($deviceType);
        $actionText = $action === 'on' ? 'Activated' : 'Deactivated';
        
        return $this->createAlert([
            'device_id' => $deviceId,
            'alert_type' => 'device_response',
            'alert_category' => 'device_activation',
            'severity' => 'warning',
            'parameter_name' => $deviceName,
            'current_value' => $triggerValue,
            'threshold_value' => null,
            'threshold_type' => null,
            'alert_message' => "{$deviceName} {$actionText} - Reason: {$reason}",
            'alert_description' => "Automated device response: {$deviceName} was {$actionText} due to {$reason}",
            'trigger_reason' => $reason,
            'device_response' => "{$deviceName} {$actionText}",
            'alert_timestamp' => date('Y-m-d H:i:s')
        ]);
    }

    public function getAlerts($startDate, $endDate, $deviceId = null, $status = null) {
        try {
            $sql = "SELECT * FROM alerts WHERE DATE(alert_timestamp) BETWEEN ? AND ?";
            $params = [$startDate, $endDate];
            
            if ($deviceId !== null) {
                $sql .= " AND device_id = ?";
                $params[] = $deviceId;
            }
            
            if ($status !== null) {
                $sql .= " AND status = ?";
                $params[] = $status;
            }
            
            $sql .= " ORDER BY alert_timestamp DESC";
            
            $stmt = $this->db->prepare($sql);
            $stmt->execute($params);
            
            return $stmt->fetchAll();
        } catch (Exception $e) {
            error_log("Get alerts failed: " . $e->getMessage());
            return [];
        }
    }

    public function updateAlertStatus($alertId, $status, $userId = null, $notes = null) {
        try {
            $sql = "UPDATE alerts SET status = ?, updated_at = NOW()";
            $params = [$status];
            
            if ($status === 'acknowledged' && $userId !== null) {
                $sql .= ", acknowledged_by = ?, acknowledged_at = NOW()";
                $params[] = $userId;
            }
            
            if ($status === 'resolved') {
                $sql .= ", resolved_at = NOW()";
                if ($notes !== null) {
                    $sql .= ", resolution_notes = ?";
                    $params[] = $notes;
                }
            }
            
            $sql .= " WHERE id = ?";
            $params[] = $alertId;
            
            $stmt = $this->db->prepare($sql);
            return $stmt->execute($params);
        } catch (Exception $e) {
            error_log("Update alert status failed: " . $e->getMessage());
            return false;
        }
    }

    public function getAlertStatistics($startDate, $endDate) {
        try {
            $stmt = $this->db->prepare("
                SELECT 
                    alert_type,
                    severity,
                    COUNT(*) as count
                FROM alerts 
                WHERE DATE(alert_timestamp) BETWEEN ? AND ?
                GROUP BY alert_type, severity
                ORDER BY alert_type, severity
            ");
            $stmt->execute([$startDate, $endDate]);
            
            $stats = [];
            while ($row = $stmt->fetch()) {
                if (!isset($stats[$row['alert_type']])) {
                    $stats[$row['alert_type']] = [];
                }
                $stats[$row['alert_type']][$row['severity']] = (int)$row['count'];
            }
            
            return $stats;
        } catch (Exception $e) {
            error_log("Get alert statistics failed: " . $e->getMessage());
            return [];
        }
    }
}
?>
