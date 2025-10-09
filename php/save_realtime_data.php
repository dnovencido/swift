<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

require_once __DIR__ . '/data_buffer.php';

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

// Accept data from Arduino devices on the same network
$remoteAddr = $_SERVER['REMOTE_ADDR'] ?? '';
// Allow data from any device on local networks (192.168.x.x, 172.20.10.x, localhost)
if (!preg_match('/^192\.168\.\d+\.\d+$/', $remoteAddr) && 
    !preg_match('/^172\.20\.10\.\d+$/', $remoteAddr) && 
    $remoteAddr !== '::1' && 
    $remoteAddr !== '127.0.0.1') {
    http_response_code(403);
    echo json_encode(['status' => 'error', 'message' => 'Data rejected - only local network devices allowed']);
    exit;
}

$raw = file_get_contents('php://input');
$input = $raw ? json_decode($raw, true) : null;

if (!$input) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON data']);
    exit;
}

// Initialize data buffer
$buffer = new DataBuffer();

// Use the actual remote IP address of the Arduino device
$deviceIP = $remoteAddr; // Use actual Arduino device IP

// Prepare data for buffering (every 1 second)
$sensorData = [
    'timestamp' => $input['timestamp'] ?? date('Y-m-d H:i:s'), // Use Arduino timestamp if available
    'device_ip' => $deviceIP, // Always use Arduino IP
    'temperature' => $input['temp'] ?? null,
    'humidity' => $input['hum'] ?? null,
    'ammonia' => $input['ammonia'] ?? null,
    'thermal_temp' => $input['thermal'] ?? null, // Added thermal temperature
    'water_sprinkler' => $input['pump_temp'] ?? null, // Renamed from pump_temp to water_sprinkler
    'sprinkler_trigger' => $input['pump_trigger'] ?? null, // Renamed from pump_trigger to sprinkler_trigger
    'heat' => $input['heat'] ?? null,
    'mode' => $input['mode'] ?? null,
    'offline_sync' => $input['pump_trigger'] === 'OFFLINE_SYNC' ? 1 : 0 // Track offline sync data
];

// Save to buffer (will auto-transfer every 5 minutes)
$saveResult = $buffer->saveSensorData($sensorData);

// Update device status to online (device is sending data)
updateDeviceStatus($input);

// Return response based on save result
if ($saveResult) {
    echo json_encode(['status' => 'success', 'message' => 'Data saved to buffer successfully']);
} else {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Failed to save data to buffer']);
}

function updateDeviceStatus($input) {
    try {
        require_once __DIR__ . '/db.php';
        $adminDb = DatabaseConnectionProvider::admin();
        
        // Use the actual Arduino device IP
        $deviceIP = $_SERVER['REMOTE_ADDR'] ?? '';
        
        // Extract component status from Arduino data
        $components = $input['components'] ?? [];
        $tempHumiditySensor = $components['temp_humidity_sensor'] ?? 'offline';
        $ammoniaSensor = $components['ammonia_sensor'] ?? 'offline';
        $thermalCamera = $components['thermal_camera'] ?? 'offline';
        $sdCardModule = $components['sd_card_module'] ?? 'offline';
        // RTC removed - Arduino uses built-in timestamp
        
        // First, check if device exists
        $stmt = $adminDb->prepare('SELECT id FROM devices WHERE ip_address = ?');
        $stmt->execute([$deviceIP]);
        $device = $stmt->fetch();
        
        if (!$device) {
            // Device doesn't exist, register it with component status
            $stmt = $adminDb->prepare('
                INSERT INTO devices (device_name, ip_address, status, last_seen, 
                                   temp_humidity_sensor, ammonia_sensor, thermal_camera, 
                                   sd_card_module, component_last_checked, 
                                   created_at, updated_at) 
                VALUES (?, ?, "up", NOW(), ?, ?, ?, ?, NOW(), NOW(), NOW())
            ');
            $deviceName = "SWIFT Water Sprinkler Device " . substr($deviceIP, -3); // Use last 3 digits of IP
            $stmt->execute([$deviceName, $deviceIP, $tempHumiditySensor, $ammoniaSensor, 
                           $thermalCamera, $sdCardModule]);
        } else {
            // Device exists, update status and component status
            $stmt = $adminDb->prepare('
                UPDATE devices SET 
                    status = "up", 
                    last_seen = NOW(),
                    temp_humidity_sensor = ?,
                    ammonia_sensor = ?,
                    thermal_camera = ?,
                    sd_card_module = ?,
                    component_last_checked = NOW()
                WHERE ip_address = ?
            ');
            $stmt->execute([$tempHumiditySensor, $ammoniaSensor, $thermalCamera, 
                           $sdCardModule, $deviceIP]);
        }
        
    } catch (Exception $e) {
        // Silent fail - don't interrupt data saving
        error_log("Device status update failed: " . $e->getMessage());
    }
}
?>
