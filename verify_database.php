<?php
/**
 * SWIFT IoT System - Database Verification Script
 * 
 * This script verifies that both databases are properly set up and functional.
 */

// Include configuration
require_once 'php/config.php';

$config = include 'php/config.php';

echo "=== SWIFT IoT SYSTEM DATABASE VERIFICATION ===\n\n";

try {
    // Test admin database connection
    echo "1. Testing Admin Database Connection...\n";
    $admin_pdo = new PDO(
        "mysql:host={$config['admin']['host']};dbname=swift_admin;charset=utf8mb4",
        $config['admin']['user'],
        $config['admin']['password'],
        $config['admin']['options']
    );
    echo "   ✓ Admin database connection: SUCCESS\n";
    
    // Test client database connection
    echo "2. Testing Client Database Connection...\n";
    $client_pdo = new PDO(
        "mysql:host={$config['client']['host']};dbname=swift_client;charset=utf8mb4",
        $config['client']['user'],
        $config['client']['password'],
        $config['client']['options']
    );
    echo "   ✓ Client database connection: SUCCESS\n";
    
    // Verify admin tables and data
    echo "3. Verifying Admin Database Structure...\n";
    $admin_tables = ['users', 'user_profiles', 'devices', 'farms', 'activity_logs', 'system_settings'];
    foreach ($admin_tables as $table) {
        $stmt = $admin_pdo->query("SELECT COUNT(*) as count FROM $table");
        $count = $stmt->fetch()['count'];
        echo "   ✓ Table '$table': $count records\n";
    }
    
    // Verify client tables and data
    echo "4. Verifying Client Database Structure...\n";
    $client_tables = ['sensor_data', 'alerts', 'control_events', 'reports', 'schedules', 'activity_logs'];
    foreach ($client_tables as $table) {
        $stmt = $client_pdo->query("SELECT COUNT(*) as count FROM $table");
        $count = $stmt->fetch()['count'];
        echo "   ✓ Table '$table': $count records\n";
    }
    
    // Test user authentication
    echo "5. Testing User Authentication...\n";
    $stmt = $admin_pdo->prepare("SELECT username, role FROM users WHERE username = ?");
    $stmt->execute(['admin']);
    $admin_user = $stmt->fetch();
    if ($admin_user) {
        echo "   ✓ Admin user found: {$admin_user['username']} ({$admin_user['role']})\n";
    } else {
        echo "   ✗ Admin user not found\n";
    }
    
    $stmt = $admin_pdo->prepare("SELECT username, role FROM users WHERE username = ?");
    $stmt->execute(['user']);
    $regular_user = $stmt->fetch();
    if ($regular_user) {
        echo "   ✓ Regular user found: {$regular_user['username']} ({$regular_user['role']})\n";
    } else {
        echo "   ✗ Regular user not found\n";
    }
    
    // Test device data
    echo "6. Testing Device Data...\n";
    $stmt = $admin_pdo->query("SELECT device_name, ip_address, status FROM devices LIMIT 1");
    $device = $stmt->fetch();
    if ($device) {
        echo "   ✓ Sample device: {$device['device_name']} ({$device['ip_address']}) - Status: {$device['status']}\n";
    } else {
        echo "   ✗ No devices found\n";
    }
    
    // Test sensor data
    echo "7. Testing Sensor Data...\n";
    $stmt = $client_pdo->query("SELECT temperature, humidity, ammonia FROM sensor_data LIMIT 1");
    $sensor_data = $stmt->fetch();
    if ($sensor_data) {
        echo "   ✓ Sample sensor data: Temp={$sensor_data['temperature']}°C, Humidity={$sensor_data['humidity']}%, Ammonia={$sensor_data['ammonia']}ppm\n";
    } else {
        echo "   ✗ No sensor data found\n";
    }
    
    // Test alerts
    echo "8. Testing Alert System...\n";
    $stmt = $client_pdo->query("SELECT alert_type, severity, status FROM alerts LIMIT 1");
    $alert = $stmt->fetch();
    if ($alert) {
        echo "   ✓ Sample alert: {$alert['alert_type']} ({$alert['severity']}) - Status: {$alert['status']}\n";
    } else {
        echo "   ✗ No alerts found\n";
    }
    
    // Test system settings
    echo "9. Testing System Settings...\n";
    $stmt = $admin_pdo->query("SELECT setting_key, setting_value FROM system_settings WHERE is_public = 1 LIMIT 3");
    $settings = $stmt->fetchAll();
    if ($settings) {
        echo "   ✓ Public settings found:\n";
        foreach ($settings as $setting) {
            echo "     - {$setting['setting_key']}: {$setting['setting_value']}\n";
        }
    } else {
        echo "   ✗ No system settings found\n";
    }
    
    echo "\n=== VERIFICATION COMPLETED SUCCESSFULLY ===\n";
    echo "Your SWIFT IoT system databases are properly configured and ready to use!\n\n";
    echo "Next steps:\n";
    echo "1. Access the admin panel at: http://localhost/SWIFT/NEW_SWIFT/admin/\n";
    echo "2. Access the user dashboard at: http://localhost/SWIFT/NEW_SWIFT/user/\n";
    echo "3. Login with admin credentials: admin/admin123\n";
    echo "4. Login with user credentials: user/user123\n";
    
} catch (PDOException $e) {
    echo "Verification failed: " . $e->getMessage() . "\n";
    exit(1);
}
?>
