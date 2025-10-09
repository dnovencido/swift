<?php
// Device Schedules API - Handles CRUD operations for device schedules
// File: php/api/v1/schedules.php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once '../../config.php';
require_once '../../db.php';

// Initialize response
$response = ['success' => false, 'message' => '', 'data' => null];

try {
    // Get database connection
    $pdo = DatabaseConnectionProvider::client();
    
    // Debug: Log successful connection
    error_log('Schedules API: Database connection established');
    
    $method = $_SERVER['REQUEST_METHOD'];
    $input = json_decode(file_get_contents('php://input'), true);
    
    switch ($method) {
        case 'GET':
            // Fetch all schedules
            $schedules = fetchSchedules($pdo);
            $response['success'] = true;
            $response['data'] = $schedules;
            $response['message'] = 'Schedules fetched successfully';
            break;
            
        case 'POST':
            // Create new schedule
            if (validateScheduleData($input)) {
                $scheduleId = createSchedule($pdo, $input);
                $response['success'] = true;
                $response['data'] = ['id' => $scheduleId];
                $response['message'] = 'Schedule created successfully';
            } else {
                $response['message'] = 'Invalid schedule data';
            }
            break;
            
        case 'PUT':
            // Update existing schedule
            if (isset($input['id']) && validateScheduleData($input)) {
                $updated = updateSchedule($pdo, $input['id'], $input);
                if ($updated) {
                    $response['success'] = true;
                    $response['message'] = 'Schedule updated successfully';
                } else {
                    $response['message'] = 'Schedule not found or update failed';
                }
            } else {
                $response['message'] = 'Invalid schedule data or missing ID';
            }
            break;
            
        case 'DELETE':
            // Delete schedule
            if (isset($input['id'])) {
                $scheduleId = $input['id'];
                error_log("Delete request for schedule ID: " . $scheduleId);
                
                $softDelete = isset($input['soft_delete']) && $input['soft_delete'] === true;
                $deleted = deleteSchedule($pdo, $scheduleId, !$softDelete); // Default to hard delete
                
                error_log("Delete result: " . ($deleted ? 'success' : 'failed'));
                
                if ($deleted) {
                    $response['success'] = true;
                    $response['message'] = $softDelete ? 'Schedule deactivated successfully' : 'Schedule permanently deleted';
                } else {
                    $response['message'] = 'Schedule not found or delete failed';
                }
            } else {
                $response['message'] = 'Schedule ID is required';
            }
            break;
            
        case 'RESTORE':
            // Restore soft-deleted schedule
            if (isset($input['id'])) {
                $restored = restoreSchedule($pdo, $input['id']);
                if ($restored) {
                    $response['success'] = true;
                    $response['message'] = 'Schedule restored successfully';
                } else {
                    $response['message'] = 'Schedule not found or restore failed';
                }
            } else {
                $response['message'] = 'Schedule ID is required';
            }
            break;
            
        default:
            $response['message'] = 'Method not allowed';
            http_response_code(405);
            break;
    }
    
} catch (Exception $e) {
    $response['message'] = 'Server error: ' . $e->getMessage();
    http_response_code(500);
    error_log('Schedule API Error: ' . $e->getMessage());
}

echo json_encode($response);

// Function to fetch all schedules
function fetchSchedules($pdo) {
    // Check if table exists first
    $tableCheck = $pdo->query("SHOW TABLES LIKE 'device_schedules'");
    if ($tableCheck->rowCount() == 0) {
        error_log('Schedules API: device_schedules table does not exist');
        return [];
    }
    
    $sql = "SELECT 
                id,
                device_type,
                schedule_name,
                schedule_date,
                schedule_time,
                repeat_type,
                custom_days,
                is_active,
                last_executed,
                execution_count,
                created_at,
                updated_at
            FROM device_schedules 
            WHERE is_active = 1 
            ORDER BY schedule_date ASC, schedule_time ASC";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    $schedules = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Process custom_days JSON
    foreach ($schedules as &$schedule) {
        if ($schedule['custom_days']) {
            $schedule['custom_days'] = json_decode($schedule['custom_days'], true);
        } else {
            $schedule['custom_days'] = [];
        }
    }
    
    return $schedules;
}

// Function to create a new schedule
function createSchedule($pdo, $data) {
    
    $sql = "INSERT INTO device_schedules 
            (device_type, schedule_name, schedule_date, schedule_time, repeat_type, custom_days, device_id) 
            VALUES (:device_type, :schedule_name, :schedule_date, :schedule_time, :repeat_type, :custom_days, :device_id)";
    
    $stmt = $pdo->prepare($sql);
    
    $customDaysJson = null;
    if (!empty($data['custom_days'])) {
        $customDaysJson = json_encode($data['custom_days']);
    }
    
    $stmt->execute([
        ':device_type' => $data['device_type'],
        ':schedule_name' => $data['schedule_name'] ?? null,
        ':schedule_date' => $data['schedule_date'],
        ':schedule_time' => $data['schedule_time'],
        ':repeat_type' => $data['repeat_type'],
        ':custom_days' => $customDaysJson,
        ':device_id' => 1 // Default device ID, can be made dynamic later
    ]);
    
    return $pdo->lastInsertId();
}

// Function to update an existing schedule
function updateSchedule($pdo, $id, $data) {
    
    $sql = "UPDATE device_schedules 
            SET device_type = :device_type,
                schedule_name = :schedule_name,
                schedule_date = :schedule_date,
                schedule_time = :schedule_time,
                repeat_type = :repeat_type,
                custom_days = :custom_days,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = :id";
    
    $stmt = $pdo->prepare($sql);
    
    $customDaysJson = null;
    if (!empty($data['custom_days'])) {
        $customDaysJson = json_encode($data['custom_days']);
    }
    
    $stmt->execute([
        ':id' => $id,
        ':device_type' => $data['device_type'],
        ':schedule_name' => $data['schedule_name'] ?? null,
        ':schedule_date' => $data['schedule_date'],
        ':schedule_time' => $data['schedule_time'],
        ':repeat_type' => $data['repeat_type'],
        ':custom_days' => $customDaysJson
    ]);
    
    return $stmt->rowCount() > 0;
}

// Function to delete a schedule
function deleteSchedule($pdo, $id, $hardDelete = true) {
    try {
        error_log("deleteSchedule called with ID: $id, hardDelete: " . ($hardDelete ? 'true' : 'false'));
        
        if ($hardDelete) {
            // Hard delete - permanently remove from database (DEFAULT)
            $sql = "DELETE FROM device_schedules WHERE id = :id";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([':id' => $id]);
            error_log("Hard delete executed, rows affected: " . $stmt->rowCount());
        } else {
            // Soft delete - mark as inactive (optional)
            $sql = "UPDATE device_schedules SET is_active = 0, updated_at = CURRENT_TIMESTAMP WHERE id = :id";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([':id' => $id]);
            error_log("Soft delete executed, rows affected: " . $stmt->rowCount());
        }
        
        $result = $stmt->rowCount() > 0;
        error_log("Delete result: " . ($result ? 'success' : 'failed'));
        return $result;
    } catch (Exception $e) {
        error_log('Delete schedule error: ' . $e->getMessage());
        return false;
    }
}

// Function to restore a soft-deleted schedule
function restoreSchedule($pdo, $id) {
    try {
        $sql = "UPDATE device_schedules SET is_active = 1, updated_at = CURRENT_TIMESTAMP WHERE id = :id";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':id' => $id]);
        
        return $stmt->rowCount() > 0;
    } catch (Exception $e) {
        error_log('Restore schedule error: ' . $e->getMessage());
        return false;
    }
}

// Function to validate schedule data
function validateScheduleData($data) {
    $required = ['device_type', 'schedule_date', 'schedule_time', 'repeat_type'];
    
    foreach ($required as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            return false;
        }
    }
    
    // Validate device_type
    if (!in_array($data['device_type'], ['sprinkler', 'heat_bulb'])) {
        return false;
    }
    
    // Validate repeat_type
    if (!in_array($data['repeat_type'], ['once', 'daily', 'weekdays', 'weekends', 'custom'])) {
        return false;
    }
    
    // Validate custom_days for custom repeat type
    if ($data['repeat_type'] === 'custom') {
        if (empty($data['custom_days']) || !is_array($data['custom_days'])) {
            return false;
        }
    }
    
    return true;
}
?>
