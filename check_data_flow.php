<?php
/**
 * Check recent data in database
 */

require_once __DIR__ . '/php/db.php';

try {
    $db = DatabaseConnectionProvider::client();
    
    echo "=== RECENT DATABASE DATA ===\n";
    
    $stmt = $db->prepare("
        SELECT timestamp, device_ip, temperature, humidity, ammonia, thermal_temp, water_sprinkler, heat, mode
        FROM raw_sensor_data 
        WHERE device_ip = '192.168.1.11'
        ORDER BY timestamp DESC 
        LIMIT 5
    ");
    $stmt->execute();
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if ($data) {
        echo "Found " . count($data) . " recent records:\n";
        foreach ($data as $record) {
            echo "Time: {$record['timestamp']}, Temp: {$record['temperature']}°C, Hum: {$record['humidity']}%, Ammonia: {$record['ammonia']} ppm, Heat: {$record['heat']}\n";
        }
    } else {
        echo "No recent data found in database for device 192.168.1.11\n";
    }
    
    echo "\n=== BUFFER FILE STATUS ===\n";
    $bufferFile = __DIR__ . '/php/data/sensor_buffer.txt';
    if (file_exists($bufferFile)) {
        $bufferContent = file_get_contents($bufferFile);
        $lines = explode("\n", trim($bufferContent));
        echo "Buffer has " . count($lines) . " entries\n";
        if (count($lines) > 0) {
            echo "Latest entry: " . $lines[count($lines) - 1] . "\n";
        }
    } else {
        echo "Buffer file does not exist\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
