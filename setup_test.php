<?php
/**
 * SWIFT IoT System - Setup and Test Script
 * 
 * This script helps set up the database and test the complete system integration
 * between Arduino devices and the web application.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Include database configuration
require_once 'config/database.php';

echo "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>SWIFT IoT System - Setup & Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .success { background: #d4edda; border-color: #c3e6cb; color: #155724; }
        .error { background: #f8d7da; border-color: #f5c6cb; color: #721c24; }
        .warning { background: #fff3cd; border-color: #ffeaa7; color: #856404; }
        .info { background: #d1ecf1; border-color: #bee5eb; color: #0c5460; }
        .btn { padding: 10px 20px; margin: 5px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .code { background: #f8f9fa; padding: 10px; border-radius: 4px; font-family: monospace; margin: 10px 0; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>🚀 SWIFT IoT System Setup & Test</h1>
            <p>Complete Integration Test for Arduino Device and Web Application</p>
        </div>";

// Test 1: Database Connection
echo "<div class='test-section'>";
echo "<h3>1. Database Connection Test</h3>";
try {
    $pdo = getDBConnection();
    echo "<div class='success'>✅ Database connection successful!</div>";
    echo "<p>Connected to: " . DB_HOST . "/" . DB_NAME . "</p>";
} catch (Exception $e) {
    echo "<div class='error'>❌ Database connection failed: " . $e->getMessage() . "</div>";
}
echo "</div>";

// Test 2: Database Tables
echo "<div class='test-section'>";
echo "<h3>2. Database Tables Check</h3>";
try {
    $pdo = getDBConnection();
    $tables = ['sensor_data', 'devices', 'device_alerts', 'device_schedules', 'system_settings'];
    
    foreach ($tables as $table) {
        $stmt = $pdo->query("SHOW TABLES LIKE '$table'");
        if ($stmt->rowCount() > 0) {
            echo "<div class='success'>✅ Table '$table' exists</div>";
        } else {
            echo "<div class='error'>❌ Table '$table' missing</div>";
        }
    }
} catch (Exception $e) {
    echo "<div class='error'>❌ Error checking tables: " . $e->getMessage() . "</div>";
}
echo "</div>";

// Test 3: System Settings
echo "<div class='test-section'>";
echo "<h3>3. System Settings Check</h3>";
try {
    $pdo = getDBConnection();
    $stmt = $pdo->query("SELECT * FROM system_settings ORDER BY setting_key");
    $settings = $stmt->fetchAll();
    
    if (count($settings) > 0) {
        echo "<div class='success'>✅ System settings loaded (" . count($settings) . " settings)</div>";
        echo "<table>";
        echo "<tr><th>Setting</th><th>Value</th><th>Type</th><th>Description</th></tr>";
        foreach ($settings as $setting) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($setting['setting_key']) . "</td>";
            echo "<td>" . htmlspecialchars($setting['setting_value']) . "</td>";
            echo "<td>" . htmlspecialchars($setting['setting_type']) . "</td>";
            echo "<td>" . htmlspecialchars($setting['description']) . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "<div class='warning'>⚠️ No system settings found</div>";
    }
} catch (Exception $e) {
    echo "<div class='error'>❌ Error loading settings: " . $e->getMessage() . "</div>";
}
echo "</div>";

// Test 4: API Endpoints
echo "<div class='test-section'>";
echo "<h3>4. API Endpoints Test</h3>";
$apiEndpoints = [
    'sensor_data.php' => 'Sensor Data API',
    'device_control.php' => 'Device Control API',
    'device_management.php' => 'Device Management API'
];

foreach ($apiEndpoints as $endpoint => $name) {
    $filePath = "api/v1/$endpoint";
    if (file_exists($filePath)) {
        echo "<div class='success'>✅ $name ($endpoint) exists</div>";
    } else {
        echo "<div class='error'>❌ $name ($endpoint) missing</div>";
    }
}
echo "</div>";

// Test 5: Sample Device Registration
echo "<div class='test-section'>";
echo "<h3>5. Sample Device Registration</h3>";
try {
    $pdo = getDBConnection();
    
    // Check if sample device already exists
    $stmt = $pdo->prepare("SELECT id FROM devices WHERE device_code = 'SWIFT_DEVICE_001'");
    $stmt->execute();
    
    if ($stmt->fetch()) {
        echo "<div class='info'>ℹ️ Sample device already exists</div>";
    } else {
        // Create sample device
        $stmt = $pdo->prepare("
            INSERT INTO devices (
                device_name, device_code, ip_address, device_type, 
                status, static_ip, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, NOW())
        ");
        
        $result = $stmt->execute([
            'SWIFT Swine Monitor Device',
            'SWIFT_DEVICE_001',
            '192.168.1.100',
            'sensor',
            'down',
            true
        ]);
        
        if ($result) {
            echo "<div class='success'>✅ Sample device registered successfully</div>";
            echo "<p>Device ID: " . $pdo->lastInsertId() . "</p>";
        } else {
            echo "<div class='error'>❌ Failed to register sample device</div>";
        }
    }
} catch (Exception $e) {
    echo "<div class='error'>❌ Error registering device: " . $e->getMessage() . "</div>";
}
echo "</div>";

// Test 6: Sample Sensor Data
echo "<div class='test-section'>";
echo "<h3>6. Sample Sensor Data Test</h3>";
try {
    $pdo = getDBConnection();
    
    // Get device ID
    $stmt = $pdo->prepare("SELECT id FROM devices WHERE device_code = 'SWIFT_DEVICE_001'");
    $stmt->execute();
    $device = $stmt->fetch();
    
    if ($device) {
        // Insert sample sensor data
        $stmt = $pdo->prepare("
            INSERT INTO sensor_data (
                device_id, timestamp, temperature, humidity, ammonia_level,
                water_sprinkler_status, heat_bulb_status, created_at
            ) VALUES (?, NOW(), ?, ?, ?, ?, ?, NOW())
        ");
        
        $result = $stmt->execute([
            $device['id'],
            25.5, // Temperature
            65.0, // Humidity
            30.0, // Ammonia
            'off', // Water sprinkler
            'off'  // Heat bulb
        ]);
        
        if ($result) {
            echo "<div class='success'>✅ Sample sensor data inserted successfully</div>";
            echo "<p>Data ID: " . $pdo->lastInsertId() . "</p>";
        } else {
            echo "<div class='error'>❌ Failed to insert sample data</div>";
        }
    } else {
        echo "<div class='warning'>⚠️ No device found for sample data</div>";
    }
} catch (Exception $e) {
    echo "<div class='error'>❌ Error inserting sample data: " . $e->getMessage() . "</div>";
}
echo "</div>";

// Test 7: Arduino Configuration
echo "<div class='test-section'>";
echo "<h3>7. Arduino Device Configuration</h3>";
echo "<div class='info'>";
echo "<h4>Arduino Configuration Required:</h4>";
echo "<div class='code'>";
echo "// Update these values in your Arduino code:<br>";
echo "const char* ssid = \"YOUR_WIFI_SSID\";<br>";
echo "const char* password = \"YOUR_WIFI_PASSWORD\";<br>";
echo "const char* serverHost = \"192.168.1.50\";  // Your server IP<br>";
echo "const int serverPort = 443;  // HTTPS port<br>";
echo "const bool useHTTPS = true;  // Enable HTTPS<br>";
echo "const int deviceId = 1;  // Your device ID";
echo "</div>";
echo "</div>";
echo "</div>";

// Test 8: System Status
echo "<div class='test-section'>";
echo "<h3>8. System Status Summary</h3>";
try {
    $pdo = getDBConnection();
    
    // Count devices
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM devices");
    $deviceCount = $stmt->fetch()['count'];
    
    // Count sensor data
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM sensor_data");
    $dataCount = $stmt->fetch()['count'];
    
    // Count alerts
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM device_alerts WHERE status = 'active'");
    $alertCount = $stmt->fetch()['count'];
    
    echo "<div class='info'>";
    echo "<p><strong>Total Devices:</strong> $deviceCount</p>";
    echo "<p><strong>Total Sensor Data:</strong> $dataCount</p>";
    echo "<p><strong>Active Alerts:</strong> $alertCount</p>";
    echo "</div>";
    
} catch (Exception $e) {
    echo "<div class='error'>❌ Error getting system status: " . $e->getMessage() . "</div>";
}
echo "</div>";

// Test 9: Next Steps
echo "<div class='test-section'>";
echo "<h3>9. Next Steps</h3>";
echo "<div class='info'>";
echo "<h4>To complete the integration:</h4>";
echo "<ol>";
echo "<li>Update Arduino code with your WiFi credentials and server IP</li>";
echo "<li>Upload the Arduino code to your Arduino UNO R4 WiFi</li>";
echo "<li>Connect sensors (DHT22, MQ137) and relay module</li>";
echo "<li>Power on the Arduino device</li>";
echo "<li>Check the dashboard at: <a href='../user/dashboard.html'>Dashboard</a></li>";
echo "<li>Monitor real-time data and device status</li>";
echo "</ol>";
echo "</div>";
echo "</div>";

// Test 10: Troubleshooting
echo "<div class='test-section'>";
echo "<h3>10. Troubleshooting</h3>";
echo "<div class='info'>";
echo "<h4>Common Issues:</h4>";
echo "<ul>";
echo "<li><strong>Arduino not connecting:</strong> Check WiFi credentials and IP configuration</li>";
echo "<li><strong>No data in dashboard:</strong> Verify API endpoints are accessible</li>";
echo "<li><strong>Database errors:</strong> Check database connection and table structure</li>";
echo "<li><strong>HTTPS issues:</strong> Use HTTP mode for testing (set useHTTPS = false)</li>";
echo "<li><strong>Sensor readings:</strong> Verify sensor connections and pin assignments</li>";
echo "</ul>";
echo "</div>";
echo "</div>";

echo "<div class='test-section'>";
echo "<h3>🔧 Quick Actions</h3>";
echo "<button class='btn btn-primary' onclick='location.reload()'>Refresh Tests</button>";
echo "<button class='btn btn-success' onclick='window.open(\"../user/dashboard.html\", \"_blank\")'>Open Dashboard</button>";
echo "<button class='btn btn-danger' onclick='if(confirm(\"This will clear all test data. Continue?\")) clearTestData()'>Clear Test Data</button>";
echo "</div>";

echo "</div>
<script>
function clearTestData() {
    if (confirm('This will delete all test data. Are you sure?')) {
        fetch('api/v1/device_management.php?action=all', {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                data.devices.forEach(device => {
                    fetch('api/v1/device_management.php?device_id=' + device.id, {
                        method: 'DELETE'
                    });
                });
                alert('Test data cleared successfully!');
                location.reload();
            }
        })
        .catch(error => {
            alert('Error clearing test data: ' + error);
        });
    }
}
</script>
</body>
</html>";

// Auto-initialize database if needed
if (!isDatabaseInitialized()) {
    echo "<div class='test-section'>";
    echo "<h3>🔧 Auto-Initializing Database</h3>";
    if (initializeDatabase()) {
        echo "<div class='success'>✅ Database initialized successfully!</div>";
    } else {
        echo "<div class='error'>❌ Database initialization failed!</div>";
    }
    echo "</div>";
}
?>
