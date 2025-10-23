-- SWIFT IoT System - Admin Data
-- 
-- This SQL file contains admin users and system configuration data
-- for the SWIFT IoT Smart Swine Farming System.
-- 
-- @version 2.0
-- @author SWIFT Development Team
-- @since 2024

USE `swift_iot_system`;

-- =============================================
-- INSERT ADMIN USERS
-- =============================================

-- Super User Account
INSERT IGNORE INTO `users` (
    `username`, 
    `email`, 
    `password_hash`, 
    `first_name`, 
    `last_name`, 
    `role`, 
    `is_active`
) VALUES (
    'admin', 
    'admin@swift-iot.com', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 'password'
    'System', 
    'Administrator', 
    'super_user', 
    TRUE
);

-- Farm Manager Account
INSERT IGNORE INTO `users` (
    `username`, 
    `email`, 
    `password_hash`, 
    `first_name`, 
    `last_name`, 
    `role`, 
    `is_active`
) VALUES (
    'farm_manager', 
    'manager@swift-iot.com', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 'password'
    'Farm', 
    'Manager', 
    'admin', 
    TRUE
);

-- Technical Support Account
INSERT IGNORE INTO `users` (
    `username`, 
    `email`, 
    `password_hash`, 
    `first_name`, 
    `last_name`, 
    `role`, 
    `is_active`
) VALUES (
    'tech_support', 
    'support@swift-iot.com', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 'password'
    'Technical', 
    'Support', 
    'admin', 
    TRUE
);

-- =============================================
-- INSERT SAMPLE FARMS
-- =============================================

-- Main Farm
INSERT IGNORE INTO `farms` (
    `farm_name`, 
    `farm_code`, 
    `location`, 
    `owner_id`, 
    `description`, 
    `is_active`
) VALUES (
    'SWIFT Main Farm', 
    'FARM_001', 
    'Luzon, Philippines', 
    1, 
    'Main swine farming facility with IoT monitoring system', 
    TRUE
);

-- Secondary Farm
INSERT IGNORE INTO `farms` (
    `farm_name`, 
    `farm_code`, 
    `location`, 
    `owner_id`, 
    `description`, 
    `is_active`
) VALUES (
    'SWIFT Secondary Farm', 
    'FARM_002', 
    'Visayas, Philippines', 
    1, 
    'Secondary swine farming facility for expansion', 
    TRUE
);

-- =============================================
-- INSERT SAMPLE DEVICES
-- =============================================

-- Main Monitoring Device
INSERT IGNORE INTO `devices` (
    `device_name`, 
    `device_code`, 
    `ip_address`, 
    `device_type`, 
    `status`, 
    `temp_humidity_sensor`, 
    `ammonia_sensor`, 
    `user_id`, 
    `farm_id`, 
    `static_ip`
) VALUES (
    'Main Swine Monitor', 
    'SWIFT_DEVICE_001', 
    '192.168.1.100', 
    'sensor', 
    'down', 
    'offline', 
    'offline', 
    1, 
    1, 
    TRUE
);

-- Secondary Monitoring Device
INSERT IGNORE INTO `devices` (
    `device_name`, 
    `device_code`, 
    `ip_address`, 
    `device_type`, 
    `status`, 
    `temp_humidity_sensor`, 
    `ammonia_sensor`, 
    `user_id`, 
    `farm_id`, 
    `static_ip`
) VALUES (
    'Secondary Swine Monitor', 
    'SWIFT_DEVICE_002', 
    '192.168.1.101', 
    'sensor', 
    'down', 
    'offline', 
    'offline', 
    1, 
    2, 
    TRUE
);

-- =============================================
-- INSERT SAMPLE SENSOR DATA
-- =============================================

-- Sample sensor readings for device 1
INSERT IGNORE INTO `sensor_data` (
    `device_id`, 
    `timestamp`, 
    `temperature`, 
    `humidity`, 
    `ammonia_level`, 
    `water_sprinkler_status`, 
    `heat_bulb_status`
) VALUES 
(1, NOW() - INTERVAL 1 HOUR, 25.5, 65.0, 30.0, 'off', 'off'),
(1, NOW() - INTERVAL 30 MINUTE, 26.2, 68.0, 32.5, 'off', 'off'),
(1, NOW() - INTERVAL 15 MINUTE, 27.8, 70.0, 35.0, 'off', 'off'),
(1, NOW() - INTERVAL 5 MINUTE, 28.5, 72.0, 38.0, 'off', 'off'),
(1, NOW(), 29.2, 75.0, 40.0, 'off', 'off');

-- Sample sensor readings for device 2
INSERT IGNORE INTO `sensor_data` (
    `device_id`, 
    `timestamp`, 
    `temperature`, 
    `humidity`, 
    `ammonia_level`, 
    `water_sprinkler_status`, 
    `heat_bulb_status`
) VALUES 
(2, NOW() - INTERVAL 1 HOUR, 24.8, 62.0, 28.0, 'off', 'off'),
(2, NOW() - INTERVAL 30 MINUTE, 25.1, 64.0, 29.5, 'off', 'off'),
(2, NOW() - INTERVAL 15 MINUTE, 25.8, 66.0, 31.0, 'off', 'off'),
(2, NOW() - INTERVAL 5 MINUTE, 26.5, 68.0, 33.0, 'off', 'off'),
(2, NOW(), 27.0, 70.0, 35.0, 'off', 'off');

-- =============================================
-- INSERT SAMPLE ALERTS
-- =============================================

-- Temperature high alert
INSERT IGNORE INTO `device_alerts` (
    `device_id`, 
    `alert_type`, 
    `alert_message`, 
    `threshold_value`, 
    `current_value`, 
    `status`
) VALUES (
    1, 
    'temperature_high', 
    'Temperature is dangerously high: 29.2°C', 
    30.0, 
    29.2, 
    'active'
);

-- Ammonia high alert
INSERT IGNORE INTO `device_alerts` (
    `device_id`, 
    `alert_type`, 
    `alert_message`, 
    `threshold_value`, 
    `current_value`, 
    `status`
) VALUES (
    1, 
    'ammonia_high', 
    'Ammonia level is dangerously high: 40.0 ppm', 
    50.0, 
    40.0, 
    'active'
);

-- =============================================
-- INSERT SAMPLE SCHEDULES
-- =============================================

-- Daily water sprinkler schedule
INSERT IGNORE INTO `device_schedules` (
    `device_id`, 
    `device_type`, 
    `schedule_name`, 
    `schedule_date`, 
    `schedule_time`, 
    `repeat_type`, 
    `is_active`
) VALUES (
    1, 
    'sprinkler', 
    'Daily Morning Watering', 
    CURDATE(), 
    '08:00:00', 
    'daily', 
    TRUE
);

-- Evening heat bulb schedule
INSERT IGNORE INTO `device_schedules` (
    `device_id`, 
    `device_type`, 
    `schedule_name`, 
    `schedule_date`, 
    `schedule_time`, 
    `repeat_type`, 
    `is_active`
) VALUES (
    1, 
    'heat_bulb', 
    'Evening Heating', 
    CURDATE(), 
    '18:00:00', 
    'daily', 
    TRUE
);

-- =============================================
-- UPDATE SYSTEM SETTINGS FOR ADMIN
-- =============================================

-- Update system settings with admin preferences
UPDATE `system_settings` SET `setting_value` = 'SWIFT IoT Admin System' WHERE `setting_key` = 'system_name';
UPDATE `system_settings` SET `setting_value` = 'true' WHERE `setting_key` = 'maintenance_mode';

-- Add admin-specific settings
INSERT IGNORE INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('admin_email', 'admin@swift-iot.com', 'string', 'Admin contact email'),
('admin_phone', '+63-XXX-XXX-XXXX', 'string', 'Admin contact phone'),
('backup_enabled', 'true', 'boolean', 'Enable automatic backups'),
('backup_frequency', 'daily', 'string', 'Backup frequency'),
('log_retention_days', '90', 'number', 'Log retention period in days'),
('max_concurrent_users', '50', 'number', 'Maximum concurrent users'),
('session_timeout_minutes', '60', 'number', 'Session timeout in minutes'),
('password_policy', 'strong', 'string', 'Password policy level'),
('two_factor_auth', 'false', 'boolean', 'Enable two-factor authentication'),
('api_rate_limit', '1000', 'number', 'API rate limit per hour');

-- =============================================
-- CREATE ADMIN VIEWS
-- =============================================

-- Admin dashboard view
CREATE OR REPLACE VIEW `admin_dashboard` AS
SELECT 
    d.id as device_id,
    d.device_name,
    d.device_code,
    d.ip_address,
    d.status as device_status,
    d.last_seen,
    f.farm_name,
    u.username as owner_username,
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
    END as connection_status,
    COUNT(da.id) as active_alerts
FROM `devices` d
LEFT JOIN `farms` f ON d.farm_id = f.id
LEFT JOIN `users` u ON d.user_id = u.id
LEFT JOIN `sensor_data` sd ON d.id = sd.device_id
LEFT JOIN `device_alerts` da ON d.id = da.device_id AND da.status = 'active'
WHERE sd.created_at = (
    SELECT MAX(created_at) 
    FROM `sensor_data` sd2 
    WHERE sd2.device_id = d.id
) OR sd.id IS NULL
GROUP BY d.id, d.device_name, d.device_code, d.ip_address, d.status, d.last_seen, 
         f.farm_name, u.username, sd.temperature, sd.humidity, sd.ammonia_level, 
         sd.water_sprinkler_status, sd.heat_bulb_status, sd.timestamp;

-- System statistics view
CREATE OR REPLACE VIEW `system_statistics` AS
SELECT 
    COUNT(DISTINCT d.id) as total_devices,
    COUNT(DISTINCT CASE WHEN d.status = 'up' THEN d.id END) as online_devices,
    COUNT(DISTINCT CASE WHEN d.status = 'down' THEN d.id END) as offline_devices,
    COUNT(DISTINCT sd.id) as total_readings,
    COUNT(DISTINCT da.id) as active_alerts,
    COUNT(DISTINCT u.id) as total_users,
    COUNT(DISTINCT f.id) as total_farms,
    AVG(sd.temperature) as avg_temperature,
    AVG(sd.humidity) as avg_humidity,
    AVG(sd.ammonia_level) as avg_ammonia,
    MAX(sd.created_at) as last_reading_time
FROM `devices` d
LEFT JOIN `sensor_data` sd ON d.id = sd.device_id
LEFT JOIN `device_alerts` da ON d.id = da.device_id AND da.status = 'active'
LEFT JOIN `users` u ON u.is_active = TRUE
LEFT JOIN `farms` f ON f.is_active = TRUE;

-- =============================================
-- COMPLETION MESSAGE
-- =============================================
SELECT 'SWIFT IoT System admin data inserted successfully!' as message;
