<?php
/**
 * SWIFT IoT Smart Swine Farming System - Database Connection Provider
 * Version: 2.1.0 (Production Ready)
 * 
 * Singleton pattern database connection manager with connection pooling
 * and error handling for optimal performance and reliability.
 * 
 * @author SWIFT Development Team
 * @version 2.1.0
 * @since 2024-01-15
 */

// Prevent direct access
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}

class DatabaseConnectionProvider {
    private static ?PDO $clientConnection = null;
    private static ?PDO $adminConnection = null;
    private static array $connectionErrors = [];
    private static int $maxRetries = 3;
    private static int $retryDelay = 1000; // milliseconds

    /**
     * Create a new database connection with enhanced error handling
     * 
     * @param array $cfg Database configuration
     * @return PDO Database connection
     * @throws PDOException If connection fails after retries
     */
    private static function connect(array $cfg): PDO {
        $dsn = sprintf('mysql:host=%s;dbname=%s;charset=%s', 
            $cfg['host'], 
            $cfg['database'], 
            $cfg['charset'] ?? 'utf8mb4'
        );
        
        $options = $cfg['options'] ?? [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
        ];

        $lastException = null;
        
        for ($attempt = 1; $attempt <= self::$maxRetries; $attempt++) {
            try {
                $connection = new PDO($dsn, $cfg['user'], $cfg['password'], $options);
                
                // Test the connection
                $connection->query('SELECT 1');
                
                return $connection;
                
            } catch (PDOException $e) {
                $lastException = $e;
                self::$connectionErrors[] = [
                    'attempt' => $attempt,
                    'error' => $e->getMessage(),
                    'timestamp' => date('Y-m-d H:i:s')
                ];
                
                if ($attempt < self::$maxRetries) {
                    usleep(self::$retryDelay * 1000); // Convert to microseconds
                }
            }
        }
        
        // Log critical error
        error_log("SWIFT Database Connection Failed: " . $lastException->getMessage());
        throw $lastException;
    }

    /**
     * Get client database connection (singleton pattern)
     * 
     * @return PDO Client database connection
     * @throws PDOException If connection fails
     */
    public static function client(): PDO {
        if (self::$clientConnection === null) {
            try {
                $config = require __DIR__ . '/config.php';
                self::$clientConnection = self::connect($config['client']);
            } catch (Exception $e) {
                error_log("SWIFT Client DB Connection Error: " . $e->getMessage());
                throw $e;
            }
        }
        return self::$clientConnection;
    }

    /**
     * Get admin database connection (singleton pattern)
     * 
     * @return PDO Admin database connection
     * @throws PDOException If connection fails
     */
    public static function admin(): PDO {
        if (self::$adminConnection === null) {
            try {
                $config = require __DIR__ . '/config.php';
                self::$adminConnection = self::connect($config['admin']);
            } catch (Exception $e) {
                error_log("SWIFT Admin DB Connection Error: " . $e->getMessage());
                throw $e;
            }
        }
        return self::$adminConnection;
    }

    /**
     * Close all database connections
     * Useful for cleanup or testing
     */
    public static function closeAll(): void {
        self::$clientConnection = null;
        self::$adminConnection = null;
    }

    /**
     * Get connection error history
     * 
     * @return array Connection error history
     */
    public static function getConnectionErrors(): array {
        return self::$connectionErrors;
    }

    /**
     * Clear connection error history
     */
    public static function clearConnectionErrors(): void {
        self::$connectionErrors = [];
    }

    /**
     * Test database connectivity
     * 
     * @param string $type 'client' or 'admin'
     * @return bool True if connection successful
     */
    public static function testConnection(string $type = 'client'): bool {
        try {
            $connection = $type === 'admin' ? self::admin() : self::client();
            $connection->query('SELECT 1');
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    /**
     * Get connection statistics
     * 
     * @return array Connection statistics
     */
    public static function getStats(): array {
        return [
            'client_connected' => self::$clientConnection !== null,
            'admin_connected' => self::$adminConnection !== null,
            'error_count' => count(self::$connectionErrors),
            'last_error' => end(self::$connectionErrors) ?: null
        ];
    }
}
?>


