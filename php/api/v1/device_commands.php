<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once '../../config.php';
require_once '../../db.php';

$response = ['success' => false, 'message' => '', 'commands' => []];

try {
    $pdo = DatabaseConnectionProvider::client();
    
    $method = $_SERVER['REQUEST_METHOD'];
    $input = json_decode(file_get_contents('php://input'), true);
    
    if ($method === 'POST') {
        $currentTime = $input['current_time'] ?? date('H:i');
        $currentDate = $input['current_date'] ?? date('Y-m-d');
        $currentDay = $input['current_day'] ?? strtolower(date('l'));
        
        $commands = checkScheduledTasks($pdo, $currentTime, $currentDate, $currentDay);
        
        $response['success'] = true;
        $response['commands'] = $commands;
        $response['message'] = 'Commands generated successfully';
        $response['debug'] = [
            'current_time' => $currentTime,
            'current_date' => $currentDate,
            'current_day' => $currentDay,
            'schedules_found' => count($commands)
        ];
    } else {
        $response['message'] = 'Method not allowed';
        http_response_code(405);
    }
    
} catch (Exception $e) {
    $response['message'] = 'Server error: ' . $e->getMessage();
    http_response_code(500);
    error_log('Device Commands API Error: ' . $e->getMessage());
}

echo json_encode($response);

function checkScheduledTasks($pdo, $currentTime, $currentDate, $currentDay) {
    $commands = [
        'pump_on' => false,
        'pump_off' => false,
        'heat_on' => false,
        'heat_off' => false,
        'duration' => 30
    ];
    
    try {
        $sql = "SELECT 
                    id,
                    device_type,
                    schedule_time,
                    repeat_type,
                    custom_days,
                    schedule_date,
                    duration_minutes,
                    last_executed
                FROM device_schedules 
                WHERE is_active = 1 
                ORDER BY schedule_time ASC";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        $schedules = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($schedules as $schedule) {
            if (shouldExecuteSchedule($schedule, $currentTime, $currentDate, $currentDay)) {
                if ($schedule['device_type'] === 'sprinkler') {
                    $commands['pump_on'] = true;
                    $commands['duration'] = $schedule['duration_minutes'] ?? 30;
                    error_log("Schedule executed: Sprinkler at " . $currentTime . " for " . $commands['duration'] . " minutes");
                } elseif ($schedule['device_type'] === 'heat_bulb') {
                    $commands['heat_on'] = true;
                    $commands['duration'] = $schedule['duration_minutes'] ?? 30;
                    error_log("Schedule executed: Heater at " . $currentTime . " for " . $commands['duration'] . " minutes");
                }
                
                logScheduleExecution($pdo, $schedule['id'], $currentTime, $currentDate);
            }
        }

    } catch (Exception $e) {
        error_log('Error checking schedules: ' . $e->getMessage());
    }
    
    return $commands;
}

function shouldExecuteSchedule($schedule, $currentTime, $currentDate, $currentDay) {
    $scheduleTime = $schedule['schedule_time'];
    $currentTimeObj = new DateTime($currentTime);
    $scheduleTimeObj = new DateTime($scheduleTime);
    
    $diff = $currentTimeObj->diff($scheduleTimeObj);
    $diffMinutes = $diff->h * 60 + $diff->i;
    
    // Allow 15-minute tolerance window for schedule execution
    if ($diffMinutes > 15) {
        return false;
    }
    
    $lastExecuted = $schedule['last_executed'] ?? null;
    if ($lastExecuted) {
        $lastExecutedDate = date('Y-m-d', strtotime($lastExecuted));
        if ($lastExecutedDate === $currentDate) {
            $lastExecutedTime = date('H:i', strtotime($lastExecuted));
            if ($lastExecutedTime === $currentTime) {
                return false;
            }
        }
    }
    
    switch ($schedule['repeat_type']) {
        case 'once':
            return $schedule['schedule_date'] === $currentDate;
            
        case 'daily':
            return true;
            
        case 'weekdays':
            return in_array($currentDay, ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']);
            
        case 'weekends':
            return in_array($currentDay, ['saturday', 'sunday']);
            
        case 'custom':
            $customDays = json_decode($schedule['custom_days'], true);
            return is_array($customDays) && in_array($currentDay, $customDays);
            
        default:
            return false;
    }
}

function logScheduleExecution($pdo, $scheduleId, $currentTime, $currentDate) {
    try {
        $getScheduleSql = "SELECT repeat_type, device_type FROM device_schedules WHERE id = :id";
        $getScheduleStmt = $pdo->prepare($getScheduleSql);
        $getScheduleStmt->execute([':id' => $scheduleId]);
        $schedule = $getScheduleStmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$schedule) {
            error_log("Schedule not found for ID: " . $scheduleId);
            return;
        }
        
        $sql = "UPDATE device_schedules 
                SET execution_count = execution_count + 1,
                    last_executed = NOW(),
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = :id";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':id' => $scheduleId]);
        
        $logSql = "INSERT INTO system_logs (log_type, message, details, timestamp, source) 
                   VALUES ('info', 'Schedule executed', :details, NOW(), 'device_commands')";
        
        $logStmt = $pdo->prepare($logSql);
        $logStmt->execute([
            ':details' => json_encode([
                'schedule_id' => $scheduleId,
                'execution_time' => $currentTime,
                'execution_date' => $currentDate,
                'device_type' => $schedule['device_type']
            ])
        ]);
        
        if ($schedule['repeat_type'] === 'once') {
            $deleteSql = "DELETE FROM device_schedules WHERE id = :id";
            $deleteStmt = $pdo->prepare($deleteSql);
            $deleteStmt->execute([':id' => $scheduleId]);
            
            $deleteLogSql = "INSERT INTO system_logs (log_type, message, details, timestamp, source) 
                           VALUES ('info', 'Schedule auto-deleted', :details, NOW(), 'device_commands')";
            
            $deleteLogStmt = $pdo->prepare($deleteLogSql);
            $deleteLogStmt->execute([
                ':details' => json_encode([
                    'schedule_id' => $scheduleId,
                    'reason' => 'Once-type schedule completed',
                    'device_type' => $schedule['device_type']
                ])
            ]);
            
            error_log("Schedule auto-deleted: " . $schedule['device_type'] . " schedule ID " . $scheduleId . " (once-type completed)");
        }
        
    } catch (Exception $e) {
        error_log('Error logging schedule execution: ' . $e->getMessage());
    }
}

function getDeviceStatus($pdo) {
    try {
        $sql = "SELECT 
                    COUNT(*) as total_schedules,
                    SUM(CASE WHEN repeat_type = 'daily' THEN 1 ELSE 0 END) as daily_schedules,
                    SUM(CASE WHEN repeat_type = 'weekdays' THEN 1 ELSE 0 END) as weekday_schedules,
                    SUM(CASE WHEN repeat_type = 'weekends' THEN 1 ELSE 0 END) as weekend_schedules,
                    SUM(CASE WHEN repeat_type = 'custom' THEN 1 ELSE 0 END) as custom_schedules,
                    SUM(CASE WHEN repeat_type = 'once' THEN 1 ELSE 0 END) as once_schedules
                FROM device_schedules 
                WHERE is_active = 1";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        
        return $stmt->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        error_log('Error getting device status: ' . $e->getMessage());
        return null;
    }
}

function cleanupExpiredSchedules($pdo) {
    try {
        $sql = "DELETE FROM device_schedules 
                WHERE end_date IS NOT NULL 
                AND end_date < CURDATE() 
                AND is_active = 1";
        
        $stmt = $pdo->prepare($sql);
        $result = $stmt->execute();
        $deletedCount = $stmt->rowCount();
        
        if ($deletedCount > 0) {
            $logSql = "INSERT INTO system_logs (log_type, message, details, timestamp, source) 
                       VALUES ('info', 'Expired schedules cleaned up', :details, NOW(), 'device_commands')";
            
            $logStmt = $pdo->prepare($logSql);
            $logStmt->execute([
                ':details' => json_encode([
                    'deleted_count' => $deletedCount,
                    'cleanup_date' => date('Y-m-d H:i:s')
                ])
            ]);
            
            error_log("Cleaned up " . $deletedCount . " expired schedules");
        }
        
        return $deletedCount;
        
    } catch (Exception $e) {
        error_log('Error cleaning up expired schedules: ' . $e->getMessage());
        return 0;
    }
}

cleanupExpiredSchedules($pdo);
?>
