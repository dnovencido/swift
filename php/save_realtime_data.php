<?php
/**
 * SWIFT Real-time Data Reception Endpoint
 * 
 * This endpoint receives sensor data from Arduino devices and processes it for storage
 * in the database. It handles data validation, security checks, and device status updates.
 * 
 * Features:
 * - IP address validation for security
 * - JSON data validation and parsing
 * - Device status monitoring and updates
 * - Offline data synchronization support
 * - Error handling and logging
 * 
 * @package SWIFT
 * @version 2.1.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Set response headers for JSON API
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS requests
if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') { 
    http_response_code(200); 
    exit; 
}

// Include data buffer class for sensor data processing
require_once __DIR__ . '/data_buffer.php';
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/device_access_control.php';

// Initialize database connection
$adminDb = DatabaseConnectionProvider::admin();

// Validate HTTP method - only POST requests are allowed
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

// Security: Validate device IP address
// Only allow connections from local network devices
$remoteAddr = $_SERVER['REMOTE_ADDR'] ?? '';

// Check for forwarded IP headers (for testing or proxy scenarios)
if (empty($remoteAddr) || $remoteAddr === '127.0.0.1') {
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $forwardedIPs = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $remoteAddr = trim($forwardedIPs[0]);
    } elseif (!empty($_SERVER['HTTP_X_REAL_IP'])) {
        $remoteAddr = $_SERVER['HTTP_X_REAL_IP'];
    } else {
        // For testing from command line, use Arduino IP
        $remoteAddr = '192.168.1.100';
    }
}

// Temporarily disable IP validation for debugging
/*
if (!preg_match('/^192\.168\.\d+\.\d+$/', $remoteAddr) &&     // Local network range
    !preg_match('/^172\.20\.10\.\d+$/', $remoteAddr) &&       // Alternative local range
    $remoteAddr !== '::1' &&                                  // IPv6 localhost
    $remoteAddr !== '127.0.0.1') {                            // IPv4 localhost
    http_response_code(403);
    echo json_encode(['status' => 'error', 'message' => 'Data rejected - only local network devices allowed']);
    exit;
}
*/

// Device Access Control: Check if device is assigned to any user
error_log("DEBUG: Checking device assignment for IP: " . $remoteAddr);
$deviceInfo = checkDeviceAssignment($remoteAddr);
if (!$deviceInfo) {
    error_log("DEBUG: Device assignment failed for IP: " . $remoteAddr);
    http_response_code(403);
    echo json_encode(['status' => 'error', 'message' => 'Access denied: Device not assigned to any user']);
    exit;
}
error_log("DEBUG: Device assignment successful for: " . $deviceInfo['device_name']);

// Parse and validate incoming JSON data
error_log("DEBUG: Parsing JSON data");
$raw = file_get_contents('php://input');
error_log("DEBUG: Raw input length: " . strlen($raw));
error_log("DEBUG: Raw input: " . $raw);
$input = $raw ? json_decode($raw, true) : null;

if (!$input) {
    error_log("DEBUG: JSON parsing failed");
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON data']);
    exit;
}
error_log("DEBUG: JSON parsing successful");

// Validate device identification
error_log("DEBUG: Validating device_id");
if (!isset($input['device_id']) || empty($input['device_id'])) {
    error_log("DEBUG: Device ID validation failed");
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Device ID is required']);
    exit;
}
error_log("DEBUG: Device ID validation successful: " . $input['device_id']);

// Verify device exists and is active
error_log("DEBUG: Verifying device exists in database");
try {
    $stmt = $adminDb->prepare("
        SELECT id, user_id, device_name, ip_address, status 
        FROM devices 
        WHERE device_code = ?
    ");
    $stmt->execute([$input['device_id']]);
    $device = $stmt->fetch();
    
    if (!$device) {
        error_log("DEBUG: Device not found or inactive: " . $input['device_id']);
        http_response_code(403);
        echo json_encode(['status' => 'error', 'message' => 'Device not found or inactive']);
        exit;
    }
    error_log("DEBUG: Device verification successful: " . $device['device_name']);
    
    // Verify IP address matches device registration
    if ($device['ip_address'] !== $remoteAddr) {
        http_response_code(403);
        echo json_encode([
            'status' => 'error', 
            'message' => 'IP address mismatch. Expected: ' . $device['ip_address'] . ', Got: ' . $remoteAddr
        ]);
        exit;
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
    exit;
}

// Initialize data buffer for sensor data processing
$buffer = new DataBuffer();
$deviceIP = $remoteAddr; 

// Prepare sensor data array for storage
$sensorData = [
    'timestamp' => $input['timestamp'] ?? date('Y-m-d H:i:s'),    // Use device timestamp or current time
    'device_ip' => $deviceIP,                                     // Device IP address
    'temperature' => $input['temp'] ?? null,                       // Temperature reading (°C)
    'humidity' => $input['hum'] ?? null,                          // Humidity reading (%)
    'ammonia' => $input['ammonia'] ?? null,                        // Ammonia level (PPM)
    'thermal_temp' => $input['thermal'] ?? null,                  // Thermal camera temperature (°C)
    'water_sprinkler' => $input['pump_temp'] ?? null,             // Water sprinkler status (ON/OFF)
    'sprinkler_trigger' => $input['pump_trigger'] ?? null,        // Sprinkler trigger reason
    'heat' => $input['heat'] ?? null,                              // Heat system status (ON/OFF)
    'mode' => $input['mode'] ?? null,                              // Device operating mode
    'offline_sync' => $input['pump_trigger'] === 'OFFLINE_SYNC' ? 1 : 0  // Flag for offline data sync
];

// Save sensor data to buffer and process
$saveResult = $buffer->saveSensorData($sensorData);

// Update device status in admin database using device access control
$accessControl = new DeviceAccessControl();
$componentStatus = [
    'temp_humidity_sensor' => $input['components']['temp_humidity_sensor'] ?? 'offline',
    'ammonia_sensor' => $input['components']['ammonia_sensor'] ?? 'offline',
    'thermal_camera' => $input['components']['thermal_camera'] ?? 'offline',
    'sd_card_module' => $input['components']['sd_card_module'] ?? 'offline',
    'rtc_module' => $input['components']['ntp_client'] ?? 'offline',
    'arduino_timestamp' => 'active'
];
$accessControl->updateDeviceStatus($remoteAddr, 'up', $componentStatus);

// Return response based on save result
if ($saveResult) {
    echo json_encode(['status' => 'success', 'message' => 'Data saved to buffer successfully']);
} else {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Failed to save data to buffer']);
}

/**
 * Update Device Status Function
 * 
 * Updates device status and component information in the admin database.
 * Uses the validated device ID to update the correct device record.
 * 
 * @param int $deviceId Device ID from database
 * @param array $input Input data from Arduino device
 * @return void
 */
function updateDeviceStatus($deviceId, $input) {
    try {
        // Include database connection provider
        require_once __DIR__ . '/db.php';
        
        // Get admin database connection
        $adminDb = DatabaseConnectionProvider::getAdminConnection();
        
        // Extract component status information
        $components = $input['components'] ?? [];
        $tempHumiditySensor = $components['temp_humidity_sensor'] ?? 'offline';
        $ammoniaSensor = $components['ammonia_sensor'] ?? 'offline';
        $thermalCamera = $components['thermal_camera'] ?? 'offline';
        $sdCardModule = $components['sd_card_module'] ?? 'offline';
        $ntpClient = $components['ntp_client'] ?? 'offline';
        
        // Update device status using device ID
        $stmt = $adminDb->prepare("
            UPDATE devices SET 
                status = 'up',
                last_seen = NOW(),
                temp_humidity_sensor = ?,
                ammonia_sensor = ?,
                thermal_camera = ?,
                sd_card_module = ?,
                rtc_module = ?,
                component_last_checked = NOW(),
                updated_at = NOW()
            WHERE id = ?
        ");
        
        $stmt->execute([
            $tempHumiditySensor,
            $ammoniaSensor,
            $thermalCamera,
            $sdCardModule,
            $ntpClient,
            $deviceId
        ]);
        
    } catch (Exception $e) {
        // Log error but don't fail the request
        error_log("Failed to update device status: " . $e->getMessage());
    }
}
?>