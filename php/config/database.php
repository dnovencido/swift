<?php
/**
 * SWIFT IoT System - Database Configuration
 * 
 * This file contains the database configuration settings for the SWIFT IoT
 * Smart Swine Farming System. It provides connection parameters and
 * database initialization functions.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Database Configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'swift_iot_system');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

// PDO Connection Options
$pdo_options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
    PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES " . DB_CHARSET
];

/**
 * Get Database Connection
 * 
 * Establishes and returns a PDO database connection.
 * 
 * @return PDO Database connection object
 * @throws PDOException If connection fails
 */
function getDBConnection() {
    global $pdo_options;
    
    try {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $pdo_options);
        return $pdo;
    } catch (PDOException $e) {
        error_log("Database connection failed: " . $e->getMessage());
        throw new PDOException("Database connection failed: " . $e->getMessage());
    }
}

/**
 * Initialize Database Schema
 * 
 * Creates all necessary tables for the SWIFT IoT system.
 * This function should be called once during system setup.
 * 
 * @return bool True if successful, false otherwise
 */
function initializeDatabase() {
    try {
        $pdo = getDBConnection();
        
        // Create sensor_data table
        $sql_sensor_data = "
            CREATE TABLE IF NOT EXISTS sensor_data (
                id INT AUTO_INCREMENT PRIMARY KEY,
                device_id INT NOT NULL,
                timestamp DATETIME NOT NULL,
                temperature DECIMAL(5,2) NOT NULL,
                humidity DECIMAL(5,2) NOT NULL,
                ammonia_level DECIMAL(6,2) NOT NULL,
                water_sprinkler_status ENUM('on', 'off') DEFAULT 'off',
                heat_bulb_status ENUM('on', 'off') DEFAULT 'off',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                INDEX idx_device_timestamp (device_id, timestamp),
                INDEX idx_timestamp (timestamp)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ";
        
        // Create devices table
        $sql_devices = "
            CREATE TABLE IF NOT EXISTS devices (
                id INT AUTO_INCREMENT PRIMARY KEY,
                device_name VARCHAR(255) NOT NULL,
                device_code VARCHAR(100) UNIQUE NOT NULL,
                ip_address VARCHAR(45) NOT NULL,
                mac_address VARCHAR(17),
                device_type ENUM('sensor', 'controller') DEFAULT 'sensor',
                status ENUM('up', 'down') DEFAULT 'down',
                temp_humidity_sensor ENUM('active', 'error', 'offline') DEFAULT 'offline',
                ammonia_sensor ENUM('active', 'error', 'offline') DEFAULT 'offline',
                thermal_camera ENUM('active', 'error', 'offline') DEFAULT 'offline',
                sd_card_module ENUM('active', 'error', 'offline') DEFAULT 'offline',
                rtc_module ENUM('active', 'error', 'offline') DEFAULT 'offline',
                user_id INT,
                farm_id INT,
                static_ip BOOLEAN DEFAULT TRUE,
                last_seen TIMESTAMP NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                INDEX idx_ip_address (ip_address),
                INDEX idx_user_id (user_id),
                INDEX idx_farm_id (farm_id),
                INDEX idx_status (status)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ";
        
        // Create device_alerts table
        $sql_alerts = "
            CREATE TABLE IF NOT EXISTS device_alerts (
                id INT AUTO_INCREMENT PRIMARY KEY,
                device_id INT NOT NULL,
                alert_type ENUM('temperature_high', 'temperature_low', 'ammonia_high', 'device_offline', 'sensor_error') NOT NULL,
                alert_message TEXT NOT NULL,
                threshold_value DECIMAL(6,2),
                current_value DECIMAL(6,2),
                status ENUM('active', 'acknowledged', 'resolved') DEFAULT 'active',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                acknowledged_at TIMESTAMP NULL,
                resolved_at TIMESTAMP NULL,
                INDEX idx_device_id (device_id),
                INDEX idx_alert_type (alert_type),
                INDEX idx_status (status),
                INDEX idx_created_at (created_at)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ";
        
        // Create device_schedules table
        $sql_schedules = "
            CREATE TABLE IF NOT EXISTS device_schedules (
                id INT AUTO_INCREMENT PRIMARY KEY,
                device_id INT NOT NULL,
                device_type ENUM('sprinkler', 'heat_bulb') NOT NULL,
                schedule_name VARCHAR(255) NOT NULL,
                schedule_date DATE NOT NULL,
                schedule_time TIME NOT NULL,
                repeat_type ENUM('once', 'daily', 'weekdays', 'weekends', 'custom') DEFAULT 'once',
                custom_days JSON,
                is_active BOOLEAN DEFAULT TRUE,
                execution_count INT DEFAULT 0,
                last_executed TIMESTAMP NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                INDEX idx_device_id (device_id),
                INDEX idx_schedule_datetime (schedule_date, schedule_time),
                INDEX idx_is_active (is_active)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ";
        
        // Create system_settings table
        $sql_settings = "
            CREATE TABLE IF NOT EXISTS system_settings (
                id INT AUTO_INCREMENT PRIMARY KEY,
                setting_key VARCHAR(100) UNIQUE NOT NULL,
                setting_value TEXT,
                setting_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
                description TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ";
        
        // Execute table creation queries
        $pdo->exec($sql_sensor_data);
        $pdo->exec($sql_devices);
        $pdo->exec($sql_alerts);
        $pdo->exec($sql_schedules);
        $pdo->exec($sql_settings);
        
        // Insert default system settings
        $default_settings = [
            ['temp_high_threshold', '30.0', 'number', 'Temperature high threshold in Celsius'],
            ['temp_low_threshold', '15.0', 'number', 'Temperature low threshold in Celsius'],
            ['ammonia_high_threshold', '50.0', 'number', 'Ammonia high threshold in ppm'],
            ['humidity_high_threshold', '80.0', 'number', 'Humidity high threshold in percentage'],
            ['humidity_low_threshold', '50.0', 'number', 'Humidity low threshold in percentage'],
            ['data_retention_days', '30', 'number', 'Number of days to retain sensor data'],
            ['alert_check_interval', '60', 'number', 'Alert check interval in seconds'],
            ['device_timeout_minutes', '5', 'number', 'Device timeout in minutes']
        ];
        
        $stmt = $pdo->prepare("
            INSERT IGNORE INTO system_settings (setting_key, setting_value, setting_type, description) 
            VALUES (?, ?, ?, ?)
        ");
        
        foreach ($default_settings as $setting) {
            $stmt->execute($setting);
        }
        
        return true;
        
    } catch (PDOException $e) {
        error_log("Database initialization failed: " . $e->getMessage());
        return false;
    }
}

/**
 * Get System Setting
 * 
 * Retrieves a system setting value by key.
 * 
 * @param string $key Setting key
 * @param mixed $default Default value if setting not found
 * @return mixed Setting value or default
 */
function getSystemSetting($key, $default = null) {
    try {
        $pdo = getDBConnection();
        $stmt = $pdo->prepare("SELECT setting_value, setting_type FROM system_settings WHERE setting_key = ?");
        $stmt->execute([$key]);
        $result = $stmt->fetch();
        
        if (!$result) {
            return $default;
        }
        
        // Convert value based on type
        switch ($result['setting_type']) {
            case 'number':
                return (float) $result['setting_value'];
            case 'boolean':
                return (bool) $result['setting_value'];
            case 'json':
                return json_decode($result['setting_value'], true);
            default:
                return $result['setting_value'];
        }
        
    } catch (PDOException $e) {
        error_log("Error getting system setting: " . $e->getMessage());
        return $default;
    }
}

/**
 * Set System Setting
 * 
 * Sets a system setting value.
 * 
 * @param string $key Setting key
 * @param mixed $value Setting value
 * @param string $type Setting type
 * @param string $description Setting description
 * @return bool True if successful, false otherwise
 */
function setSystemSetting($key, $value, $type = 'string', $description = '') {
    try {
        $pdo = getDBConnection();
        
        // Convert value based on type
        switch ($type) {
            case 'json':
                $value = json_encode($value);
                break;
            case 'boolean':
                $value = $value ? '1' : '0';
                break;
            default:
                $value = (string) $value;
        }
        
        $stmt = $pdo->prepare("
            INSERT INTO system_settings (setting_key, setting_value, setting_type, description) 
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
            setting_value = VALUES(setting_value),
            setting_type = VALUES(setting_type),
            description = VALUES(description),
            updated_at = CURRENT_TIMESTAMP
        ");
        
        return $stmt->execute([$key, $value, $type, $description]);
        
    } catch (PDOException $e) {
        error_log("Error setting system setting: " . $e->getMessage());
        return false;
    }
}

// Initialize database on first load
if (!function_exists('isDatabaseInitialized')) {
    function isDatabaseInitialized() {
        try {
            $pdo = getDBConnection();
            $stmt = $pdo->query("SHOW TABLES LIKE 'sensor_data'");
            return $stmt->rowCount() > 0;
        } catch (PDOException $e) {
            return false;
        }
    }
    
    // Auto-initialize if not already done
    if (!isDatabaseInitialized()) {
        initializeDatabase();
    }
}
?>
