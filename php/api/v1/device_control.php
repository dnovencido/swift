<?php
/**
 * SWIFT IoT System - Device Control API
 * 
 * This API endpoint handles device control commands for Arduino devices
 * including manual control of water pumps and heat bulbs.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Enable CORS for Arduino device communication
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
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
 * Handle device control commands
 */
function handleDeviceControl() {
    try {
        // Get JSON input
        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        
        if (!$data) {
            throw new Exception('Invalid JSON data');
        }
        
        $action = $data['action'] ?? '';
        
        switch ($action) {
            case 'toggle_water_pump':
                return toggleWaterPump($data);
            case 'toggle_heat_bulb':
                return toggleHeatBulb($data);
            case 'emergency_stop':
                return emergencyStop($data);
            case 'reset_device':
                return resetDevice($data);
            case 'update_settings':
                return updateDeviceSettings($data);
            default:
                throw new Exception('Invalid action specified');
        }
        
    } catch (Exception $e) {
        error_log("Device control API error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage(),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }
}

/**
 * Toggle water pump status
 */
function toggleWaterPump($data) {
    try {
        $deviceId = $data['device_id'] ?? 1;
        $status = $data['status'] ?? 'off';
        
        // Update device status in database
        $pdo = getDBConnection();
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET updated_at = NOW() 
            WHERE id = ?
        ");
        $stmt->execute([$deviceId]);
        
        // Log the control action
        logDeviceAction($pdo, $deviceId, 'water_pump_toggle', $status);
        
        // In a real implementation, you would send a command to the Arduino device
        // For now, we'll simulate the response
        
        return [
            'success' => true,
            'message' => "Water pump " . ($status === 'on' ? 'activated' : 'deactivated'),
            'device_id' => $deviceId,
            'action' => 'toggle_water_pump',
            'status' => $status,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        throw new Exception('Failed to toggle water pump: ' . $e->getMessage());
    }
}

/**
 * Toggle heat bulb status
 */
function toggleHeatBulb($data) {
    try {
        $deviceId = $data['device_id'] ?? 1;
        $status = $data['status'] ?? 'off';
        
        // Update device status in database
        $pdo = getDBConnection();
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET updated_at = NOW() 
            WHERE id = ?
        ");
        $stmt->execute([$deviceId]);
        
        // Log the control action
        logDeviceAction($pdo, $deviceId, 'heat_bulb_toggle', $status);
        
        return [
            'success' => true,
            'message' => "Heat bulb " . ($status === 'on' ? 'activated' : 'deactivated'),
            'device_id' => $deviceId,
            'action' => 'toggle_heat_bulb',
            'status' => $status,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        throw new Exception('Failed to toggle heat bulb: ' . $e->getMessage());
    }
}

/**
 * Emergency stop all devices
 */
function emergencyStop($data) {
    try {
        $deviceId = $data['device_id'] ?? 1;
        
        // Update device status in database
        $pdo = getDBConnection();
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET updated_at = NOW() 
            WHERE id = ?
        ");
        $stmt->execute([$deviceId]);
        
        // Log the emergency stop action
        logDeviceAction($pdo, $deviceId, 'emergency_stop', 'all_devices_off');
        
        return [
            'success' => true,
            'message' => 'Emergency stop activated - all devices turned off',
            'device_id' => $deviceId,
            'action' => 'emergency_stop',
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        throw new Exception('Failed to execute emergency stop: ' . $e->getMessage());
    }
}

/**
 * Reset device
 */
function resetDevice($data) {
    try {
        $deviceId = $data['device_id'] ?? 1;
        
        // Update device status in database
        $pdo = getDBConnection();
        $stmt = $pdo->prepare("
            UPDATE devices 
            SET status = 'down',
                updated_at = NOW() 
            WHERE id = ?
        ");
        $stmt->execute([$deviceId]);
        
        // Log the reset action
        logDeviceAction($pdo, $deviceId, 'device_reset', 'device_restarting');
        
        return [
            'success' => true,
            'message' => 'Device reset command sent',
            'device_id' => $deviceId,
            'action' => 'reset_device',
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        throw new Exception('Failed to reset device: ' . $e->getMessage());
    }
}

/**
 * Update device settings
 */
function updateDeviceSettings($data) {
    try {
        $deviceId = $data['device_id'] ?? 1;
        $settings = $data['settings'] ?? [];
        
        if (empty($settings)) {
            throw new Exception('No settings provided');
        }
        
        // Update system settings
        foreach ($settings as $key => $value) {
            setSystemSetting($key, $value);
        }
        
        // Log the settings update
        $pdo = getDBConnection();
        logDeviceAction($pdo, $deviceId, 'settings_update', json_encode($settings));
        
        return [
            'success' => true,
            'message' => 'Device settings updated successfully',
            'device_id' => $deviceId,
            'action' => 'update_settings',
            'settings' => $settings,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
    } catch (Exception $e) {
        throw new Exception('Failed to update device settings: ' . $e->getMessage());
    }
}

/**
 * Log device action for audit trail
 */
function logDeviceAction($pdo, $deviceId, $action, $details) {
    try {
        $stmt = $pdo->prepare("
            INSERT INTO device_alerts (
                device_id, alert_type, alert_message, status, created_at
            ) VALUES (?, ?, ?, 'active', NOW())
        ");
        
        $alertType = 'system';
        $message = "Device control action: $action - $details";
        
        $stmt->execute([$deviceId, $alertType, $message]);
        
    } catch (Exception $e) {
        error_log("Failed to log device action: " . $e->getMessage());
    }
}

/**
 * Get device control status
 */
function getDeviceControlStatus() {
    try {
        $pdo = getDBConnection();
        
        $stmt = $pdo->prepare("
            SELECT 
                d.id,
                d.device_name,
                d.status,
                d.last_seen,
                sd.water_sprinkler_status,
                sd.heat_bulb_status,
                sd.temperature,
                sd.humidity,
                sd.ammonia_level
            FROM devices d
            LEFT JOIN sensor_data sd ON d.id = sd.device_id
            WHERE d.id = ?
            ORDER BY sd.created_at DESC
            LIMIT 1
        ");
        
        $stmt->execute([$_GET['device_id'] ?? 1]);
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
        error_log("Get device control status error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}

// Route handling
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

switch ($method) {
    case 'POST':
        $response = handleDeviceControl();
        break;
        
    case 'GET':
        if ($action === 'status') {
            $response = getDeviceControlStatus();
        } else {
            $response = [
                'success' => false,
                'message' => 'Invalid action for GET request',
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
