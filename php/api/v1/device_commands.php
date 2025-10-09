<?php
// Device Commands API - Handles schedule checking and command generation
// File: php/api/v1/device_commands.php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once '../../config.php';
require_once '../../db.php';

// Initialize response
$response = ['success' => false, 'message' => '', 'commands' => []];

try {
    // Get database connection
    $pdo = DatabaseConnectionProvider::client();
    
    $method = $_SERVER['REQUEST_METHOD'];
    $input = json_decode(file_get_contents('php://input'), true);
    
    if ($method === 'POST') {
        // Get current time from Arduino or use server time
        $currentTime = $input['current_time'] ?? date('H:i');
        $currentDate = $input['current_date'] ?? date('Y-m-d');
        $currentDay = $input['current_day'] ?? strtolower(date('l'));
        
        // Check for scheduled tasks
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

// Function to check scheduled tasks
function checkScheduledTasks($pdo, $currentTime, $currentDate, $currentDay) {
    $commands = [
        'pump_on' => false,
        'pump_off' => false,
        'heat_on' => false,
        'heat_off' => false
    ];
    
    try {
        // Get all active schedules
        $sql = "SELECT 
                    id,
                    device_type,
                    schedule_time,
                    repeat_type,
                    custom_days,
                    schedule_date
                FROM device_schedules 
                WHERE is_active = 1 
                ORDER BY schedule_time ASC";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        $schedules = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($schedules as $schedule) {
            // Check if this schedule should execute now
            if (shouldExecuteSchedule($schedule, $currentTime, $currentDate, $currentDay)) {
                // Generate appropriate command
                if ($schedule['device_type'] === 'sprinkler') {
                    $commands['pump_on'] = true;
                    error_log("Schedule executed: Sprinkler at " . $currentTime);
                } elseif ($schedule['device_type'] === 'heat_bulb') {
                    $commands['heat_on'] = true;
                    error_log("Schedule executed: Heat Bulb at " . $currentTime);
                }
                
                // Log the execution
                logScheduleExecution($pdo, $schedule['id'], $currentTime, $currentDate);
            }
        }
        
        // Check for scheduled OFF times (optional - you can add this logic)
        // For now, we'll let the Arduino handle turning off devices after a certain duration
        
    } catch (Exception $e) {
        error_log('Error checking schedules: ' . $e->getMessage());
    }
    
    return $commands;
}

// Function to determine if a schedule should execute
function shouldExecuteSchedule($schedule, $currentTime, $currentDate, $currentDay) {
    // Check if time matches
    if ($schedule['schedule_time'] !== $currentTime) {
        return false;
    }
    
    // Check repeat type
    switch ($schedule['repeat_type']) {
        case 'once':
            // Execute only on the exact date
            return $schedule['schedule_date'] === $currentDate;
            
        case 'daily':
            // Execute every day
            return true;
            
        case 'weekdays':
            // Execute Monday to Friday
            return in_array($currentDay, ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']);
            
        case 'weekends':
            // Execute Saturday and Sunday
            return in_array($currentDay, ['saturday', 'sunday']);
            
        case 'custom':
            // Execute on custom days
            $customDays = json_decode($schedule['custom_days'], true);
            return is_array($customDays) && in_array($currentDay, $customDays);
            
        default:
            return false;
    }
}

// Function to log schedule execution
function logScheduleExecution($pdo, $scheduleId, $currentTime, $currentDate) {
    try {
        // Update execution count
        $sql = "UPDATE device_schedules 
                SET execution_count = execution_count + 1,
                    last_executed = NOW(),
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = :id";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':id' => $scheduleId]);
        
        // Log to system logs
        $logSql = "INSERT INTO system_logs (log_type, message, details, timestamp, source) 
                   VALUES ('info', 'Schedule executed', :details, NOW(), 'device_commands')";
        
        $logStmt = $pdo->prepare($logSql);
        $logStmt->execute([
            ':details' => json_encode([
                'schedule_id' => $scheduleId,
                'execution_time' => $currentTime,
                'execution_date' => $currentDate
            ])
        ]);
        
    } catch (Exception $e) {
        error_log('Error logging schedule execution: ' . $e->getMessage());
    }
}

// Function to get device status (for debugging)
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
?>
