<?php
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}

// Set timezone to match Arduino
date_default_timezone_set('Asia/Manila');

return [
    'client' => [
        'host' => 'localhost:3306',
        'database' => 'swift',
        'user' => 'swift',
        'password' => 'swift@2025',
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
        'user' => 'swift',
        'password' => 'swift@2025'
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
        'device_timeout' => 10, 
        'http_timeout' => 1,    
        'ping_timeout' => 1     
    ],
    'security' => [
        'session_timeout' => 3600, 
        'max_login_attempts' => 5,
        'password_min_length' => 8,
        'csrf_token_lifetime' => 1800, 
        'rate_limit_requests' => 100,  
        'allowed_file_types' => ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'csv'],
        'max_file_size' => 5242880 
    ],
    'logging' => [
        'enabled' => true,
        'level' => 'INFO', 
        'max_file_size' => 10485760, 
        'max_files' => 5,
        'log_directory' => __DIR__ . '/logs/'
    ]
];
?>