-- SWIFT IoT System - Main Database Schema
-- 
-- This SQL file contains the complete database schema for the SWIFT IoT
-- Smart Swine Farming System. Import this file to create all necessary tables.
-- 
-- @version 2.0
-- @author SWIFT Development Team
-- @since 2024

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS `swift_iot_system` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `swift_iot_system`;

-- =============================================
-- SENSOR DATA TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `sensor_data` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `device_id` INT NOT NULL,
    `timestamp` DATETIME NOT NULL,
    `temperature` DECIMAL(5,2) NOT NULL COMMENT 'Temperature in Celsius',
    `humidity` DECIMAL(5,2) NOT NULL COMMENT 'Humidity percentage',
    `ammonia_level` DECIMAL(6,2) NOT NULL COMMENT 'Ammonia level in ppm',
    `water_sprinkler_status` ENUM('on', 'off') DEFAULT 'off' COMMENT 'Water sprinkler status',
    `heat_bulb_status` ENUM('on', 'off') DEFAULT 'off' COMMENT 'Heat bulb status',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_device_timestamp` (`device_id`, `timestamp`),
    INDEX `idx_timestamp` (`timestamp`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores sensor readings from Arduino devices';

-- =============================================
-- DEVICES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `devices` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `device_name` VARCHAR(255) NOT NULL COMMENT 'Human-readable device name',
    `device_code` VARCHAR(100) UNIQUE NOT NULL COMMENT 'Unique device identifier',
    `ip_address` VARCHAR(45) NOT NULL COMMENT 'Device IP address',
    `mac_address` VARCHAR(17) COMMENT 'Device MAC address',
    `device_type` ENUM('sensor', 'controller') DEFAULT 'sensor' COMMENT 'Device type',
    `status` ENUM('up', 'down') DEFAULT 'down' COMMENT 'Device online status',
    `temp_humidity_sensor` ENUM('active', 'error', 'offline') DEFAULT 'offline' COMMENT 'DHT22 sensor status',
    `ammonia_sensor` ENUM('active', 'error', 'offline') DEFAULT 'offline' COMMENT 'MQ137 sensor status',
    `thermal_camera` ENUM('active', 'error', 'offline') DEFAULT 'offline' COMMENT 'Thermal camera status',
    `sd_card_module` ENUM('active', 'error', 'offline') DEFAULT 'offline' COMMENT 'SD card module status',
    `rtc_module` ENUM('active', 'error', 'offline') DEFAULT 'offline' COMMENT 'RTC module status',
    `user_id` INT COMMENT 'Associated user ID',
    `farm_id` INT COMMENT 'Associated farm ID',
    `static_ip` BOOLEAN DEFAULT TRUE COMMENT 'Uses static IP configuration',
    `last_seen` TIMESTAMP NULL COMMENT 'Last time device was seen online',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_ip_address` (`ip_address`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_farm_id` (`farm_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_device_code` (`device_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores device information and status';

-- =============================================
-- DEVICE ALERTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `device_alerts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `device_id` INT NOT NULL,
    `alert_type` ENUM('temperature_high', 'temperature_low', 'ammonia_high', 'device_offline', 'sensor_error', 'humidity_high', 'humidity_low') NOT NULL COMMENT 'Type of alert',
    `alert_message` TEXT NOT NULL COMMENT 'Alert description',
    `threshold_value` DECIMAL(6,2) COMMENT 'Threshold value that triggered alert',
    `current_value` DECIMAL(6,2) COMMENT 'Current value when alert was triggered',
    `status` ENUM('active', 'acknowledged', 'resolved') DEFAULT 'active' COMMENT 'Alert status',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `acknowledged_at` TIMESTAMP NULL COMMENT 'When alert was acknowledged',
    `resolved_at` TIMESTAMP NULL COMMENT 'When alert was resolved',
    INDEX `idx_device_id` (`device_id`),
    INDEX `idx_alert_type` (`alert_type`),
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores system alerts and notifications';

-- =============================================
-- DEVICE SCHEDULES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `device_schedules` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `device_id` INT NOT NULL,
    `device_type` ENUM('sprinkler', 'heat_bulb') NOT NULL COMMENT 'Type of device to control',
    `schedule_name` VARCHAR(255) NOT NULL COMMENT 'Name of the schedule',
    `schedule_date` DATE NOT NULL COMMENT 'Date for the schedule',
    `schedule_time` TIME NOT NULL COMMENT 'Time for the schedule',
    `repeat_type` ENUM('once', 'daily', 'weekdays', 'weekends', 'custom') DEFAULT 'once' COMMENT 'How often to repeat',
    `custom_days` JSON COMMENT 'Custom days for repeat (JSON array)',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT 'Whether schedule is active',
    `execution_count` INT DEFAULT 0 COMMENT 'Number of times executed',
    `last_executed` TIMESTAMP NULL COMMENT 'Last execution time',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_device_id` (`device_id`),
    INDEX `idx_schedule_datetime` (`schedule_date`, `schedule_time`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores device control schedules';

-- =============================================
-- SYSTEM SETTINGS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `system_settings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `setting_key` VARCHAR(100) UNIQUE NOT NULL COMMENT 'Setting identifier',
    `setting_value` TEXT COMMENT 'Setting value',
    `setting_type` ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT 'Data type of setting',
    `description` TEXT COMMENT 'Setting description',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores system configuration settings';

-- =============================================
-- USERS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Username',
    `email` VARCHAR(100) UNIQUE NOT NULL COMMENT 'Email address',
    `password_hash` VARCHAR(255) NOT NULL COMMENT 'Hashed password',
    `first_name` VARCHAR(50) NOT NULL COMMENT 'First name',
    `last_name` VARCHAR(50) NOT NULL COMMENT 'Last name',
    `role` ENUM('super_user', 'admin', 'user', 'viewer') DEFAULT 'user' COMMENT 'User role',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT 'Account status',
    `last_login` TIMESTAMP NULL COMMENT 'Last login time',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_username` (`username`),
    INDEX `idx_email` (`email`),
    INDEX `idx_role` (`role`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores user accounts and authentication';

-- =============================================
-- FARMS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS `farms` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `farm_name` VARCHAR(255) NOT NULL COMMENT 'Farm name',
    `farm_code` VARCHAR(100) UNIQUE NOT NULL COMMENT 'Unique farm identifier',
    `location` VARCHAR(255) COMMENT 'Farm location',
    `owner_id` INT COMMENT 'Farm owner user ID',
    `description` TEXT COMMENT 'Farm description',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT 'Farm status',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_farm_code` (`farm_code`),
    INDEX `idx_owner_id` (`owner_id`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores farm information';

-- =============================================
-- INSERT DEFAULT SYSTEM SETTINGS
-- =============================================
INSERT IGNORE INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('temp_high_threshold', '30.0', 'number', 'Temperature high threshold in Celsius'),
('temp_low_threshold', '15.0', 'number', 'Temperature low threshold in Celsius'),
('ammonia_high_threshold', '50.0', 'number', 'Ammonia high threshold in ppm'),
('humidity_high_threshold', '80.0', 'number', 'Humidity high threshold in percentage'),
('humidity_low_threshold', '50.0', 'number', 'Humidity low threshold in percentage'),
('data_retention_days', '30', 'number', 'Number of days to retain sensor data'),
('alert_check_interval', '60', 'number', 'Alert check interval in seconds'),
('device_timeout_minutes', '5', 'number', 'Device timeout in minutes'),
('system_name', 'SWIFT IoT System', 'string', 'System name'),
('system_version', '2.0', 'string', 'System version'),
('maintenance_mode', 'false', 'boolean', 'System maintenance mode');

-- =============================================
-- CREATE VIEWS FOR COMMON QUERIES
-- =============================================

-- View for latest sensor data
CREATE OR REPLACE VIEW `latest_sensor_data` AS
SELECT 
    sd.*,
    d.device_name,
    d.device_code,
    d.ip_address,
    d.status as device_status
FROM `sensor_data` sd
JOIN `devices` d ON sd.device_id = d.id
WHERE sd.created_at = (
    SELECT MAX(created_at) 
    FROM `sensor_data` sd2 
    WHERE sd2.device_id = sd.device_id
);

-- View for device statistics
CREATE OR REPLACE VIEW `device_statistics` AS
SELECT 
    d.id,
    d.device_name,
    d.device_code,
    d.status,
    d.last_seen,
    COUNT(sd.id) as total_readings,
    MAX(sd.created_at) as last_reading,
    AVG(sd.temperature) as avg_temperature,
    AVG(sd.humidity) as avg_humidity,
    AVG(sd.ammonia_level) as avg_ammonia
FROM `devices` d
LEFT JOIN `sensor_data` sd ON d.id = sd.device_id
GROUP BY d.id, d.device_name, d.device_code, d.status, d.last_seen;

-- =============================================
-- CREATE STORED PROCEDURES
-- =============================================

DELIMITER //

-- Procedure to clean old sensor data
CREATE PROCEDURE CleanOldSensorData(IN retention_days INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    DELETE FROM `sensor_data` 
    WHERE `created_at` < DATE_SUB(NOW(), INTERVAL retention_days DAY);
    
    COMMIT;
END //

-- Procedure to get device health status
CREATE PROCEDURE GetDeviceHealth(IN device_id INT)
BEGIN
    SELECT 
        d.*,
        sd.temperature,
        sd.humidity,
        sd.ammonia_level,
        sd.water_sprinkler_status,
        sd.heat_bulb_status,
        sd.timestamp as last_reading,
        CASE 
            WHEN d.last_seen > DATE_SUB(NOW(), INTERVAL 5 MINUTE) THEN 'online'
            WHEN d.last_seen > DATE_SUB(NOW(), INTERVAL 1 HOUR) THEN 'warning'
            ELSE 'offline'
        END as connection_status
    FROM `devices` d
    LEFT JOIN `sensor_data` sd ON d.id = sd.device_id
    WHERE d.id = device_id
    ORDER BY sd.created_at DESC
    LIMIT 1;
END //

DELIMITER ;

-- =============================================
-- CREATE TRIGGERS
-- =============================================

-- Trigger to update device last_seen when sensor data is inserted
DELIMITER //
CREATE TRIGGER `update_device_last_seen` 
AFTER INSERT ON `sensor_data`
FOR EACH ROW
BEGIN
    UPDATE `devices` 
    SET `last_seen` = NOW(), `status` = 'up'
    WHERE `id` = NEW.device_id;
END //
DELIMITER ;

-- =============================================
-- COMPLETION MESSAGE
-- =============================================
SELECT 'SWIFT IoT System database schema created successfully!' as message;
