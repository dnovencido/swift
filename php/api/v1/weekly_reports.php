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
    
    $stmt = $pdo->prepare('SELECT * FROM weekly_report WHERE week_start = ? AND week_end = ? LIMIT 1');
    $stmt->execute([$weekStart, $weekEnd]);
    $row = $stmt->fetch();
    
    if ($row) {
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
            'controls' => [
                'pump_on_time' => (int)($row['pump_total_time'] ?? 0),
                'heat_on_time' => (int)($row['heat_total_time'] ?? 0),
                'pump_triggers' => (int)($row['pump_triggers'] ?? 0),
                'heat_triggers' => (int)($row['heat_triggers'] ?? 0)
            ],
            'alerts' => [
                'temperature' => (int)($row['temp_alerts'] ?? 0),
                'humidity' => (int)($row['humidity_alerts'] ?? 0),
                'ammonia' => (int)($row['ammonia_alerts'] ?? 0),
                'total' => (int)($row['total_alerts'] ?? 0)
            ],
            'dailyData' => getDailyBreakdown($pdo, $weekStart, $weekEnd),
            'daily_breakdown' => getDailyBreakdown($pdo, $weekStart, $weekEnd),
            'alerts' => getAlertsForWeek($pdo, $weekStart, $weekEnd)
        ];
    } else {
        $data = computeWeeklyFromRaw($pdo, $weekStart, $weekEnd);
    }
    
    echo json_encode(['status' => 'success', 'data' => $data]);
    
} catch (Throwable $e) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => $e->getMessage(), 'data' => null]);
}

function computeWeeklyFromRaw(PDO $pdo, string $weekStart, string $weekEnd): array {
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
    
    $stmt = $pdo->prepare('
        SELECT 
            SUM(CASE WHEN water_sprinkler = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $controlRow = $stmt->fetch();
    
    $stmt = $pdo->prepare('
        SELECT 
            COUNT(*) as pump_triggers
        FROM (
            SELECT 1 FROM raw_sensor_data 
            WHERE DATE(timestamp) BETWEEN ? AND ? AND water_sprinkler = "ON"
            GROUP BY DATE(timestamp), HOUR(timestamp)
        ) as pump_groups
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $pumpTriggers = $stmt->fetch()['pump_triggers'] ?? 0;
    
    $stmt = $pdo->prepare('
        SELECT 
            COUNT(*) as heat_triggers
        FROM (
            SELECT 1 FROM raw_sensor_data 
            WHERE DATE(timestamp) BETWEEN ? AND ? AND heat = "ON"
            GROUP BY DATE(timestamp), HOUR(timestamp)
        ) as heat_groups
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $heatTriggers = $stmt->fetch()['heat_triggers'] ?? 0;
    
    $alerts = getAlertsForWeek($pdo, $weekStart, $weekEnd);
    
    $alertCounts = [
        'temperature' => 0,
        'humidity' => 0,
        'ammonia' => 0,
        'total' => count($alerts)
    ];
    
    foreach ($alerts as $alert) {
        switch ($alert['type']) {
            case 'temperature':
                $alertCounts['temperature']++;
                break;
            case 'humidity':
                $alertCounts['humidity']++;
                break;
            case 'ammonia':
                $alertCounts['ammonia']++;
                break;
        }
    }
    
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
        'totalAlerts' => $alertCounts['total'],
        'pumpTotalTime' => (int)($controlRow['pump_minutes'] ?? 0),
        'heatTotalTime' => (int)($controlRow['heat_minutes'] ?? 0),
        'controls' => [
            'pump_on_time' => (int)($controlRow['pump_minutes'] ?? 0),
            'heat_on_time' => (int)($controlRow['heat_minutes'] ?? 0),
            'pump_triggers' => (int)$pumpTriggers,
            'heat_triggers' => (int)$heatTriggers
        ],
        'alerts' => $alertCounts,
        'dataPoints' => (int)($row['data_points'] ?? 0),
        'dailyData' => getDailyBreakdown($pdo, $weekStart, $weekEnd),
        'daily_breakdown' => getDailyBreakdown($pdo, $weekStart, $weekEnd),
        'individual_alerts' => $alerts
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
            SUM(CASE WHEN water_sprinkler = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes,
            SUM(CASE WHEN temperature > 30 OR ammonia > 50 OR humidity > 80 THEN 1 ELSE 0 END) as alerts
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

function getAlertsForWeek(PDO $pdo, string $weekStart, string $weekEnd): array {
    try {
        $stmt = $pdo->prepare('
            SELECT 
                id, alert_type, alert_category, severity, parameter_name, current_value, 
                threshold_value, threshold_type, alert_message, alert_description, 
                trigger_reason, device_response, status, alert_timestamp, created_at
            FROM alerts 
            WHERE DATE(alert_timestamp) BETWEEN ? AND ?
            ORDER BY alert_timestamp DESC
        ');
        $stmt->execute([$weekStart, $weekEnd]);
        $rows = $stmt->fetchAll();
        
        $alerts = [];
        foreach ($rows as $row) {
            $alerts[] = [
                'id' => (int)$row['id'],
                'type' => $row['alert_type'],
                'category' => $row['alert_category'],
                'severity' => $row['severity'],
                'parameter' => $row['parameter_name'],
                'current_value' => $row['current_value'] ? (float)$row['current_value'] : null,
                'threshold_value' => $row['threshold_value'] ? (float)$row['threshold_value'] : null,
                'threshold_type' => $row['threshold_type'],
                'message' => $row['alert_message'],
                'description' => $row['alert_description'],
                'trigger_reason' => $row['trigger_reason'],
                'device_response' => $row['device_response'],
                'status' => $row['status'],
                'timestamp' => $row['alert_timestamp'],
                'created_at' => $row['created_at']
            ];
        }
        return $alerts;
    } catch (Exception $e) {
        error_log("Get alerts for week failed: " . $e->getMessage());
        return [];
    }
}
?>
