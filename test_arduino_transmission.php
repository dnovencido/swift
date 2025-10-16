<?php
/**
 * Test if Arduino can reach the server endpoint
 */

// Simulate Arduino data transmission
$testData = [
    'timestamp' => '14/10/2025 11:20:00 PM',
    'temp' => 25.5,
    'hum' => 70.0,
    'ammonia' => 15.0,
    'thermal' => 26.0,
    'pump_temp' => 'OFF',
    'pump_trigger' => 'AUTO',
    'heat' => 'ON',
    'mode' => 'AUTO',
    'components' => [
        'temp_humidity_sensor' => 'active',
        'ammonia_sensor' => 'active',
        'thermal_camera' => 'active',
        'sd_card_module' => 'active',
        'ntp_client' => 'active'
    ]
];

echo "Testing Arduino data transmission to server...\n";
echo "Simulating data from Arduino (192.168.1.11)\n\n";

// Test the server endpoint with Arduino IP
$url = 'http://localhost/SWIFT/NEW_SWIFT/php/save_realtime_data.php';
$options = [
    'http' => [
        'header' => [
            'Content-Type: application/json',
            'X-Forwarded-For: 192.168.1.11'  // Simulate Arduino IP
        ],
        'method' => 'POST',
        'content' => json_encode($testData)
    ]
];

$context = stream_context_create($options);
$result = file_get_contents($url, false, $context);

echo "Server response: " . $result . "\n";

// Check if data was saved
echo "\n=== CHECKING IF DATA WAS SAVED ===\n";

require_once __DIR__ . '/php/db.php';
$db = DatabaseConnectionProvider::client();

$stmt = $db->prepare("SELECT * FROM raw_sensor_data WHERE device_ip = '192.168.1.11' ORDER BY timestamp DESC LIMIT 1");
$stmt->execute();
$latestData = $stmt->fetch(PDO::FETCH_ASSOC);

if ($latestData) {
    echo "Latest data from 192.168.1.11:\n";
    echo "Timestamp: {$latestData['timestamp']}\n";
    echo "Temperature: {$latestData['temperature']}°C\n";
    echo "Humidity: {$latestData['humidity']}%\n";
    echo "Ammonia: {$latestData['ammonia']} ppm\n";
} else {
    echo "No data found for device 192.168.1.11\n";
}

// Check sensor buffer
echo "\n=== CHECKING SENSOR BUFFER ===\n";
$bufferFile = __DIR__ . '/php/data/sensor_buffer.txt';
if (file_exists($bufferFile)) {
    $bufferContent = file_get_contents($bufferFile);
    echo "Buffer content: " . ($bufferContent ?: 'EMPTY') . "\n";
} else {
    echo "Buffer file does not exist\n";
}
?>
