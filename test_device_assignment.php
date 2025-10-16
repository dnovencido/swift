<?php
/**
 * Test device assignment directly
 */

require_once __DIR__ . '/php/device_access_control.php';

echo "=== TESTING DEVICE ASSIGNMENT ===\n";
$deviceInfo = checkDeviceAssignment('192.168.1.11');

if ($deviceInfo) {
    echo "Device assignment: SUCCESS\n";
    echo "Device: {$deviceInfo['device_name']} ({$deviceInfo['device_code']})\n";
    echo "User: {$deviceInfo['username']}\n";
    echo "IP: {$deviceInfo['ip_address']}\n";
} else {
    echo "Device assignment: FAILED\n";
}

// Test the database query directly
echo "\n=== TESTING DATABASE QUERY ===\n";
require_once __DIR__ . '/php/db.php';
$adminDb = DatabaseConnectionProvider::admin();

$stmt = $adminDb->prepare("
    SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status,
           d.user_id, d.farm_id, f.farm_name, u.username
    FROM devices d
    LEFT JOIN farms f ON f.id = d.farm_id
    LEFT JOIN users u ON u.id = d.user_id
    WHERE d.ip_address = ?
");
$stmt->execute(['192.168.1.11']);
$device = $stmt->fetch(PDO::FETCH_ASSOC);

if ($device) {
    echo "Database query: SUCCESS\n";
    echo "Device: {$device['device_name']} ({$device['device_code']})\n";
    echo "User: {$device['username']}\n";
    echo "IP: {$device['ip_address']}\n";
} else {
    echo "Database query: FAILED\n";
}
?>
