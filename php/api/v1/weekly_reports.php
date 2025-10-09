<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }
require_once __DIR__ . '/../../db.php';

try {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) throw new Exception('Invalid input');
    
    $weekStart = $input['weekStart'] ?? date('Y-m-d', strtotime('monday this week'));
    $weekEnd = date('Y-m-d', strtotime($weekStart . ' +6 days'));
    
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $weekStart)) {
        throw new Exception('Invalid week start date');
    }

    $pdo = DatabaseConnectionProvider::client();
    
    // Check if weekly report exists in database
    $stmt = $pdo->prepare('SELECT * FROM weekly_report WHERE week_start = ? AND week_end = ? LIMIT 1');
    $stmt->execute([$weekStart, $weekEnd]);
    $row = $stmt->fetch();
    
    if ($row) {
        // Use pre-computed weekly report
        $data = [
            'weekStart' => $weekStart,
            'weekEnd' => $weekEnd,
            'temperature' => [
                'min' => (float)$row['temp_min'],
                'max' => (float)$row['temp_max'],
                'avg' => (float)$row['temp_avg']
            ],
            'humidity' => [
                'min' => (float)$row['humidity_min'],
                'max' => (float)$row['humidity_max'],
                'avg' => (float)$row['humidity_avg']
            ],
            'ammonia' => [
                'min' => (float)$row['ammonia_min'],
                'max' => (float)$row['ammonia_max'],
                'avg' => (float)$row['ammonia_avg']
            ],
            'totalAlerts' => (int)($row['total_alerts'] ?? 0),
            'pumpTotalTime' => (int)($row['pump_total_time'] ?? 0),
            'heatTotalTime' => (int)($row['heat_total_time'] ?? 0),
            'dailyData' => getDailyBreakdown($pdo, $weekStart, $weekEnd)
        ];
    } else {
        // Compute weekly report from raw data
        $data = computeWeeklyFromRaw($pdo, $weekStart, $weekEnd);
    }
    
    echo json_encode(['status' => 'success', 'data' => $data]);
    
} catch (Throwable $e) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => $e->getMessage(), 'data' => null]);
}

function computeWeeklyFromRaw(PDO $pdo, string $weekStart, string $weekEnd): array {
    // Get weekly aggregates from raw data
    $stmt = $pdo->prepare('
        SELECT 
            MIN(temperature) as temp_min,
            MAX(temperature) as temp_max,
            AVG(temperature) as temp_avg,
            MIN(humidity) as humidity_min,
            MAX(humidity) as humidity_max,
            AVG(humidity) as humidity_avg,
            MIN(ammonia) as ammonia_min,
            MAX(ammonia) as ammonia_max,
            AVG(ammonia) as ammonia_avg,
            COUNT(*) as data_points
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $row = $stmt->fetch();
    
    // Get pump and heat total times
    $stmt = $pdo->prepare('
        SELECT 
            SUM(CASE WHEN pump_temp = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $controlRow = $stmt->fetch();
    
    // Count alerts (temperature > 35, ammonia > 3.5, humidity > 90)
    $stmt = $pdo->prepare('
        SELECT COUNT(*) as alert_count
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
        AND (temperature > 35 OR ammonia > 3.5 OR humidity > 90)
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $alertRow = $stmt->fetch();
    
    return [
        'weekStart' => $weekStart,
        'weekEnd' => $weekEnd,
        'temperature' => [
            'min' => round((float)$row['temp_min'], 1),
            'max' => round((float)$row['temp_max'], 1),
            'avg' => round((float)$row['temp_avg'], 1)
        ],
        'humidity' => [
            'min' => round((float)$row['humidity_min'], 1),
            'max' => round((float)$row['humidity_max'], 1),
            'avg' => round((float)$row['humidity_avg'], 1)
        ],
        'ammonia' => [
            'min' => round((float)$row['ammonia_min'], 2),
            'max' => round((float)$row['ammonia_max'], 2),
            'avg' => round((float)$row['ammonia_avg'], 2)
        ],
        'totalAlerts' => (int)($alertRow['alert_count'] ?? 0),
        'pumpTotalTime' => (int)($controlRow['pump_minutes'] ?? 0),
        'heatTotalTime' => (int)($controlRow['heat_minutes'] ?? 0),
        'dataPoints' => (int)($row['data_points'] ?? 0),
        'dailyData' => getDailyBreakdown($pdo, $weekStart, $weekEnd)
    ];
}

function getDailyBreakdown(PDO $pdo, string $weekStart, string $weekEnd): array {
    $stmt = $pdo->prepare('
        SELECT 
            DATE(timestamp) as date,
            MIN(temperature) as temp_min,
            MAX(temperature) as temp_max,
            AVG(temperature) as temp_avg,
            MIN(humidity) as humidity_min,
            MAX(humidity) as humidity_max,
            AVG(humidity) as humidity_avg,
            MIN(ammonia) as ammonia_min,
            MAX(ammonia) as ammonia_max,
            AVG(ammonia) as ammonia_avg,
            SUM(CASE WHEN pump_temp = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes,
            SUM(CASE WHEN temperature > 35 OR ammonia > 3.5 OR humidity > 90 THEN 1 ELSE 0 END) as alerts
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
        GROUP BY DATE(timestamp)
        ORDER BY date
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $rows = $stmt->fetchAll();
    
    $dailyData = [];
    foreach ($rows as $row) {
        $dailyData[] = [
            'date' => $row['date'],
            'temperature' => [
                'min' => round((float)$row['temp_min'], 1),
                'max' => round((float)$row['temp_max'], 1),
                'avg' => round((float)$row['temp_avg'], 1)
            ],
            'humidity' => [
                'min' => round((float)$row['humidity_min'], 1),
                'max' => round((float)$row['humidity_max'], 1),
                'avg' => round((float)$row['humidity_avg'], 1)
            ],
            'ammonia' => [
                'min' => round((float)$row['ammonia_min'], 2),
                'max' => round((float)$row['ammonia_max'], 2),
                'avg' => round((float)$row['ammonia_avg'], 2)
            ],
            'pumpMinutes' => (int)$row['pump_minutes'],
            'heatMinutes' => (int)$row['heat_minutes'],
            'alerts' => (int)$row['alerts']
        ];
    }
    
    return $dailyData;
}
?>
