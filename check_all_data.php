<?php
/**
 * Check all recent data in database
 */

require_once __DIR__ . '/php/db.php';

try {
    $db = DatabaseConnectionProvider::client();
    
    echo "=== ALL RECENT DATABASE DATA ===\n";
    
    $stmt = $db->prepare("
        SELECT timestamp, device_ip, temperature, humidity, ammonia, thermal_temp, water_sprinkler, heat, mode
        FROM raw_sensor_data 
        ORDER BY timestamp DESC 
        LIMIT 10
    ");
    $stmt->execute();
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if ($data) {
        echo "Found " . count($data) . " recent records:\n";
        foreach ($data as $record) {
            echo "Time: {$record['timestamp']}, IP: {$record['device_ip']}, Temp: {$record['temperature']}°C, Hum: {$record['humidity']}%, Ammonia: {$record['ammonia']} ppm, Heat: {$record['heat']}\n";
        }
    } else {
        echo "No recent data found in database\n";
    }
    
    echo "\n=== COUNT BY DEVICE IP ===\n";
    $stmt = $db->prepare("
        SELECT device_ip, COUNT(*) as count
        FROM raw_sensor_data 
        WHERE timestamp > DATE_SUB(NOW(), INTERVAL 1 HOUR)
        GROUP BY device_ip
        ORDER BY count DESC
    ");
    $stmt->execute();
    $counts = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($counts as $count) {
        echo "IP: {$count['device_ip']} - {$count['count']} records\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
