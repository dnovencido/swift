-- SWIFT IoT System - User Data
-- 
-- This SQL file contains regular user accounts and farm-specific data
-- for the SWIFT IoT Smart Swine Farming System.
-- 
-- @version 2.0
-- @author SWIFT Development Team
-- @since 2024

USE `swift_iot_system`;

-- =============================================
-- INSERT REGULAR USERS
-- =============================================

-- Farm Worker Account
INSERT IGNORE INTO `users` (
    `username`, 
    `email`, 
    `password_hash`, 
    `first_name`, 
    `last_name`, 
    `role`, 
    `is_active`
) VALUES (
    'farm_worker', 
    'worker@swift-iot.com', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 'password'
    'Juan', 
    'Dela Cruz', 
    'user', 
    TRUE
);

-- Farm Supervisor Account
INSERT IGNORE INTO `users` (
    `username`, 
    `email`, 
    `password_hash`, 
    `first_name`, 
    `last_name`, 
    `role`, 
    `is_active`
) VALUES (
    'supervisor', 
    'supervisor@swift-iot.com', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 'password'
    'Maria', 
    'Santos', 
    'user', 
    TRUE
);

-- Farm Viewer Account (Read-only access)
INSERT IGNORE INTO `users` (
    `username`, 
    `email`, 
    `password_hash`, 
    `first_name`, 
    `last_name`, 
    `role`, 
    `is_active`
) VALUES (
    'viewer', 
    'viewer@swift-iot.com', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: 'password'
    'Pedro', 
    'Garcia', 
    'viewer', 
    TRUE
);

-- =============================================
-- INSERT ADDITIONAL FARMS
-- =============================================

-- Small Farm
INSERT IGNORE INTO `farms` (
    `farm_name`, 
    `farm_code`, 
    `location`, 
    `owner_id`, 
    `description`, 
    `is_active`
) VALUES (
    'Small Family Farm', 
    'FARM_003', 
    'Mindanao, Philippines', 
    4, 
    'Small family-owned swine farm with basic monitoring', 
    TRUE
);

-- Cooperative Farm
INSERT IGNORE INTO `farms` (
    `farm_name`, 
    `farm_code`, 
    `location`, 
    `owner_id`, 
    `description`, 
    `is_active`
) VALUES (
    'Cooperative Farm', 
    'FARM_004', 
    'Luzon, Philippines', 
    5, 
    'Cooperative swine farming facility', 
    TRUE
);

-- =============================================
-- INSERT ADDITIONAL DEVICES
-- =============================================

-- Small Farm Device
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
    'Small Farm Monitor', 
    'SWIFT_DEVICE_003', 
    '192.168.1.102', 
    'sensor', 
    'down', 
    'offline', 
    'offline', 
    4, 
    3, 
    TRUE
);

-- Cooperative Farm Device
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
    'Cooperative Farm Monitor', 
    'SWIFT_DEVICE_004', 
    '192.168.1.103', 
    'sensor', 
    'down', 
    'offline', 
    'offline', 
    5, 
    4, 
    TRUE
);

-- =============================================
-- INSERT SAMPLE SENSOR DATA FOR NEW DEVICES
-- =============================================

-- Sample data for Small Farm Device
INSERT IGNORE INTO `sensor_data` (
    `device_id`, 
    `timestamp`, 
    `temperature`, 
    `humidity`, 
    `ammonia_level`, 
    `water_sprinkler_status`, 
    `heat_bulb_status`
) VALUES 
(3, NOW() - INTERVAL 2 HOUR, 24.0, 60.0, 25.0, 'off', 'off'),
(3, NOW() - INTERVAL 1 HOUR, 24.5, 62.0, 26.5, 'off', 'off'),
(3, NOW() - INTERVAL 30 MINUTE, 25.0, 64.0, 28.0, 'off', 'off'),
(3, NOW() - INTERVAL 15 MINUTE, 25.5, 66.0, 29.5, 'off', 'off'),
(3, NOW(), 26.0, 68.0, 31.0, 'off', 'off');

-- Sample data for Cooperative Farm Device
INSERT IGNORE INTO `sensor_data` (
    `device_id`, 
    `timestamp`, 
    `temperature`, 
    `humidity`, 
    `ammonia_level`, 
    `water_sprinkler_status`, 
    `heat_bulb_status`
) VALUES 
(4, NOW() - INTERVAL 2 HOUR, 23.5, 58.0, 22.0, 'off', 'off'),
(4, NOW() - INTERVAL 1 HOUR, 24.0, 60.0, 23.5, 'off', 'off'),
(4, NOW() - INTERVAL 30 MINUTE, 24.5, 62.0, 25.0, 'off', 'off'),
(4, NOW() - INTERVAL 15 MINUTE, 25.0, 64.0, 26.5, 'off', 'off'),
(4, NOW(), 25.5, 66.0, 28.0, 'off', 'off');

-- =============================================
-- INSERT USER-SPECIFIC SCHEDULES
-- =============================================

-- Morning routine for Small Farm
INSERT IGNORE INTO `device_schedules` (
    `device_id`, 
    `device_type`, 
    `schedule_name`, 
    `schedule_date`, 
    `schedule_time`, 
    `repeat_type`, 
    `is_active`
) VALUES (
    3, 
    'sprinkler', 
    'Morning Watering Routine', 
    CURDATE(), 
    '07:00:00', 
    'daily', 
    TRUE
);

-- Evening routine for Small Farm
INSERT IGNORE INTO `device_schedules` (
    `device_id`, 
    `device_type`, 
    `schedule_name`, 
    `schedule_date`, 
    `schedule_time`, 
    `repeat_type`, 
    `is_active`
) VALUES (
    3, 
    'heat_bulb', 
    'Evening Heating Routine', 
    CURDATE(), 
    '19:00:00', 
    'daily', 
    TRUE
);

-- Weekend schedule for Cooperative Farm
INSERT IGNORE INTO `device_schedules` (
    `device_id`, 
    `device_type`, 
    `schedule_name`, 
    `schedule_date`, 
    `schedule_time`, 
    `repeat_type`, 
    `is_active`
) VALUES (
    4, 
    'sprinkler', 
    'Weekend Maintenance', 
    CURDATE(), 
    '09:00:00', 
    'weekends', 
    TRUE
);

-- =============================================
-- INSERT USER-SPECIFIC ALERTS
-- =============================================

-- Humidity alert for Small Farm
INSERT IGNORE INTO `device_alerts` (
    `device_id`, 
    `alert_type`, 
    `alert_message`, 
    `threshold_value`, 
    `current_value`, 
    `status`
) VALUES (
    3, 
    'humidity_high', 
    'Humidity is high: 68.0%', 
    80.0, 
    68.0, 
    'active'
);

-- Temperature alert for Cooperative Farm
INSERT IGNORE INTO `device_alerts` (
    `device_id`, 
    `alert_type`, 
    `alert_message`, 
    `threshold_value`, 
    `current_value`, 
    `status`
) VALUES (
    4, 
    'temperature_low', 
    'Temperature is low: 25.5°C', 
    15.0, 
    25.5, 
    'active'
);

-- =============================================
-- CREATE USER VIEWS
-- =============================================

-- User dashboard view (limited data)
CREATE OR REPLACE VIEW `user_dashboard` AS
SELECT 
    d.id as device_id,
    d.device_name,
    d.device_code,
    d.status as device_status,
    d.last_seen,
    f.farm_name,
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
LEFT JOIN `farms` f ON d.farm_id = f.id
LEFT JOIN `sensor_data` sd ON d.id = sd.device_id
WHERE sd.created_at = (
    SELECT MAX(created_at) 
    FROM `sensor_data` sd2 
    WHERE sd2.device_id = d.id
) OR sd.id IS NULL;

-- User alerts view
CREATE OR REPLACE VIEW `user_alerts` AS
SELECT 
    da.id as alert_id,
    da.device_id,
    d.device_name,
    da.alert_type,
    da.alert_message,
    da.threshold_value,
    da.current_value,
    da.status,
    da.created_at,
    da.acknowledged_at,
    da.resolved_at
FROM `device_alerts` da
JOIN `devices` d ON da.device_id = d.id
WHERE da.status IN ('active', 'acknowledged')
ORDER BY da.created_at DESC;

-- User farm statistics
CREATE OR REPLACE VIEW `user_farm_stats` AS
SELECT 
    f.id as farm_id,
    f.farm_name,
    f.farm_code,
    f.location,
    COUNT(DISTINCT d.id) as total_devices,
    COUNT(DISTINCT CASE WHEN d.status = 'up' THEN d.id END) as online_devices,
    COUNT(DISTINCT sd.id) as total_readings,
    COUNT(DISTINCT da.id) as active_alerts,
    AVG(sd.temperature) as avg_temperature,
    AVG(sd.humidity) as avg_humidity,
    AVG(sd.ammonia_level) as avg_ammonia,
    MAX(sd.created_at) as last_reading_time
FROM `farms` f
LEFT JOIN `devices` d ON f.id = d.farm_id
LEFT JOIN `sensor_data` sd ON d.id = sd.device_id
LEFT JOIN `device_alerts` da ON d.id = da.device_id AND da.status = 'active'
GROUP BY f.id, f.farm_name, f.farm_code, f.location;

-- =============================================
-- INSERT USER PREFERENCES
-- =============================================

-- User-specific settings
INSERT IGNORE INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('user_notifications', 'true', 'boolean', 'Enable user notifications'),
('email_alerts', 'true', 'boolean', 'Enable email alerts'),
('sms_alerts', 'false', 'boolean', 'Enable SMS alerts'),
('alert_frequency', 'immediate', 'string', 'Alert notification frequency'),
('dashboard_refresh', '5', 'number', 'Dashboard refresh interval in seconds'),
('chart_time_range', 'hour', 'string', 'Default chart time range'),
('temperature_unit', 'celsius', 'string', 'Temperature unit preference'),
('language', 'en', 'string', 'User interface language'),
('theme', 'light', 'string', 'User interface theme'),
('timezone', 'Asia/Manila', 'string', 'User timezone');

-- =============================================
-- COMPLETION MESSAGE
-- =============================================
SELECT 'SWIFT IoT System user data inserted successfully!' as message;
