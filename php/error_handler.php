<?php
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}
class SwiftErrorHandler {
    private static $instance = null;
    private $logDirectory;
    private $config;
    private $errorCount = 0;
    private $maxErrors = 100;
    private function __construct() {
        $this->config = require __DIR__ . '/config.php';
        $this->logDirectory = $this->config['logging']['log_directory'] ?? __DIR__ . '/logs/';
        $this->setupErrorHandling();
        $this->ensureLogDirectory();
    }
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    private function setupErrorHandling() {
        if ($this->config['system']['debug']) {
            error_reporting(E_ALL);
            ini_set('display_errors', 1);
        } else {
            error_reporting(E_ERROR | E_WARNING | E_PARSE);
            ini_set('display_errors', 0);
        }
        set_error_handler([$this, 'handleError']);
        set_exception_handler([$this, 'handleException']);
        register_shutdown_function([$this, 'handleShutdown']);
    }
    private function ensureLogDirectory() {
        if (!is_dir($this->logDirectory)) {
            mkdir($this->logDirectory, 0755, true);
        }
    }
    public function handleError($severity, $message, $file, $line) {
        $error = [
            'type' => 'PHP Error',
            'severity' => $severity,
            'message' => $message,
            'file' => $file,
            'line' => $line,
            'timestamp' => date('Y-m-d H:i:s'),
            'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS)
        ];
        $this->logError($error);
        return true;
    }
    public function handleException($exception) {
        $error = [
            'type' => 'Uncaught Exception',
            'severity' => 'CRITICAL',
            'message' => $exception->getMessage(),
            'file' => $exception->getFile(),
            'line' => $exception->getLine(),
            'timestamp' => date('Y-m-d H:i:s'),
            'trace' => $exception->getTraceAsString()
        ];
        $this->logError($error);
        $this->sendErrorResponse($error);
    }
    public function handleShutdown() {
        $error = error_get_last();
        if ($error && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
            $errorData = [
                'type' => 'Fatal Error',
                'severity' => 'CRITICAL',
                'message' => $error['message'],
                'file' => $error['file'],
                'line' => $error['line'],
                'timestamp' => date('Y-m-d H:i:s'),
                'trace' => 'Shutdown error - no trace available'
            ];
            $this->logError($errorData);
        }
    }
    private function logError($error) {
        if (!$this->config['logging']['enabled']) {
            return;
        }
        $this->errorCount++;
        if ($this->errorCount > $this->maxErrors) {
            return;
        }
        $logFile = $this->logDirectory . 'swift_errors_' . date('Y-m-d') . '.log';
        $logEntry = $this->formatLogEntry($error);
        file_put_contents($logFile, $logEntry, FILE_APPEND | LOCK_EX);
        $this->rotateLogs($logFile);
    }
    private function formatLogEntry($error) {
        $entry = sprintf(
            "[%s] %s: %s in %s on line %d\n",
            $error['timestamp'],
            $error['severity'],
            $error['message'],
            $error['file'],
            $error['line']
        );
        if (!empty($error['trace'])) {
            $entry .= "Stack trace:\n" . $error['trace'] . "\n";
        }
        $entry .= str_repeat('-', 80) . "\n";
        return $entry;
    }
    private function rotateLogs($logFile) {
        if (!file_exists($logFile)) {
            return;
        }
        $maxSize = $this->config['logging']['max_file_size'] ?? 10485760; 
        $maxFiles = $this->config['logging']['max_files'] ?? 5;
        if (filesize($logFile) > $maxSize) {
            for ($i = $maxFiles - 1; $i > 0; $i--) {
                $oldFile = $logFile . '.' . $i;
                $newFile = $logFile . '.' . ($i + 1);
                if (file_exists($oldFile)) {
                    rename($oldFile, $newFile);
                }
            }
            rename($logFile, $logFile . '.1');
        }
    }
    private function sendErrorResponse($error) {
        if (php_sapi_name() === 'cli') {
            return;
        }
        http_response_code(500);
        if ($this->config['system']['debug']) {
            header('Content-Type: application/json');
            echo json_encode([
                'error' => true,
                'message' => $error['message'],
                'file' => $error['file'],
                'line' => $error['line'],
                'timestamp' => $error['timestamp']
            ]);
        } else {
            header('Content-Type: application/json');
            echo json_encode([
                'error' => true,
                'message' => 'An internal error occurred. Please try again later.',
                'code' => 'INTERNAL_ERROR'
            ]);
        }
        exit;
    }
    public function logApplicationError($message, $severity = 'ERROR', $context = []) {
        $error = [
            'type' => 'Application Error',
            'severity' => $severity,
            'message' => $message,
            'file' => debug_backtrace()[1]['file'] ?? 'Unknown',
            'line' => debug_backtrace()[1]['line'] ?? 0,
            'timestamp' => date('Y-m-d H:i:s'),
            'context' => $context,
            'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS)
        ];
        $this->logError($error);
    }
    public function logDatabaseError($message, $query = '', $params = []) {
        $error = [
            'type' => 'Database Error',
            'severity' => 'ERROR',
            'message' => $message,
            'file' => debug_backtrace()[1]['file'] ?? 'Unknown',
            'line' => debug_backtrace()[1]['line'] ?? 0,
            'timestamp' => date('Y-m-d H:i:s'),
            'query' => $query,
            'params' => $params,
            'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS)
        ];
        $this->logError($error);
    }
    public function logApiError($message, $endpoint = '', $statusCode = 0) {
        $error = [
            'type' => 'API Error',
            'severity' => 'WARNING',
            'message' => $message,
            'file' => debug_backtrace()[1]['file'] ?? 'Unknown',
            'line' => debug_backtrace()[1]['line'] ?? 0,
            'timestamp' => date('Y-m-d H:i:s'),
            'endpoint' => $endpoint,
            'status_code' => $statusCode,
            'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS)
        ];
        $this->logError($error);
    }
    public function logSecurityEvent($message, $severity = 'WARNING', $ip = '', $userAgent = '') {
        $error = [
            'type' => 'Security Event',
            'severity' => $severity,
            'message' => $message,
            'file' => debug_backtrace()[1]['file'] ?? 'Unknown',
            'line' => debug_backtrace()[1]['line'] ?? 0,
            'timestamp' => date('Y-m-d H:i:s'),
            'ip_address' => $ip ?: $_SERVER['REMOTE_ADDR'] ?? 'Unknown',
            'user_agent' => $userAgent ?: $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown',
            'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS)
        ];
        $this->logError($error);
    }
    public function getErrorStats() {
        $stats = [
            'total_errors' => $this->errorCount,
            'log_directory' => $this->logDirectory,
            'logging_enabled' => $this->config['logging']['enabled'],
            'debug_mode' => $this->config['system']['debug']
        ];
        return $stats;
    }
    public function clearErrorLogs() {
        $files = glob($this->logDirectory . 'swift_errors_*.log*');
        foreach ($files as $file) {
            unlink($file);
        }
        $this->errorCount = 0;
    }
}
SwiftErrorHandler::getInstance();
function swift_log_error($message, $severity = 'ERROR', $context = []) {
    SwiftErrorHandler::getInstance()->logApplicationError($message, $severity, $context);
}
function swift_log_database_error($message, $query = '', $params = []) {
    SwiftErrorHandler::getInstance()->logDatabaseError($message, $query, $params);
}
function swift_log_api_error($message, $endpoint = '', $statusCode = 0) {
    SwiftErrorHandler::getInstance()->logApiError($message, $endpoint, $statusCode);
}
function swift_log_security_event($message, $severity = 'WARNING', $ip = '', $userAgent = '') {
    SwiftErrorHandler::getInstance()->logSecurityEvent($message, $severity, $ip, $userAgent);
}
?>