-- SWIFT IoT System - Database Import Instructions
-- 
-- This file contains instructions for importing the database files
-- for the SWIFT IoT Smart Swine Farming System.
-- 
-- @version 2.0
-- @author SWIFT Development Team
-- @since 2024

-- =============================================
-- IMPORT INSTRUCTIONS
-- =============================================

-- 1. MAIN SCHEMA (Required)
--    File: swift_iot_schema.sql
--    Description: Creates all database tables, views, procedures, and triggers
--    Import this file FIRST

-- 2. ADMIN DATA (Optional - for admin users)
--    File: swift_iot_admin_data.sql
--    Description: Inserts admin users, system settings, and sample data
--    Import this file SECOND if you need admin access

-- 3. USER DATA (Optional - for regular users)
--    File: swift_iot_user_data.sql
--    Description: Inserts regular users, farms, and sample data
--    Import this file THIRD if you need user accounts

-- =============================================
-- IMPORT METHODS
-- =============================================

-- METHOD 1: Using MySQL Command Line
-- mysql -u root -p < swift_iot_schema.sql
-- mysql -u root -p < swift_iot_admin_data.sql
-- mysql -u root -p < swift_iot_user_data.sql

-- METHOD 2: Using phpMyAdmin
-- 1. Open phpMyAdmin
-- 2. Click "Import" tab
-- 3. Choose the SQL file
-- 4. Click "Go" to import

-- METHOD 3: Using MySQL Workbench
-- 1. Open MySQL Workbench
-- 2. Connect to your MySQL server
-- 3. File > Open SQL Script
-- 4. Execute the script

-- =============================================
-- DEFAULT CREDENTIALS
-- =============================================

-- Admin Users (after importing admin_data.sql):
-- Username: admin
-- Password: password
-- Role: super_user

-- Username: farm_manager
-- Password: password
-- Role: admin

-- Username: tech_support
-- Password: password
-- Role: admin

-- Regular Users (after importing user_data.sql):
-- Username: farm_worker
-- Password: password
-- Role: user

-- Username: supervisor
-- Password: password
-- Role: user

-- Username: viewer
-- Password: password
-- Role: viewer

-- =============================================
-- DATABASE STRUCTURE
-- =============================================

-- Tables Created:
-- - sensor_data: Stores sensor readings from Arduino devices
-- - devices: Stores device information and status
-- - device_alerts: Stores system alerts and notifications
-- - device_schedules: Stores device control schedules
-- - system_settings: Stores system configuration
-- - users: Stores user accounts and authentication
-- - farms: Stores farm information

-- Views Created:
-- - latest_sensor_data: Latest sensor readings for each device
-- - device_statistics: Device statistics and health status
-- - admin_dashboard: Admin dashboard data
-- - system_statistics: System-wide statistics
-- - user_dashboard: User dashboard data (limited)
-- - user_alerts: User alerts view
-- - user_farm_stats: User farm statistics

-- Procedures Created:
-- - CleanOldSensorData: Cleans old sensor data based on retention days
-- - GetDeviceHealth: Gets device health status

-- Triggers Created:
-- - update_device_last_seen: Updates device last_seen when sensor data is inserted

-- =============================================
-- POST-IMPORT CONFIGURATION
-- =============================================

-- 1. Update database configuration in php/config/database.php
--    - Set correct database credentials
--    - Update host, username, password as needed

-- 2. Test database connection
--    - Run setup_test.php to verify everything works
--    - Check for any import errors

-- 3. Configure Arduino device
--    - Update server IP address in Arduino code
--    - Set correct device ID
--    - Configure WiFi credentials

-- 4. Access the system
--    - Admin dashboard: /admin/dashboard.html
--    - User dashboard: /user/dashboard.html
--    - Setup test: /setup_test.php

-- =============================================
-- TROUBLESHOOTING
-- =============================================

-- Common Issues:
-- 1. Permission denied: Check MySQL user permissions
-- 2. Table already exists: Drop existing tables first
-- 3. Foreign key errors: Import in correct order
-- 4. Character set issues: Ensure UTF-8 encoding

-- Solutions:
-- 1. Grant proper permissions: GRANT ALL PRIVILEGES ON swift_iot_system.* TO 'user'@'localhost';
-- 2. Drop database: DROP DATABASE IF EXISTS swift_iot_system;
-- 3. Check import order: schema -> admin_data -> user_data
-- 4. Use UTF-8 encoding when importing

-- =============================================
-- MAINTENANCE
-- =============================================

-- Regular Maintenance Tasks:
-- 1. Clean old sensor data: CALL CleanOldSensorData(30);
-- 2. Backup database: mysqldump -u root -p swift_iot_system > backup.sql
-- 3. Monitor disk space for sensor data
-- 4. Check device connectivity and status

-- =============================================
-- SUPPORT
-- =============================================

-- For support and questions:
-- - Check setup_test.php for system status
-- - Review error logs in PHP error log
-- - Verify Arduino device connectivity
-- - Test API endpoints manually

-- =============================================
-- COMPLETION
-- =============================================

-- After successful import:
-- 1. All tables should be created
-- 2. Sample data should be inserted
-- 3. Users should be able to login
-- 4. Arduino devices should be able to send data
-- 5. Dashboard should display real-time data

SELECT 'SWIFT IoT System database import instructions completed!' as message;
