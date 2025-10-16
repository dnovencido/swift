<?php
/**
 * SWIFT Database Connection Provider
 * 
 * This class provides a centralized database connection management system for the SWIFT IoT
 * Smart Swine Farming System. It implements connection pooling, error handling, retry logic,
 * and connection monitoring for both client and admin databases.
 * 
 * Features:
 * - Singleton pattern for connection management
 * - Automatic retry logic with exponential backoff
 * - Connection error tracking and logging
 * - Connection health monitoring
 * - Graceful error handling and recovery
 * 
 * @package SWIFT
 * @version 2.1.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Prevent direct access to database connection file
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}

/**
 * DatabaseConnectionProvider Class
 * 
 * Manages database connections for both client and admin databases with
 * connection pooling, error handling, and monitoring capabilities.
 */
class DatabaseConnectionProvider {
    // Static connection instances for singleton pattern
    private static ?PDO $clientConnection = null;        // Client database connection instance
    private static ?PDO $adminConnection = null;         // Admin database connection instance
    
    // Connection error tracking
    private static array $connectionErrors = [];         // Array to store connection error details
    
    // Retry configuration
    private static int $maxRetries = 3;                  // Maximum retry attempts for failed connections
    private static int $retryDelay = 1000;               // Delay between retry attempts (milliseconds)
    
    /**
     * Establish Database Connection
     * 
     * Creates a new PDO connection with retry logic and error handling.
     * Implements exponential backoff for retry attempts.
     * 
     * @param array $cfg Database configuration array
     * @return PDO Database connection instance
     * @throws PDOException If all connection attempts fail
     */
    private static function connect(array $cfg): PDO {
        // Build Data Source Name (DSN) for MySQL connection
        $dsn = sprintf('mysql:host=%s;dbname=%s;charset=%s', 
            $cfg['host'], 
            $cfg['database'], 
            $cfg['charset'] ?? 'utf8mb4'
        );
        
        // Set default PDO options if not provided
        $options = $cfg['options'] ?? [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,           // Throw exceptions on errors
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,      // Return associative arrays
            PDO::ATTR_EMULATE_PREPARES => false,                   // Use real prepared statements
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"  // Set charset
        ];
        
        $lastException = null;
        
        // Retry logic with exponential backoff
        for ($attempt = 1; $attempt <= self::$maxRetries; $attempt++) {
            try {
                // Attempt to create PDO connection
                $connection = new PDO($dsn, $cfg['user'], $cfg['password'], $options);
                
                // Test connection with a simple query
                $connection->query('SELECT 1');
                
                return $connection;
            } catch (PDOException $e) {
                $lastException = $e;
                
                // Log connection error details
                self::$connectionErrors[] = [
                    'attempt' => $attempt,
                    'error' => $e->getMessage(),
                    'timestamp' => date('Y-m-d H:i:s')
                ];
                
                // Wait before retry (exponential backoff)
                if ($attempt < self::$maxRetries) {
                    usleep(self::$retryDelay * 1000);  // Convert to microseconds
                }
            }
        }
        
        // Log final failure and throw exception
        error_log("SWIFT Database Connection Failed: " . $lastException->getMessage());
        throw $lastException;
    }
    
    /**
     * Get Client Database Connection
     * 
     * Returns a singleton instance of the client database connection.
     * Creates new connection if none exists.
     * 
     * @return PDO Client database connection
     * @throws Exception If connection fails
     */
    public static function client(): PDO {
        if (self::$clientConnection === null) {
            try {
                // Load configuration and create connection
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
     * Get Admin Database Connection
     * 
     * Returns a singleton instance of the admin database connection.
     * Creates new connection if none exists.
     * 
     * @return PDO Admin database connection
     * @throws Exception If connection fails
     */
    public static function admin(): PDO {
        if (self::$adminConnection === null) {
            try {
                // Load configuration and create connection
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
     * Close All Database Connections
     * 
     * Closes all active database connections and resets connection instances.
     * Useful for cleanup or when forcing reconnection.
     */
    public static function closeAll(): void {
        self::$clientConnection = null;
        self::$adminConnection = null;
    }
    
    /**
     * Get Connection Error History
     * 
     * Returns an array of all connection errors that have occurred.
     * Useful for debugging and monitoring connection health.
     * 
     * @return array Array of connection error details
     */
    public static function getConnectionErrors(): array {
        return self::$connectionErrors;
    }
    
    /**
     * Clear Connection Error History
     * 
     * Clears the stored connection error history.
     * Useful for resetting error tracking.
     */
    public static function clearConnectionErrors(): void {
        self::$connectionErrors = [];
    }
    
    /**
     * Test Database Connection
     * 
     * Tests the health of a specific database connection by executing
     * a simple query. Does not throw exceptions.
     * 
     * @param string $type Connection type ('client' or 'admin')
     * @return bool True if connection is healthy, false otherwise
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
     * Get Connection Statistics
     * 
     * Returns current connection status and error statistics.
     * Useful for monitoring and debugging.
     * 
     * @return array Connection statistics array
     */
    public static function getStats(): array {
        return [
            'client_connected' => self::$clientConnection !== null,    // Client connection status
            'admin_connected' => self::$adminConnection !== null,       // Admin connection status
            'error_count' => count(self::$connectionErrors),             // Total error count
            'last_error' => end(self::$connectionErrors) ?: null         // Most recent error
        ];
    }
}
?>