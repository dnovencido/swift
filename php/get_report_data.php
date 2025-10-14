<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
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
    $startDate = $input['start_date'] ?? null;
    $endDate = $input['end_date'] ?? null;
    $type = $input['type'] ?? 'summary';
    $period = $input['period'] ?? 'daily';
    
    $pdo = DatabaseConnectionProvider::client();
    
    if ($period === 'daily') {
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
            throw new Exception('Invalid date format. Use YYYY-MM-DD');
        }
        $data = generateDailyReport($pdo, $date, $type);
    } elseif ($period === 'weekly') {
        if ($startDate && $endDate) {
            // Use provided start and end dates
            if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $startDate) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $endDate)) {
                throw new Exception('Invalid date format. Use YYYY-MM-DD');
            }
            $data = computeWeeklyFromRaw($pdo, $startDate, $endDate);
        } else {
            // Use single date to calculate week
            if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
                throw new Exception('Invalid date format. Use YYYY-MM-DD');
            }
        $data = generateWeeklyReport($pdo, $date, $type);
        }
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

function generateDailyReport(PDO $pdo, string $date, string $type): array {
    $stmt = $pdo->prepare('SELECT * FROM daily_report WHERE date = ? LIMIT 1');
    $stmt->execute([$date]);
    $row = $stmt->fetch();
    
    if ($row) {
        $alerts = getAlertsForDate($pdo, $date);
        
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
            'alerts' => $alertCounts,
            'controls' => [
                'pump_on_time' => (int)($row['pump_on_time'] ?? 0),
                'heat_on_time' => (int)($row['heat_on_time'] ?? 0),
                'pump_triggers' => (int)($row['pump_triggers'] ?? 0),
                'heat_triggers' => (int)($row['heat_triggers'] ?? 0)
            ],
            'data_quality' => [
                'score' => (float)($row['data_quality_score'] ?? 0),
                'points_count' => (int)($row['data_points_count'] ?? 0)
            ],
            'system_status' => $row['system_status'] ?? 'unknown',
            'hourly_breakdown' => getHourlyBreakdown($pdo, $date),
            'individual_alerts' => $alerts
        ];
    } else {
        return computeDailyFromRaw($pdo, $date, $type);
    }
}

function computeDailyFromRaw(PDO $pdo, string $date, string $type): array {
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
    
    $stmt = $pdo->prepare('
        SELECT 
            SUM(CASE WHEN water_sprinkler = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $controlRow = $stmt->fetch();
    
    $stmt = $pdo->prepare('
        SELECT 
            COUNT(*) as pump_triggers
        FROM (
            SELECT 1 FROM raw_sensor_data 
            WHERE DATE(timestamp) = ? AND water_sprinkler = "ON"
            GROUP BY DATE(timestamp), HOUR(timestamp)
        ) as pump_groups
    ');
    $stmt->execute([$date]);
    $pumpTriggers = $stmt->fetch()['pump_triggers'] ?? 0;
    
    $stmt = $pdo->prepare('
        SELECT 
            COUNT(*) as heat_triggers
        FROM (
            SELECT 1 FROM raw_sensor_data 
            WHERE DATE(timestamp) = ? AND heat = "ON"
            GROUP BY DATE(timestamp), HOUR(timestamp)
        ) as heat_groups
    ');
    $stmt->execute([$date]);
    $heatTriggers = $stmt->fetch()['heat_triggers'] ?? 0;
    
    $alerts = getAlertsForDate($pdo, $date);
    
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
        'alerts' => $alertCounts,
        'controls' => [
            'pump_on_time' => (int)($controlRow['pump_minutes'] ?? 0),
            'heat_on_time' => (int)($controlRow['heat_minutes'] ?? 0),
            'pump_triggers' => (int)$pumpTriggers,
            'heat_triggers' => (int)$heatTriggers
        ],
        'data_quality' => [
            'score' => $dataQualityScore,
            'points_count' => (int)($row['data_points'] ?? 0)
        ],
        'system_status' => 'operational',
        'hourly_breakdown' => getHourlyBreakdown($pdo, $date),
        'control_events' => getControlEventsForDate($pdo, $date),
        'notable_events' => getNotableEventsForDate($pdo, $date),
        'individual_alerts' => $alerts,
        'notes' => generateDailyNotes($pdo, $date)
    ];
}

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
            SUM(CASE WHEN water_sprinkler = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes,
            SUM(CASE WHEN temperature > 30 OR humidity > 80 OR ammonia > 50 THEN 1 ELSE 0 END) as alerts
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

function getControlEventsForDate(PDO $pdo, string $date): array {
    $adminPdo = DatabaseConnectionProvider::admin();
    
    $stmt = $pdo->prepare('
        SELECT 
            ce.event_type,
            ce.trigger_reason,
            ce.trigger_value,
            ce.previous_state,
            ce.new_state,
            ce.event_timestamp,
            ce.device_id
        FROM control_events ce
        WHERE DATE(ce.event_timestamp) = ?
        ORDER BY ce.event_timestamp DESC
        LIMIT 50
    ');
    $stmt->execute([$date]);
    $rows = $stmt->fetchAll();
    
    $events = [];
    foreach ($rows as $row) {
        $deviceName = 'Unknown Device';
        if ($row['device_id']) {
            try {
                $deviceStmt = $adminPdo->prepare('SELECT device_name FROM devices WHERE id = ?');
                $deviceStmt->execute([$row['device_id']]);
                $device = $deviceStmt->fetch();
                if ($device) {
                    $deviceName = $device['device_name'];
                }
            } catch (Exception $e) {
            }
        }
        
        $events[] = [
            'time' => $row['event_timestamp'],
            'type' => $row['event_type'],
            'action' => formatEventAction($row['event_type'], $row['new_state']),
            'description' => $row['trigger_reason'],
            'trigger_value' => $row['trigger_value'],
            'device' => $deviceName
        ];
    }
    
    return $events;
}

function getAlertsForDate(PDO $pdo, string $date): array {
    try {
        $stmt = $pdo->prepare('
            SELECT 
                id,
                alert_type,
                alert_category,
                severity,
                parameter_name,
                current_value,
                threshold_value,
                threshold_type,
                alert_message,
                alert_description,
                trigger_reason,
                device_response,
                status,
                alert_timestamp,
                created_at
            FROM alerts 
            WHERE DATE(alert_timestamp) = ?
            ORDER BY alert_timestamp DESC
        ');
        $stmt->execute([$date]);
        $rows = $stmt->fetchAll();
        
        // If no alerts in alerts table, generate them from raw data
        if (empty($rows)) {
            return generateAlertsFromRawDataForDate($pdo, $date);
        }
        
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
        error_log("Get alerts for date failed: " . $e->getMessage());
        return [];
    }
}

function getNotableEventsForDate(PDO $pdo, string $date): array {
    $notableEvents = [];
    
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
        AND (temperature < 20 OR temperature > 40 OR humidity < 60 OR humidity > 80 OR ammonia > 20)
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
    
    usort($notableEvents, function($a, $b) {
        return strtotime($b['time']) - strtotime($a['time']);
    });
    
    return array_slice($notableEvents, 0, 30);
}

function generateDailyNotes(PDO $pdo, string $date): string {
    $notes = [];
    
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
            SUM(CASE WHEN water_sprinkler = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes,
            SUM(CASE WHEN temperature > 30 OR humidity > 80 OR ammonia > 50 THEN 1 ELSE 0 END) as alert_count
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $stats = $stmt->fetch();
    
    $avgTemp = round($stats['avg_temp'], 1);
    if ($avgTemp < 20) {
        $notes[] = "Low average temperature ({$avgTemp}°C) - consider checking heating system.";
    } elseif ($avgTemp > 30) {
        $notes[] = "High average temperature ({$avgTemp}°C) - cooling system working effectively.";
    } else {
        $notes[] = "Temperature within optimal range ({$avgTemp}°C average).";
    }
    
    $avgHumidity = round($stats['avg_humidity'], 1);
    if ($avgHumidity > 80) {
        $notes[] = "High humidity levels ({$avgHumidity}%) - ventilation may need attention.";
    } elseif ($avgHumidity < 40) {
        $notes[] = "Low humidity levels ({$avgHumidity}%) - consider humidification.";
    } else {
        $notes[] = "Humidity levels normal ({$avgHumidity}% average).";
    }
    
    $avgAmmonia = round($stats['avg_ammonia'], 2);
    if ($avgAmmonia > 2.0) {
        $notes[] = "Elevated ammonia levels ({$avgAmmonia}ppm) - ventilation system active.";
    } else {
        $notes[] = "Ammonia levels within safe range ({$avgAmmonia}ppm average).";
    }
    
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
    
    $alertCount = (int)$stats['alert_count'];
    if ($alertCount > 0) {
        $notes[] = "System generated {$alertCount} alerts - automated controls responded appropriately.";
    } else {
        $notes[] = "No alerts generated - system operating within normal parameters.";
    }
    
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

function calculateDataQuality(PDO $pdo, string $date): float {
    $expectedPoints = 1440;
    
    $stmt = $pdo->prepare('SELECT COUNT(*) as count FROM raw_sensor_data WHERE DATE(timestamp) = ?');
    $stmt->execute([$date]);
    $result = $stmt->fetch();
    $actualPoints = (int)$result['count'];
    
    $completenessScore = min(100, ($actualPoints / $expectedPoints) * 100);
    
    $stmt = $pdo->prepare('
        SELECT COUNT(DISTINCT HOUR(timestamp)) as hours_with_data
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
    ');
    $stmt->execute([$date]);
    $result = $stmt->fetch();
    $hoursWithData = (int)$result['hours_with_data'];
    $consistencyScore = min(100, ($hoursWithData / 24) * 100);
    
    $qualityScore = ($completenessScore * 0.7) + ($consistencyScore * 0.3);
    
    return round($qualityScore, 1);
}

function generateWeeklyReport(PDO $pdo, string $date, string $type): array {
    $weekStart = date('Y-m-d', strtotime('monday this week', strtotime($date)));
    
    return computeWeeklyFromRaw($pdo, $weekStart, date('Y-m-d', strtotime($weekStart . ' +6 days')));
}

function computeWeeklyFromRaw(PDO $pdo, string $weekStart, string $weekEnd): array {
    // Get overall weekly summary
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
    
    // Get control data (simplified without window functions)
    $stmt = $pdo->prepare('
        SELECT 
            SUM(CASE WHEN water_sprinkler = "ON" THEN 1 ELSE 0 END) as pump_minutes,
            SUM(CASE WHEN heat = "ON" THEN 1 ELSE 0 END) as heat_minutes
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $controlRow = $stmt->fetch();
    
    // Get trigger counts (simplified approach)
    $stmt = $pdo->prepare('
        SELECT 
            COUNT(DISTINCT DATE(timestamp)) as pump_triggers,
            COUNT(DISTINCT DATE(timestamp)) as heat_triggers
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
        AND (water_sprinkler = "ON" OR heat = "ON")
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $triggerRow = $stmt->fetch();
    
    // Get alerts data
    $stmt = $pdo->prepare('
        SELECT COUNT(*) as alert_count
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
        AND (temperature > 30 OR ammonia > 50 OR humidity > 80)
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $alertRow = $stmt->fetch();
    
    // Get daily breakdown
    $dailyBreakdown = [];
    $currentDate = $weekStart;
    while ($currentDate <= $weekEnd) {
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
        $stmt->execute([$currentDate]);
        $dayRow = $stmt->fetch();
        
        if ($dayRow && $dayRow['data_points'] > 0) {
            $dailyBreakdown[] = [
                'date' => $currentDate,
                'temperature' => [
                    'min' => round((float)$dayRow['temp_min'], 1),
                    'max' => round((float)$dayRow['temp_max'], 1),
                    'avg' => round((float)$dayRow['temp_avg'], 1)
                ],
                'humidity' => [
                    'min' => round((float)$dayRow['humidity_min'], 1),
                    'max' => round((float)$dayRow['humidity_max'], 1),
                    'avg' => round((float)$dayRow['humidity_avg'], 1)
                ],
                'ammonia' => [
                    'min' => round((float)$dayRow['ammonia_min'], 2),
                    'max' => round((float)$dayRow['ammonia_max'], 2),
                    'avg' => round((float)$dayRow['ammonia_avg'], 2)
                ],
                'data_points' => (int)$dayRow['data_points']
            ];
        }
        
        $currentDate = date('Y-m-d', strtotime($currentDate . ' +1 day'));
    }
    
    // Get individual alerts for the week (generate from raw data if alerts table is empty)
    $stmt = $pdo->prepare('
        SELECT 
            id,
            alert_type as type,
            parameter_name as parameter,
            current_value,
            threshold_value,
            severity,
            alert_message as message,
            alert_timestamp as timestamp,
            alert_description as description,
            trigger_reason,
            device_response,
            status
        FROM alerts 
        WHERE DATE(alert_timestamp) BETWEEN ? AND ?
        ORDER BY alert_timestamp DESC
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $individualAlerts = $stmt->fetchAll();
    
    // If no alerts in alerts table, generate them from raw sensor data
    if (empty($individualAlerts)) {
        $individualAlerts = generateAlertsFromRawData($pdo, $weekStart, $weekEnd);
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
        'controls' => [
            'pump_on_time' => (int)($controlRow['pump_minutes'] ?? 0),
            'heat_on_time' => (int)($controlRow['heat_minutes'] ?? 0),
            'pump_triggers' => (int)($triggerRow['pump_triggers'] ?? 0),
            'heat_triggers' => (int)($triggerRow['heat_triggers'] ?? 0)
        ],
        'alerts' => [
            'total' => (int)($alertRow['alert_count'] ?? 0),
            'temperature' => 0, // Will be calculated from individual alerts
            'humidity' => 0,
            'ammonia' => 0
        ],
        'daily_breakdown' => $dailyBreakdown,
        'individual_alerts' => $individualAlerts,
        'data_points' => (int)($row['data_points'] ?? 0)
    ];
}

function generateAlertsFromRawData(PDO $pdo, string $weekStart, string $weekEnd): array {
    $alerts = [];
    
    // Get sensor data that exceeds thresholds
    $stmt = $pdo->prepare('
        SELECT 
            timestamp,
            temperature,
            humidity,
            ammonia,
            water_sprinkler,
            heat
        FROM raw_sensor_data 
        WHERE DATE(timestamp) BETWEEN ? AND ?
        AND (temperature < 20 OR temperature > 40 OR humidity < 60 OR humidity > 80 OR ammonia > 20)
        ORDER BY timestamp DESC
        LIMIT 100
    ');
    $stmt->execute([$weekStart, $weekEnd]);
    $sensorData = $stmt->fetchAll();
    
    foreach ($sensorData as $index => $data) {
        $timestamp = $data['timestamp'];
        $temperature = floatval($data['temperature']);
        $humidity = floatval($data['humidity']);
        $ammonia = floatval($data['ammonia']);
        
        // Generate temperature alerts
        if ($temperature < 20 || $temperature > 40) {
            if ($temperature < 20) {
                $severity = $temperature < 15 ? 'critical' : ($temperature < 18 ? 'warning' : 'low');
                $message = 'Temperature below heat activation threshold';
                $description = 'Temperature is below 20°C - heat bulb should activate';
                $deviceResponse = $data['heat'] === 'ON' ? 'Heat bulb activated' : 'Heat bulb not activated';
            } else {
                $severity = $temperature > 45 ? 'critical' : ($temperature > 42 ? 'warning' : 'low');
                $message = 'Temperature above pump activation threshold';
                $description = 'Temperature is above 40°C - water pump should activate';
                $deviceResponse = $data['water_sprinkler'] === 'ON' ? 'Water pump activated' : 'Water pump not activated';
            }
            
            $alerts[] = [
                'id' => 'temp_' . $index,
                'type' => 'temperature',
                'parameter' => 'Temperature',
                'current_value' => $temperature,
                'threshold_value' => $temperature < 20 ? 20 : 40,
                'severity' => $severity,
                'message' => $message,
                'timestamp' => $timestamp,
                'description' => $description,
                'trigger_reason' => 'Threshold violation',
                'device_response' => $deviceResponse,
                'status' => 'active'
            ];
        }
        
        // Generate humidity alerts
        if ($humidity < 60 || $humidity > 80) {
            if ($humidity < 60) {
                $severity = $humidity < 50 ? 'critical' : 'warning';
                $message = 'Humidity below optimal range';
                $description = 'Humidity is below 60% - should be maintained at 70%';
                $deviceResponse = 'Humidification recommended';
            } else {
                $severity = $humidity > 85 ? 'critical' : 'warning';
                $message = 'Humidity above optimal range';
                $description = 'Humidity is above 80% - should be maintained at 70%';
                $deviceResponse = 'Dehumidification recommended';
            }
            
            $alerts[] = [
                'id' => 'hum_' . $index,
                'type' => 'humidity',
                'parameter' => 'Humidity',
                'current_value' => $humidity,
                'threshold_value' => $humidity < 60 ? 60 : 80,
                'severity' => $severity,
                'message' => $message,
                'timestamp' => $timestamp,
                'description' => $description,
                'trigger_reason' => 'Threshold violation',
                'device_response' => $deviceResponse,
                'status' => 'active'
            ];
        }
        
        // Generate ammonia alerts
        if ($ammonia > 20) {
            $severity = $ammonia > 30 ? 'critical' : ($ammonia > 25 ? 'warning' : 'low');
            $alerts[] = [
                'id' => 'amm_' . $index,
                'type' => 'ammonia',
                'parameter' => 'Ammonia',
                'current_value' => $ammonia,
                'threshold_value' => 20,
                'severity' => $severity,
                'message' => 'Ammonia levels exceed safe threshold',
                'timestamp' => $timestamp,
                'description' => 'Ammonia reading is above 20 ppm - should be maintained at 20 ppm',
                'trigger_reason' => 'Threshold violation',
                'device_response' => 'Ventilation recommended',
                'status' => 'active'
            ];
        }
    }
    
    // Sort alerts by timestamp (newest first)
    usort($alerts, function($a, $b) {
        return strtotime($b['timestamp']) - strtotime($a['timestamp']);
    });
    
    return $alerts;
}

function generateAlertsFromRawDataForDate(PDO $pdo, string $date): array {
    $alerts = [];
    
    // Get sensor data that exceeds thresholds for the specific date
    $stmt = $pdo->prepare('
        SELECT 
            timestamp,
            temperature,
            humidity,
            ammonia,
            water_sprinkler,
            heat
        FROM raw_sensor_data 
        WHERE DATE(timestamp) = ?
        AND (temperature < 20 OR temperature > 40 OR humidity < 60 OR humidity > 80 OR ammonia > 20)
        ORDER BY timestamp DESC
        LIMIT 100
    ');
    $stmt->execute([$date]);
    $sensorData = $stmt->fetchAll();
    
    foreach ($sensorData as $index => $data) {
        $timestamp = $data['timestamp'];
        $temperature = floatval($data['temperature']);
        $humidity = floatval($data['humidity']);
        $ammonia = floatval($data['ammonia']);
        
        // Generate temperature alerts
        if ($temperature < 20 || $temperature > 40) {
            if ($temperature < 20) {
                $severity = $temperature < 15 ? 'critical' : ($temperature < 18 ? 'warning' : 'low');
                $message = 'Temperature below heat activation threshold';
                $description = 'Temperature is below 20°C - heat bulb should activate';
                $deviceResponse = $data['heat'] === 'ON' ? 'Heat bulb activated' : 'Heat bulb not activated';
                $thresholdType = 'min';
                $thresholdValue = 20;
            } else {
                $severity = $temperature > 45 ? 'critical' : ($temperature > 42 ? 'warning' : 'low');
                $message = 'Temperature above pump activation threshold';
                $description = 'Temperature is above 40°C - water pump should activate';
                $deviceResponse = $data['water_sprinkler'] === 'ON' ? 'Water pump activated' : 'Water pump not activated';
                $thresholdType = 'max';
                $thresholdValue = 40;
            }
            
            $alerts[] = [
                'id' => 'temp_' . $index,
                'type' => 'temperature',
                'category' => 'threshold_violation',
                'parameter' => 'Temperature',
                'current_value' => $temperature,
                'threshold_value' => $thresholdValue,
                'threshold_type' => $thresholdType,
                'message' => $message,
                'description' => $description,
                'trigger_reason' => 'Threshold violation',
                'device_response' => $deviceResponse,
                'status' => 'active',
                'timestamp' => $timestamp,
                'severity' => $severity
            ];
        }
        
        // Generate humidity alerts
        if ($humidity < 60 || $humidity > 80) {
            if ($humidity < 60) {
                $severity = $humidity < 50 ? 'critical' : 'warning';
                $message = 'Humidity below optimal range';
                $description = 'Humidity is below 60% - should be maintained at 70%';
                $deviceResponse = 'Humidification recommended';
                $thresholdType = 'min';
                $thresholdValue = 60;
            } else {
                $severity = $humidity > 85 ? 'critical' : 'warning';
                $message = 'Humidity above optimal range';
                $description = 'Humidity is above 80% - should be maintained at 70%';
                $deviceResponse = 'Dehumidification recommended';
                $thresholdType = 'max';
                $thresholdValue = 80;
            }
            
            $alerts[] = [
                'id' => 'hum_' . $index,
                'type' => 'humidity',
                'category' => 'threshold_violation',
                'parameter' => 'Humidity',
                'current_value' => $humidity,
                'threshold_value' => $thresholdValue,
                'threshold_type' => $thresholdType,
                'message' => $message,
                'description' => $description,
                'trigger_reason' => 'Threshold violation',
                'device_response' => $deviceResponse,
                'status' => 'active',
                'timestamp' => $timestamp,
                'severity' => $severity
            ];
        }
        
        // Generate ammonia alerts
        if ($ammonia > 20) {
            $severity = $ammonia > 30 ? 'critical' : ($ammonia > 25 ? 'warning' : 'low');
            $alerts[] = [
                'id' => 'amm_' . $index,
                'type' => 'ammonia',
                'category' => 'threshold_violation',
                'parameter' => 'Ammonia',
                'current_value' => $ammonia,
                'threshold_value' => 20,
                'threshold_type' => 'max',
                'message' => 'Ammonia levels exceed safe threshold',
                'description' => 'Ammonia reading is above 20 ppm - should be maintained at 20 ppm',
                'trigger_reason' => 'Threshold violation',
                'device_response' => 'Ventilation recommended',
                'status' => 'active',
                'timestamp' => $timestamp,
                'severity' => $severity
            ];
        }
    }
    
    // Sort alerts by timestamp (newest first)
    usort($alerts, function($a, $b) {
        return strtotime($b['timestamp']) - strtotime($a['timestamp']);
    });
    
    return $alerts;
}
?>
