<?php
/**
 * Check database column names and latest data
 */

require_once __DIR__ . '/php/db.php';

try {
    $db = DatabaseConnectionProvider::client();
    
    echo "=== DATABASE COLUMN STRUCTURE ===\n";
    $stmt = $db->prepare("DESCRIBE raw_sensor_data");
    $stmt->execute();
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($columns as $column) {
        echo "{$column['Field']} - {$column['Type']}\n";
    }
    
    echo "\n=== LATEST DATA RECORD ===\n";
    $stmt = $db->prepare("SELECT * FROM raw_sensor_data WHERE device_ip = '192.168.1.11' ORDER BY timestamp DESC LIMIT 1");
    $stmt->execute();
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($data) {
        echo "Timestamp: {$data['timestamp']}\n";
        echo "Device IP: {$data['device_ip']}\n";
        echo "Temperature: {$data['temperature']}\n";
        echo "Humidity: {$data['humidity']}\n";
        echo "Ammonia: {$data['ammonia']}\n";
        echo "Pump Temp: {$data['pump_temp']}\n";
        echo "Pump Trigger: {$data['pump_trigger']}\n";
        echo "Heat: {$data['heat']}\n";
        echo "Mode: {$data['mode']}\n";
    } else {
        echo "No data found for device 192.168.1.11\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
