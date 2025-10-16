<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
require_once __DIR__ . '/db.php';
try {
    $pdo = DatabaseConnectionProvider::client();
    
    // Get device IP from session or request
    $deviceIP = null;
    if (session_status() === PHP_SESSION_ACTIVE && isset($_SESSION['user_id'])) {
        // Get user's assigned device IP
        $adminDb = DatabaseConnectionProvider::admin();
        $stmt = $adminDb->prepare("
            SELECT ip_address FROM devices 
            WHERE user_id = ? AND status = 'up' 
            ORDER BY last_seen DESC LIMIT 1
        ");
        $stmt->execute([$_SESSION['user_id']]);
        $device = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($device) {
            $deviceIP = $device['ip_address'];
        }
    }
    
    // If no device IP found, get the most recent data
    if ($deviceIP) {
        $stmt = $pdo->prepare('SELECT * FROM raw_sensor_data WHERE device_ip = ? ORDER BY timestamp DESC LIMIT 1');
        $stmt->execute([$deviceIP]);
    } else {
        $stmt = $pdo->prepare('SELECT * FROM raw_sensor_data ORDER BY timestamp DESC LIMIT 1');
        $stmt->execute();
    }
    
    $sensorData = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$sensorData) {
        echo json_encode([
            'status' => 'error',
            'message' => 'No sensor data available',
            'data' => null
        ]);
        exit;
    }
    $formattedData = [
        'timestamp' => $sensorData['timestamp'],
        'temperature' => $sensorData['temperature'],
        'humidity' => $sensorData['humidity'],
        'ammonia' => $sensorData['ammonia'],
        'thermal_temp' => $sensorData['thermal_temp'] ?? null, 
        'water_sprinkler' => $sensorData['water_sprinkler'] ?? ($sensorData['pump_temp'] ?: 'OFF'), 
        'sprinkler_trigger' => $sensorData['sprinkler_trigger'] ?? ($sensorData['pump_trigger'] ?: 'NONE'), 
        'heat' => $sensorData['heat'],
        'mode' => $sensorData['mode'],
        'offline_sync' => $sensorData['offline_sync'] ?? 0,
        'device_ip' => $sensorData['device_ip'] ?? null
    ];
    echo json_encode([
        'status' => 'success',
        'message' => 'Latest sensor data retrieved',
        'data' => $formattedData,
        'timestamp' => $sensorData['timestamp']
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to retrieve sensor data: ' . $e->getMessage(),
        'data' => null
    ]);
}
?>