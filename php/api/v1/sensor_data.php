<?php
/**
 * SWIFT IoT System - Sensor Data API Endpoint
 * 
 * This API endpoint receives sensor data from Arduino devices
 * and stores it in the database for real-time monitoring.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Enable CORS for Arduino device communication
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Include database configuration
require_once '../config/database.php';

/**
 * Handle incoming sensor data from Arduino device
 */
function handleSensorData() {
    try {
        // Get JSON input
        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        
        if (!$data) {
            throw new Exception('Invalid JSON data');
        }
        
        // Validate required fields
        $required_fields = ['device_id', 'timestamp', 'temperature', 'humidity', 'ammonia_level'];
        foreach ($required_fields as $field) {
            if (!isset($data[$field])) {
                throw new Exception("Missing required field: $field");
            }
        }
        
        // Get database connection
        $pdo = getDBConnection();
        
        // Insert sensor data
        $stmt = $pdo->prepare("
            INSERT INTO sensor_data (
                device_id, timestamp, temperature, humidity, ammonia_level,
                water_sprinkler_status, heat_bulb_status, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
        ");
        
        $result = $stmt->execute([
            $data['device_id'],
            $data['timestamp'],
            $data['temperature'],
            $data['humidity'],
            $data['ammonia_level'],
            $data['water_sprinkler_status'] ?? 'off',
            $data['heat_bulb_status'] ?? 'off'
        ]);
        
        if (!$result) {
            throw new Exception('Failed to insert sensor data');
        }
        
        // Update device status
        updateDeviceStatus($pdo, $data);
        
        // Check for alerts
        checkEnvironmentalAlerts($pdo, $data);
        
        // Return success response
        return [
            'success' => true,
            'message' => 'Sensor data received successfully',
            'data_id' => $pdo->lastInsertId(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Sensor data API error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }
}

/**
 * Update device status and last seen timestamp
 */
function updateDeviceStatus($pdo, $data) {
    try {
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET status = 'up', 
                last_seen = NOW(),
                temp_humidity_sensor = ?,
                ammonia_sensor = ?,
                updated_at = NOW()
            WHERE id = ?
        ");
        
        $stmt->execute([
            $data['components_ok'] ? 'active' : 'error',
            $data['components_ok'] ? 'active' : 'error',
            $data['device_id']
        ]);
        
    } catch (Exception $e) {
        error_log("Device status update error: " . $e->getMessage());
    }
}

/**
 * Check for environmental alerts based on thresholds
 */
function checkEnvironmentalAlerts($pdo, $data) {
    try {
        $alerts = [];
        
        // Get system thresholds
        $tempHighThreshold = getSystemSetting('temp_high_threshold', 30.0);
        $tempLowThreshold = getSystemSetting('temp_low_threshold', 15.0);
        $ammoniaHighThreshold = getSystemSetting('ammonia_high_threshold', 50.0);
        
        // Check temperature alerts
        if ($data['temperature'] > $tempHighThreshold) {
            $alerts[] = [
                'device_id' => $data['device_id'],
                'alert_type' => 'temperature_high',
                'alert_message' => "Temperature is dangerously high: {$data['temperature']}°C",
                'threshold_value' => $tempHighThreshold,
                'current_value' => $data['temperature']
            ];
        } elseif ($data['temperature'] < $tempLowThreshold) {
            $alerts[] = [
                'device_id' => $data['device_id'],
                'alert_type' => 'temperature_low',
                'alert_message' => "Temperature is dangerously low: {$data['temperature']}°C",
                'threshold_value' => $tempLowThreshold,
                'current_value' => $data['temperature']
            ];
        }
        
        // Check ammonia alerts
        if ($data['ammonia_level'] > $ammoniaHighThreshold) {
            $alerts[] = [
                'device_id' => $data['device_id'],
                'alert_type' => 'ammonia_high',
                'alert_message' => "Ammonia level is dangerously high: {$data['ammonia_level']} ppm",
                'threshold_value' => $ammoniaHighThreshold,
                'current_value' => $data['ammonia_level']
            ];
        }
        
        // Insert alerts
        if (!empty($alerts)) {
            $stmt = $pdo->prepare("
                INSERT INTO device_alerts (
                    device_id, alert_type, alert_message, threshold_value, 
                    current_value, status, created_at
                ) VALUES (?, ?, ?, ?, ?, 'active', NOW())
            ");
            
            foreach ($alerts as $alert) {
                $stmt->execute([
                    $alert['device_id'],
                    $alert['alert_type'],
                    $alert['alert_message'],
                    $alert['threshold_value'],
                    $alert['current_value']
                ]);
            }
        }
        
    } catch (Exception $e) {
        error_log("Alert check error: " . $e->getMessage());
    }
}

/**
 * Get latest sensor data for dashboard
 */
function getLatestSensorData() {
    try {
        $pdo = getDBConnection();
        
        $stmt = $pdo->prepare("
            SELECT 
                sd.*,
                d.device_name,
                d.ip_address,
                d.status as device_status
            FROM sensor_data sd
            JOIN devices d ON sd.device_id = d.id
            ORDER BY sd.created_at DESC
            LIMIT 10
        ");
        
        $stmt->execute();
        $data = $stmt->fetchAll();
        
        return [
            'success' => true,
            'data' => $data,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Get sensor data error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}

/**
 * Get device statistics
 */
function getDeviceStatistics() {
    try {
        $pdo = getDBConnection();
        
        // Get device counts
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_devices,
                SUM(CASE WHEN status = 'up' THEN 1 ELSE 0 END) as online_devices,
                SUM(CASE WHEN status = 'down' THEN 1 ELSE 0 END) as offline_devices
            FROM devices
        ");
        $deviceStats = $stmt->fetch();
        
        // Get latest sensor readings
        $stmt = $pdo->query("
            SELECT 
                AVG(temperature) as avg_temperature,
                AVG(humidity) as avg_humidity,
                AVG(ammonia_level) as avg_ammonia
            FROM sensor_data 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
        ");
        $sensorStats = $stmt->fetch();
        
        return [
            'success' => true,
            'devices' => $deviceStats,
            'sensors' => $sensorStats,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Get device statistics error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}

// Route handling
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

switch ($method) {
    case 'POST':
        if ($action === 'sensor_data') {
            $response = handleSensorData();
        } else {
            $response = handleSensorData(); // Default action
        }
        break;
        
    case 'GET':
        switch ($action) {
            case 'latest':
                $response = getLatestSensorData();
                break;
            case 'statistics':
                $response = getDeviceStatistics();
                break;
            default:
                $response = getLatestSensorData();
        }
        break;
        
    default:
        $response = [
            'success' => false,
            'message' => 'Method not allowed',
            'timestamp' => date('Y-m-d H:i:s')
        ];
        http_response_code(405);
}

// Send JSON response
echo json_encode($response, JSON_PRETTY_PRINT);
?>
