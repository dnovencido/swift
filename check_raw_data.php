<?php
/**
 * Check recent sensor data in raw_sensor_data table
 */

require_once __DIR__ . '/php/db.php';

try {
    $db = DatabaseConnectionProvider::client();
    
    echo "=== RECENT SENSOR DATA ===\n";
    
    // Get the most recent sensor data
    $stmt = $db->prepare("SELECT * FROM raw_sensor_data ORDER BY timestamp DESC LIMIT 5");
    $stmt->execute();
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if (count($data) > 0) {
        foreach ($data as $row) {
            echo "ID: {$row['id']}\n";
            echo "Timestamp: {$row['timestamp']}\n";
            echo "Temperature: {$row['temperature']}°C\n";
            echo "Humidity: {$row['humidity']}%\n";
            echo "Ammonia: {$row['ammonia']} ppm\n";
            echo "Device IP: {$row['device_ip']}\n";
            echo "---\n";
        }
    } else {
        echo "NO SENSOR DATA FOUND!\n";
    }
    
    echo "\n=== CHECKING DEVICE STATUS ===\n";
    
    // Check device status in admin database
    $adminDb = DatabaseConnectionProvider::admin();
    $deviceStmt = $adminDb->prepare("SELECT * FROM devices WHERE ip_address = '192.168.1.11'");
    $deviceStmt->execute();
    $device = $deviceStmt->fetch(PDO::FETCH_ASSOC);
    
    if ($device) {
        echo "Device Status: {$device['status']}\n";
        echo "Last Seen: {$device['last_seen']}\n";
        echo "Component Status:\n";
        echo "  - Temp/Humidity Sensor: {$device['temp_humidity_sensor']}\n";
        echo "  - Ammonia Sensor: {$device['ammonia_sensor']}\n";
        echo "  - Thermal Camera: {$device['thermal_camera']}\n";
        echo "  - SD Card Module: {$device['sd_card_module']}\n";
        echo "  - RTC Module: {$device['rtc_module']}\n";
    } else {
        echo "Device not found in admin database!\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
