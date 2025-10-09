<?php
/**
 * Get Report Data
 * Handles daily and weekly report generation from database
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/db.php';

try {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
        throw new Exception('Invalid input');
    }
    
    $date = $input['date'] ?? date('Y-m-d');
    $type = $input['type'] ?? 'summary';
    $period = $input['period'] ?? 'daily';
    
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
        throw new Exception('Invalid date format. Use YYYY-MM-DD');
    }
    
    $pdo = DatabaseConnectionProvider::client();
    
    if ($period === 'daily') {
        $data = generateDailyReport($pdo, $date, $type);
    } elseif ($period === 'weekly') {
        $data = generateWeeklyReport($pdo, $date, $type);
    } else {
        throw new Exception('Invalid period. Use "daily" or "weekly"');
    }
    
    echo json_encode([
        'status' => 'success',
        'data' => $data,
        'generated_at' => date('Y-m-d H:i:s')
    ]);
    
} catch (Throwable $e) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage(),
        'data' => null
    ]);
}

/**
 * Generate daily report from database
 */
function generateDailyReport(PDO $pdo, string $date, string $type): array {
    // Check if daily report exists in database
    $stmt = $pdo->prepare('SELECT * FROM daily_report WHERE date = ? LIMIT 1');
    $stmt->execute([$date]);
    $row = $stmt->fetch();
    
    if ($row) {
        // Use pre-computed daily report
        return [
            'date' => $date,
            'type' => $type,
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
            'alerts' => [
                'temperature' => (int)($row['temp_alerts'] ?? 0),
                'humidity' => (int)($row['humidity_alerts'] ?? 0),
                'ammonia' => (int)($row['ammonia_alerts'] ?? 0),
                'total' => (int)($row['total_alerts'] ?? 0)
            ],
            'controls' => [
                'pump_on_time' => (int)($row['pump_on_time'] ?? 0),
                'heat_on_time' => (int)($row['heat_on_time'] ?? 0)
            ],
            'data_quality' => [
                'score' => (float)($row['data_quality_score'] ?? 0),
                'points_count' => (int)($row['data_points_count'] ?? 0)
            ],
            'system_status' => $row['system_status'] ?? 'unknown',
            'hourly_breakdown' => getHourlyBreakdown($pdo, $date)
        ];
    } else {
        // Compute daily report from raw data
        return computeDailyFromRaw($pdo, $date, $type);
    }
}

/**
 * Compute daily report from raw sensor data
 */
function computeDailyFromRaw(PDO $pdo, string $date, string $type): array {
    // Get basic statistics for the day
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
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $row = $stmt->fetch();
    
    // Get control statistics
    $stmt = $pdo->prepare('
        SELECT 
            SUM(CASE WHEN pump_temp = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $controlRow = $stmt->fetch();
    
    // Count alerts
    $stmt = $pdo->prepare('
        SELECT 
            SUM(CASE WHEN temperature > 35 THEN 1 ELSE 0 END) as temp_alerts,
            SUM(CASE WHEN humidity > 90 THEN 1 ELSE 0 END) as humidity_alerts,
            SUM(CASE WHEN ammonia > 3.5 THEN 1 ELSE 0 END) as ammonia_alerts,
            SUM(CASE WHEN temperature > 35 OR humidity > 90 OR ammonia > 3.5 THEN 1 ELSE 0 END) as total_alerts
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $alertRow = $stmt->fetch();
    
    // Calculate data quality score
    $dataQualityScore = calculateDataQuality($pdo, $date);
    
    return [
        'date' => $date,
        'type' => $type,
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
        'alerts' => [
            'temperature' => (int)($alertRow['temp_alerts'] ?? 0),
            'humidity' => (int)($alertRow['humidity_alerts'] ?? 0),
            'ammonia' => (int)($alertRow['ammonia_alerts'] ?? 0),
            'total' => (int)($alertRow['total_alerts'] ?? 0)
        ],
        'controls' => [
            'pump_on_time' => (int)($controlRow['pump_minutes'] ?? 0),
            'heat_on_time' => (int)($controlRow['heat_minutes'] ?? 0)
        ],
        'data_quality' => [
            'score' => $dataQualityScore,
            'points_count' => (int)($row['data_points'] ?? 0)
        ],
        'system_status' => 'operational',
        'hourly_breakdown' => getHourlyBreakdown($pdo, $date),
        'control_events' => getControlEventsForDate($pdo, $date),
        'notable_events' => getNotableEventsForDate($pdo, $date),
        'notes' => generateDailyNotes($pdo, $date)
    ];
}

/**
 * Get hourly breakdown for a specific date
 */
function getHourlyBreakdown(PDO $pdo, string $date): array {
    $stmt = $pdo->prepare('
        SELECT 
            HOUR(timestamp) as hour,
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
            SUM(CASE WHEN temperature > 35 OR humidity > 90 OR ammonia > 3.5 THEN 1 ELSE 0 END) as alerts
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
        GROUP BY HOUR(timestamp)
        ORDER BY hour
    ');
    $stmt->execute([$date]);
    $rows = $stmt->fetchAll();
    
    $hourlyData = [];
    foreach ($rows as $row) {
        $hourlyData[] = [
            'hour' => (int)$row['hour'],
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
            'pump_minutes' => (int)$row['pump_minutes'],
            'heat_minutes' => (int)$row['heat_minutes'],
            'alerts' => (int)$row['alerts']
        ];
    }
    
    return $hourlyData;
}

/**
 * Get control events for a specific date
 */
function getControlEventsForDate(PDO $pdo, string $date): array {
    $stmt = $pdo->prepare('
        SELECT 
            ce.event_type,
            ce.trigger_reason,
            ce.trigger_value,
            ce.previous_state,
            ce.new_state,
            ce.event_timestamp,
            d.device_name
        FROM control_events ce
        LEFT JOIN devices d ON ce.device_id = d.id
        WHERE DATE(ce.event_timestamp) = ?
        ORDER BY ce.event_timestamp DESC
        LIMIT 50
    ');
    $stmt->execute([$date]);
    $rows = $stmt->fetchAll();
    
    $events = [];
    foreach ($rows as $row) {
        $events[] = [
            'time' => $row['event_timestamp'],
            'type' => $row['event_type'],
            'action' => formatEventAction($row['event_type'], $row['new_state']),
            'description' => $row['trigger_reason'],
            'trigger_value' => $row['trigger_value'],
            'device' => $row['device_name'] ?? 'Unknown Device'
        ];
    }
    
    return $events;
}

/**
 * Get notable events for a specific date (alerts, system events, etc.)
 */
function getNotableEventsForDate(PDO $pdo, string $date): array {
    $notableEvents = [];
    
    // Get temperature alerts
    $stmt = $pdo->prepare('
        SELECT 
            timestamp,
            temperature,
            humidity,
            ammonia,
            pump_temp,
            heat
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
        AND (temperature > 35 OR humidity > 90 OR ammonia > 3.5)
        ORDER BY timestamp DESC
        LIMIT 20
    ');
    $stmt->execute([$date]);
    $alertRows = $stmt->fetchAll();
    
    foreach ($alertRows as $row) {
        $alertType = [];
        if ($row['temperature'] > 35) $alertType[] = 'High Temperature';
        if ($row['humidity'] > 90) $alertType[] = 'High Humidity';
        if ($row['ammonia'] > 3.5) $alertType[] = 'High Ammonia';
        
        $notableEvents[] = [
            'time' => $row['timestamp'],
            'type' => 'alert',
            'severity' => 'high',
            'message' => implode(', ', $alertType),
            'values' => [
                'temperature' => round($row['temperature'], 1),
                'humidity' => round($row['humidity'], 1),
                'ammonia' => round($row['ammonia'], 2)
            ],
            'controls_active' => [
                'pump' => $row['pump_temp'] === 'ON',
                'heat' => $row['heat'] === 'ON'
            ]
        ];
    }
    
    // Get system events (mode changes, device status changes)
    $stmt = $pdo->prepare('
        SELECT 
            event_timestamp,
            event_type,
            trigger_reason,
            new_state,
            previous_state
        FROM control_events 
        WHERE DATE(event_timestamp) = ?
        AND event_type IN ("mode_change", "system_event")
        ORDER BY event_timestamp DESC
        LIMIT 10
    ');
    $stmt->execute([$date]);
    $systemRows = $stmt->fetchAll();
    
    foreach ($systemRows as $row) {
        $notableEvents[] = [
            'time' => $row['event_timestamp'],
            'type' => 'system',
            'severity' => 'info',
            'message' => $row['trigger_reason'],
            'details' => [
                'event_type' => $row['event_type'],
                'new_state' => $row['new_state'],
                'previous_state' => $row['previous_state']
            ]
        ];
    }
    
    // Sort by timestamp (most recent first)
    usort($notableEvents, function($a, $b) {
        return strtotime($b['time']) - strtotime($a['time']);
    });
    
    return array_slice($notableEvents, 0, 30); // Limit to 30 most notable events
}

/**
 * Generate daily notes based on data analysis
 */
function generateDailyNotes(PDO $pdo, string $date): string {
    $notes = [];
    
    // Get daily statistics
    $stmt = $pdo->prepare('
        SELECT 
            AVG(temperature) as avg_temp,
            MIN(temperature) as min_temp,
            MAX(temperature) as max_temp,
            AVG(humidity) as avg_humidity,
            MIN(humidity) as min_humidity,
            MAX(humidity) as max_humidity,
            AVG(ammonia) as avg_ammonia,
            MIN(ammonia) as min_ammonia,
            MAX(ammonia) as max_ammonia,
            SUM(CASE WHEN pump_temp = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes,
            SUM(CASE WHEN temperature > 35 OR humidity > 90 OR ammonia > 3.5 THEN 1 ELSE 0 END) as alert_count
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $stats = $stmt->fetch();
    
    // Temperature analysis
    $avgTemp = round($stats['avg_temp'], 1);
    if ($avgTemp < 20) {
        $notes[] = "Low average temperature ({$avgTemp}°C) - consider checking heating system.";
    } elseif ($avgTemp > 30) {
        $notes[] = "High average temperature ({$avgTemp}°C) - cooling system working effectively.";
    } else {
        $notes[] = "Temperature within optimal range ({$avgTemp}°C average).";
    }
    
    // Humidity analysis
    $avgHumidity = round($stats['avg_humidity'], 1);
    if ($avgHumidity > 80) {
        $notes[] = "High humidity levels ({$avgHumidity}%) - ventilation may need attention.";
    } elseif ($avgHumidity < 40) {
        $notes[] = "Low humidity levels ({$avgHumidity}%) - consider humidification.";
    } else {
        $notes[] = "Humidity levels normal ({$avgHumidity}% average).";
    }
    
    // Ammonia analysis
    $avgAmmonia = round($stats['avg_ammonia'], 2);
    if ($avgAmmonia > 2.0) {
        $notes[] = "Elevated ammonia levels ({$avgAmmonia}ppm) - ventilation system active.";
    } else {
        $notes[] = "Ammonia levels within safe range ({$avgAmmonia}ppm average).";
    }
    
    // Control system analysis
    $pumpMinutes = (int)$stats['pump_minutes'];
    $heatMinutes = (int)$stats['heat_minutes'];
    
    if ($pumpMinutes > 0) {
        $pumpHours = round($pumpMinutes / 60, 1);
        $notes[] = "Water sprinkler system activated for {$pumpHours} hours.";
    }
    
    if ($heatMinutes > 0) {
        $heatHours = round($heatMinutes / 60, 1);
        $notes[] = "Heating system operated for {$heatHours} hours.";
    }
    
    // Alert analysis
    $alertCount = (int)$stats['alert_count'];
    if ($alertCount > 0) {
        $notes[] = "System generated {$alertCount} alerts - automated controls responded appropriately.";
    } else {
        $notes[] = "No alerts generated - system operating within normal parameters.";
    }
    
    // Data quality note
    $stmt = $pdo->prepare('SELECT COUNT(*) as count FROM raw_sensor_data WHERE DATE(timestamp) = ?');
    $stmt->execute([$date]);
    $dataCount = $stmt->fetch()['count'];
    
    if ($dataCount < 1000) {
        $notes[] = "Limited data points ({$dataCount}) - check device connectivity.";
    } else {
        $notes[] = "Good data coverage with {$dataCount} readings collected.";
    }
    
    return implode(' ', $notes);
}

/**
 * Format event action for display
 */
function formatEventAction(string $eventType, string $newState): string {
    switch ($eventType) {
        case 'pump_on':
            return 'PUMP ON';
        case 'pump_off':
            return 'PUMP OFF';
        case 'heat_on':
            return 'HEAT ON';
        case 'heat_off':
            return 'HEAT OFF';
        case 'mode_change':
            return 'MODE CHANGE';
        case 'system_event':
            return 'SYSTEM EVENT';
        default:
            return strtoupper($eventType);
    }
}

/**
 * Calculate data quality score (0-100)
 */
function calculateDataQuality(PDO $pdo, string $date): float {
    // Get expected data points (assuming 1 reading per minute = 1440 points per day)
    $expectedPoints = 1440;
    
    // Get actual data points
    $stmt = $pdo->prepare('SELECT COUNT(*) as count FROM raw_sensor_data WHERE DATE(timestamp) = ?');
    $stmt->execute([$date]);
    $result = $stmt->fetch();
    $actualPoints = (int)$result['count'];
    
    // Calculate completeness score
    $completenessScore = min(100, ($actualPoints / $expectedPoints) * 100);
    
    // Check for data gaps (missing hours)
    $stmt = $pdo->prepare('
        SELECT COUNT(DISTINCT HOUR(timestamp)) as hours_with_data
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $result = $stmt->fetch();
    $hoursWithData = (int)$result['hours_with_data'];
    $consistencyScore = min(100, ($hoursWithData / 24) * 100);
    
    // Overall quality score (weighted average)
    $qualityScore = ($completenessScore * 0.7) + ($consistencyScore * 0.3);
    
    return round($qualityScore, 1);
}

/**
 * Generate weekly report (wrapper for existing weekly_reports.php functionality)
 */
function generateWeeklyReport(PDO $pdo, string $date, string $type): array {
    // Use the existing weekly report functionality
    $weekStart = date('Y-m-d', strtotime('monday this week', strtotime($date)));
    
    // Call the weekly report computation
    return computeWeeklyFromRaw($pdo, $weekStart, date('Y-m-d', strtotime($weekStart . ' +6 days')));
}

/**
 * Compute weekly report from raw data (copied from weekly_reports.php)
 */
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
    
    // Count alerts
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
        'dataPoints' => (int)($row['data_points'] ?? 0)
    ];
}
?>
