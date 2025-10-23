<?php
/**
 * SWIFT IoT System - Device Management API
 * 
 * This API endpoint handles device management operations including
 * device registration, status updates, and configuration management.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Enable CORS for Arduino device communication
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Include database configuration
require_once '../config/database.php';

/**
 * Register a new device
 */
function registerDevice() {
    try {
        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        
        if (!$data) {
            throw new Exception('Invalid JSON data');
        }
        
        // Validate required fields
        $required_fields = ['device_name', 'device_code', 'ip_address'];
        foreach ($required_fields as $field) {
            if (!isset($data[$field]) || empty($data[$field])) {
                throw new Exception("Missing required field: $field");
            }
        }
        
        $pdo = getDBConnection();
        
        // Check if device already exists
        $stmt = $pdo->prepare("SELECT id FROM devices WHERE device_code = ? OR ip_address = ?");
        $stmt->execute([$data['device_code'], $data['ip_address']]);
        if ($stmt->fetch()) {
            throw new Exception('Device with this code or IP address already exists');
        }
        
        // Insert new device
        $stmt = $pdo->prepare("
            INSERT INTO devices (
                device_name, device_code, ip_address, mac_address, device_type,
                user_id, farm_id, static_ip, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");
        
        $result = $stmt->execute([
            $data['device_name'],
            $data['device_code'],
            $data['ip_address'],
            $data['mac_address'] ?? null,
            $data['device_type'] ?? 'sensor',
            $data['user_id'] ?? null,
            $data['farm_id'] ?? null,
            $data['static_ip'] ?? true
        ]);
        
        if (!$result) {
            throw new Exception('Failed to register device');
        }
        
        $deviceId = $pdo->lastInsertId();
        
        return [
            'success' => true,
            'message' => 'Device registered successfully',
            'device_id' => $deviceId,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Device registration error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }
}

/**
 * Get device information
 */
function getDeviceInfo($deviceId) {
    try {
        $pdo = getDBConnection();
        
        $stmt = $pdo->prepare("
            SELECT 
                d.*,
                sd.temperature,
                sd.humidity,
                sd.ammonia_level,
                sd.water_sprinkler_status,
                sd.heat_bulb_status,
                sd.timestamp as last_sensor_data,
                sd.created_at as last_data_received
            FROM devices d
            LEFT JOIN sensor_data sd ON d.id = sd.device_id
            WHERE d.id = ?
            ORDER BY sd.created_at DESC
            LIMIT 1
        ");
        
        $stmt->execute([$deviceId]);
        $device = $stmt->fetch();
        
        if (!$device) {
            throw new Exception('Device not found');
        }
        
        return [
            'success' => true,
            'device' => $device,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Get device info error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}

/**
 * Update device information
 */
function updateDeviceInfo() {
    try {
        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        
        if (!$data || !isset($data['device_id'])) {
            throw new Exception('Invalid data or missing device_id');
        }
        
        $pdo = getDBConnection();
        
        // Build update query dynamically
        $updateFields = [];
        $updateValues = [];
        
        $allowedFields = [
            'device_name', 'device_code', 'ip_address', 'mac_address',
            'device_type', 'user_id', 'farm_id', 'static_ip'
        ];
        
        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $updateFields[] = "$field = ?";
                $updateValues[] = $data[$field];
            }
        }
        
        if (empty($updateFields)) {
            throw new Exception('No valid fields to update');
        }
        
        $updateValues[] = $data['device_id'];
        
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET " . implode(', ', $updateFields) . ", updated_at = NOW()
            WHERE id = ?
        ");
        
        $result = $stmt->execute($updateValues);
        
        if (!$result) {
            throw new Exception('Failed to update device');
        }
        
        return [
            'success' => true,
            'message' => 'Device updated successfully',
            'device_id' => $data['device_id'],
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Update device error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }
}

/**
 * Delete device
 */
function deleteDevice($deviceId) {
    try {
        $pdo = getDBConnection();
        
        // Check if device exists
        $stmt = $pdo->prepare("SELECT id FROM devices WHERE id = ?");
        $stmt->execute([$deviceId]);
        if (!$stmt->fetch()) {
            throw new Exception('Device not found');
        }
        
        // Delete related data first
        $stmt = $pdo->prepare("DELETE FROM sensor_data WHERE device_id = ?");
        $stmt->execute([$deviceId]);
        
        $stmt = $pdo->prepare("DELETE FROM device_alerts WHERE device_id = ?");
        $stmt->execute([$deviceId]);
        
        $stmt = $pdo->prepare("DELETE FROM device_schedules WHERE device_id = ?");
        $stmt->execute([$deviceId]);
        
        // Delete device
        $stmt = $pdo->prepare("DELETE FROM devices WHERE id = ?");
        $result = $stmt->execute([$deviceId]);
        
        if (!$result) {
            throw new Exception('Failed to delete device');
        }
        
        return [
            'success' => true,
            'message' => 'Device deleted successfully',
            'device_id' => $deviceId,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Delete device error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }
}

/**
 * Get all devices
 */
function getAllDevices() {
    try {
        $pdo = getDBConnection();
        
        $stmt = $pdo->prepare("
            SELECT 
                d.*,
                (SELECT COUNT(*) FROM sensor_data sd WHERE sd.device_id = d.id) as data_count,
                (SELECT MAX(sd.created_at) FROM sensor_data sd WHERE sd.device_id = d.id) as last_data_time
            FROM devices d
            ORDER BY d.created_at DESC
        ");
        
        $stmt->execute();
        $devices = $stmt->fetchAll();
        
        return [
            'success' => true,
            'devices' => $devices,
            'count' => count($devices),
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Get all devices error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}

/**
 * Update device status
 */
function updateDeviceStatus() {
    try {
        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        
        if (!$data || !isset($data['device_id'])) {
            throw new Exception('Invalid data or missing device_id');
        }
        
        $pdo = getDBConnection();
        
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET status = ?, 
                last_seen = NOW(),
                updated_at = NOW()
            WHERE id = ?
        ");
        
        $result = $stmt->execute([
            $data['status'] ?? 'up',
            $data['device_id']
        ]);
        
        if (!$result) {
            throw new Exception('Failed to update device status');
        }
        
        return [
            'success' => true,
            'message' => 'Device status updated successfully',
            'device_id' => $data['device_id'],
            'status' => $data['status'],
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        error_log("Update device status error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }
}

// Route handling
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';
$deviceId = $_GET['device_id'] ?? null;

switch ($method) {
    case 'POST':
        if ($action === 'register') {
            $response = registerDevice();
        } else {
            $response = [
                'success' => false,
                'message' => 'Invalid action for POST request',
                'timestamp' => date('Y-m-d H:i:s')
            ];
        }
        break;
        
    case 'GET':
        if ($action === 'all') {
            $response = getAllDevices();
        } elseif ($deviceId) {
            $response = getDeviceInfo($deviceId);
        } else {
            $response = [
                'success' => false,
                'message' => 'Device ID required for GET request',
                'timestamp' => date('Y-m-d H:i:s')
            ];
        }
        break;
        
    case 'PUT':
        if ($action === 'update') {
            $response = updateDeviceInfo();
        } elseif ($action === 'status') {
            $response = updateDeviceStatus();
        } else {
            $response = [
                'success' => false,
                'message' => 'Invalid action for PUT request',
                'timestamp' => date('Y-m-d H:i:s')
            ];
        }
        break;
        
    case 'DELETE':
        if ($deviceId) {
            $response = deleteDevice($deviceId);
        } else {
            $response = [
                'success' => false,
                'message' => 'Device ID required for DELETE request',
                'timestamp' => date('Y-m-d H:i:s')
            ];
        }
        break;
        
    default:
        $response = [
            'success' => false,
            'message' => 'Method not allowed',
            'timestamp' => date('Y-m-d H:i:s')
        ];
        http_response_code(405);
}

// Send JSON response
echo json_encode($response, JSON_PRETTY_PRINT);
?>
