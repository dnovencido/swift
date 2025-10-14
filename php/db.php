<?php
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}
class DatabaseConnectionProvider {
    private static ?PDO $clientConnection = null;
    private static ?PDO $adminConnection = null;
    private static array $connectionErrors = [];
    private static int $maxRetries = 3;
    private static int $retryDelay = 1000; 
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
                    usleep(self::$retryDelay * 1000); 
                }
            }
        }
        error_log("SWIFT Database Connection Failed: " . $lastException->getMessage());
        throw $lastException;
    }
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
    public static function closeAll(): void {
        self::$clientConnection = null;
        self::$adminConnection = null;
    }
    public static function getConnectionErrors(): array {
        return self::$connectionErrors;
    }
    public static function clearConnectionErrors(): void {
        self::$connectionErrors = [];
    }
    public static function testConnection(string $type = 'client'): bool {
        try {
            $connection = $type === 'admin' ? self::admin() : self::client();
            $connection->query('SELECT 1');
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
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