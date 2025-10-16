<?php
/**
 * Check device assignments in database
 */

require_once __DIR__ . '/php/db.php';

try {
    $adminDb = DatabaseConnectionProvider::admin();
    
    echo "=== DEVICE ASSIGNMENTS ===\n";
    
    $stmt = $adminDb->prepare("
        SELECT d.id, d.device_name, d.device_code, d.ip_address, d.user_id, d.status,
               u.username, f.farm_name
        FROM devices d
        LEFT JOIN users u ON u.id = d.user_id
        LEFT JOIN farms f ON f.id = d.farm_id
        WHERE d.ip_address = '192.168.1.11'
    ");
    $stmt->execute();
    $device = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($device) {
        echo "Device found:\n";
        echo "ID: {$device['id']}\n";
        echo "Name: {$device['device_name']}\n";
        echo "Code: {$device['device_code']}\n";
        echo "IP: {$device['ip_address']}\n";
        echo "User: {$device['username']}\n";
        echo "Farm: {$device['farm_name']}\n";
        echo "Status: {$device['status']}\n";
    } else {
        echo "No device found with IP 192.168.1.11\n";
        
        // Show all devices
        echo "\n=== ALL DEVICES ===\n";
        $stmt = $adminDb->prepare("
            SELECT d.id, d.device_name, d.device_code, d.ip_address, d.user_id, d.status,
                   u.username, f.farm_name
            FROM devices d
            LEFT JOIN users u ON u.id = d.user_id
            LEFT JOIN farms f ON f.id = d.farm_id
            ORDER BY d.id
        ");
        $stmt->execute();
        $devices = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($devices as $d) {
            echo "ID: {$d['id']}, Name: {$d['device_name']}, Code: {$d['device_code']}, IP: {$d['ip_address']}, User: {$d['username']}\n";
        }
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
