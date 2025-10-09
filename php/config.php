<?php
/**
 * SWIFT IoT Smart Swine Farming System - Configuration
 * Version: 2.1.0 (Production Ready)
 * 
 * Database configuration and system settings
 * 
 * @author SWIFT Development Team
 * @version 2.1.0
 * @since 2024-01-15
 */

// Prevent direct access
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}

// Database Configuration
return [
    'client' => [
        'host' => 'localhost:3306',
        'database' => 'swift_client',
        'user' => 'root',
        'password' => '',
        'charset' => 'utf8mb4',
        'options' => [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
        ]
    ],
    'admin' => [
        'host' => 'localhost:3306',
        'database' => 'swift_admin',
        'user' => 'root',
        'password' => '',
        'charset' => 'utf8mb4',
        'options' => [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
        ]
    ],
    'system' => [
        'version' => '2.1.0',
        'name' => 'SWIFT IoT Smart Swine Farming System',
        'timezone' => 'Asia/Manila',
        'debug' => false,
        'maintenance_mode' => false,
        'cache_version' => '6',
        'device_timeout' => 10, // seconds
        'http_timeout' => 1,    // seconds
        'ping_timeout' => 1     // seconds
    ],
    'security' => [
        'session_timeout' => 3600, // 1 hour
        'max_login_attempts' => 5,
        'password_min_length' => 8,
        'csrf_token_lifetime' => 1800, // 30 minutes
        'rate_limit_requests' => 100,  // per minute
        'allowed_file_types' => ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'csv'],
        'max_file_size' => 5242880 // 5MB
    ],
    'logging' => [
        'enabled' => true,
        'level' => 'INFO', // DEBUG, INFO, WARNING, ERROR, CRITICAL
        'max_file_size' => 10485760, // 10MB
        'max_files' => 5,
        'log_directory' => __DIR__ . '/logs/'
    ]
];
?>


