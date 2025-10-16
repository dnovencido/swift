<?php
/**
 * Check device table structure
 */

require_once __DIR__ . '/php/db.php';

try {
    $adminDb = DatabaseConnectionProvider::admin();
    
    echo "=== DEVICE TABLE STRUCTURE ===\n";
    
    $stmt = $adminDb->prepare("DESCRIBE devices");
    $stmt->execute();
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($columns as $column) {
        echo "{$column['Field']} - {$column['Type']} - {$column['Null']} - {$column['Key']} - {$column['Default']}\n";
    }
    
    echo "\n=== DEVICE DATA ===\n";
    $stmt = $adminDb->prepare("
        SELECT id, device_name, device_code, ip_address, status, created_at, updated_at
        FROM devices 
        WHERE device_code = 'D001'
    ");
    $stmt->execute();
    $device = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($device) {
        echo "Device found:\n";
        echo "ID: {$device['id']}\n";
        echo "Name: {$device['device_name']}\n";
        echo "Code: {$device['device_code']}\n";
        echo "IP: {$device['ip_address']}\n";
        echo "Status: {$device['status']}\n";
        echo "Created: {$device['created_at']}\n";
        echo "Updated: {$device['updated_at']}\n";
    } else {
        echo "No device found with code D001\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
