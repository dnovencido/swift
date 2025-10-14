<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
require_once __DIR__ . '/db.php';
try {
    $pdo = DatabaseConnectionProvider::client();
    $timeFilter = $_GET['filter'] ?? 'hour'; 
    $limit = $_GET['limit'] ?? 100; 
    $timeRanges = [
        'minute' => '1 HOUR',
        'hour' => '1 DAY', 
        'day' => '30 DAY'
    ];
    if (!isset($timeRanges[$timeFilter])) {
        throw new Exception('Invalid time filter. Use: minute, hour, or day');
    }
    $timeRange = $timeRanges[$timeFilter];
    $currentTime = date('Y-m-d H:i:s');
    $sql = "
        SELECT 
            DATE_FORMAT(timestamp, '%Y-%m-%d %H:%i:%s') as time_label,
            AVG(temperature) as avg_temperature,
            AVG(humidity) as avg_humidity,
            AVG(ammonia) as avg_ammonia,
            COUNT(*) as data_points
        FROM raw_sensor_data 
        WHERE timestamp >= DATE_SUB(?, INTERVAL {$timeRange})
        GROUP BY ";
    switch ($timeFilter) {
        case 'minute':
            $sql = "
                SELECT 
                    DATE_FORMAT(timestamp, '%H:%i') as time_label,
                    AVG(temperature) as avg_temperature,
                    AVG(humidity) as avg_humidity,
                    AVG(ammonia) as avg_ammonia,
                    COUNT(*) as data_points
                FROM raw_sensor_data 
                WHERE timestamp >= DATE_SUB(?, INTERVAL {$timeRange})
                GROUP BY DATE_FORMAT(timestamp, '%Y-%m-%d %H:%i')
                ORDER BY timestamp DESC 
                LIMIT ?
            ";
            break;
        case 'hour':
            $sql = "
                SELECT 
                    DATE_FORMAT(timestamp, '%H:00') as time_label,
                    AVG(temperature) as avg_temperature,
                    AVG(humidity) as avg_humidity,
                    AVG(ammonia) as avg_ammonia,
                    COUNT(*) as data_points
                FROM raw_sensor_data 
                WHERE timestamp >= DATE_SUB(?, INTERVAL {$timeRange})
                GROUP BY DATE_FORMAT(timestamp, '%Y-%m-%d %H')
                ORDER BY timestamp DESC 
                LIMIT ?
            ";
            break;
        case 'day':
            $sql = "
                SELECT 
                    DATE_FORMAT(timestamp, '%m/%d') as time_label,
                    AVG(temperature) as avg_temperature,
                    AVG(humidity) as avg_humidity,
                    AVG(ammonia) as avg_ammonia,
                    COUNT(*) as data_points
                FROM raw_sensor_data 
                WHERE timestamp >= DATE_SUB(?, INTERVAL {$timeRange})
                GROUP BY DATE_FORMAT(timestamp, '%Y-%m-%d')
                ORDER BY timestamp DESC 
                LIMIT ?
            ";
            break;
    }
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$currentTime, $limit]);
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $data = array_reverse($data);
    $chartData = [
        'labels' => [],
        'datasets' => [
            [
                'label' => 'Temperature (°C)',
                'data' => [],
                'borderColor' => '#ff6b6b',
                'backgroundColor' => 'rgba(255, 107, 107, 0.1)',
                'tension' => 0.4,
                'fill' => false
            ],
            [
                'label' => 'Humidity (%)',
                'data' => [],
                'borderColor' => '#4ecdc4',
                'backgroundColor' => 'rgba(78, 205, 196, 0.1)',
                'tension' => 0.4,
                'fill' => false
            ],
            [
                'label' => 'Ammonia (ppm)',
                'data' => [],
                'borderColor' => '#45b7d1',
                'backgroundColor' => 'rgba(69, 183, 209, 0.1)',
                'tension' => 0.4,
                'fill' => false
            ]
        ]
    ];
    foreach ($data as $row) {
        $chartData['labels'][] = $row['time_label'];
        $chartData['datasets'][0]['data'][] = round($row['avg_temperature'], 1);
        $chartData['datasets'][1]['data'][] = round($row['avg_humidity'], 1);
        $chartData['datasets'][2]['data'][] = round($row['avg_ammonia'], 1);
    }
    echo json_encode([
        'status' => 'success',
        'filter' => $timeFilter,
        'data_points' => count($data),
        'chart_data' => $chartData,
        'meta' => [
            'time_range' => $timeRange,
            'total_records' => count($data),
            'generated_at' => date('Y-m-d H:i:s')
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to retrieve historical data: ' . $e->getMessage(),
        'chart_data' => null
    ]);
}
?>
