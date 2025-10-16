<?php
/**
 * Check device status in database
 */

require_once __DIR__ . '/php/db.php';

try {
    $adminDb = DatabaseConnectionProvider::admin();
    
    echo "=== DEVICE STATUS CHECK ===\n";
    
    $stmt = $adminDb->prepare("
        SELECT id, device_name, device_code, ip_address, status, is_active, created_at, updated_at
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
        echo "Is Active: " . ($device['is_active'] ? 'YES' : 'NO') . "\n";
        echo "Created: {$device['created_at']}\n";
        echo "Updated: {$device['updated_at']}\n";
        
        if (!$device['is_active']) {
            echo "\n⚠️  DEVICE IS INACTIVE! This is why data is not being processed.\n";
        }
    } else {
        echo "No device found with code D001\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
