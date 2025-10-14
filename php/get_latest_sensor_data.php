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
    $stmt = $pdo->prepare('SELECT * FROM raw_sensor_data ORDER BY timestamp DESC LIMIT 1');
    $stmt->execute();
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
        'water_sprinkler' => $sensorData['water_sprinkler'] ?? $sensorData['pump_temp'] ?? null, 
        'sprinkler_trigger' => $sensorData['sprinkler_trigger'] ?? $sensorData['pump_trigger'] ?? null, 
        'heat' => $sensorData['heat'],
        'mode' => $sensorData['mode'],
        'offline_sync' => $sensorData['offline_sync'] ?? 0 
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