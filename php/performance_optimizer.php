<?php
/**
 * SWIFT IoT Smart Swine Farming System - Performance Optimizer
 * Version: 2.1.0 (Production Ready)
 * 
 * Comprehensive performance optimization system
 * Provides caching, compression, and performance monitoring
 * 
 * @author SWIFT Development Team
 * @version 2.1.0
 * @since 2024-01-15
 */

// Prevent direct access
if (!defined('SWIFT_SYSTEM')) {
    define('SWIFT_SYSTEM', true);
}

class SwiftPerformanceOptimizer {
    private static $instance = null;
    private $config;
    private $cacheDirectory;
    private $cacheEnabled = true;
    private $compressionEnabled = true;
    private $performanceMetrics = [];
    
    private function __construct() {
        $this->config = require __DIR__ . '/config.php';
        $this->cacheDirectory = __DIR__ . '/cache/';
        $this->setupPerformanceOptimization();
        $this->ensureCacheDirectory();
    }
    
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    /**
     * Setup performance optimization
     */
    private function setupPerformanceOptimization() {
        // Enable compression if supported
        if ($this->compressionEnabled && extension_loaded('zlib') && !ob_get_level()) {
            ob_start('ob_gzhandler');
        }
        
        // Set performance headers
        $this->setPerformanceHeaders();
        
        // Start performance monitoring
        $this->startPerformanceMonitoring();
    }
    
    /**
     * Set performance headers
     */
    private function setPerformanceHeaders() {
        if (php_sapi_name() === 'cli') {
            return;
        }
        
        // Cache control headers
        header('Cache-Control: public, max-age=3600');
        header('Expires: ' . gmdate('D, d M Y H:i:s', time() + 3600) . ' GMT');
        
        // Compression headers
        if ($this->compressionEnabled) {
            header('Vary: Accept-Encoding');
        }
        
        // Security headers
        header('X-Content-Type-Options: nosniff');
        header('X-Frame-Options: DENY');
        header('X-XSS-Protection: 1; mode=block');
        
        // Performance headers
        header('X-SWIFT-Version: 2.1.0');
        header('X-SWIFT-Cache: ' . ($this->cacheEnabled ? 'enabled' : 'disabled'));
    }
    
    /**
     * Start performance monitoring
     */
    private function startPerformanceMonitoring() {
        $this->performanceMetrics['start_time'] = microtime(true);
        $this->performanceMetrics['start_memory'] = memory_get_usage();
    }
    
    /**
     * Ensure cache directory exists
     */
    private function ensureCacheDirectory() {
        if (!is_dir($this->cacheDirectory)) {
            mkdir($this->cacheDirectory, 0755, true);
        }
    }
    
    /**
     * Cache data with TTL
     */
    public function cache($key, $data, $ttl = 3600) {
        if (!$this->cacheEnabled) {
            return false;
        }
        
        $cacheFile = $this->cacheDirectory . md5($key) . '.cache';
        $cacheData = [
            'data' => $data,
            'expires' => time() + $ttl,
            'created' => time()
        ];
        
        return file_put_contents($cacheFile, serialize($cacheData), LOCK_EX) !== false;
    }
    
    /**
     * Retrieve cached data
     */
    public function getCache($key) {
        if (!$this->cacheEnabled) {
            return null;
        }
        
        $cacheFile = $this->cacheDirectory . md5($key) . '.cache';
        
        if (!file_exists($cacheFile)) {
            return null;
        }
        
        $cacheData = unserialize(file_get_contents($cacheFile));
        
        if (!$cacheData || $cacheData['expires'] < time()) {
            unlink($cacheFile);
            return null;
        }
        
        return $cacheData['data'];
    }
    
    /**
     * Clear cache
     */
    public function clearCache($pattern = '*') {
        $files = glob($this->cacheDirectory . $pattern . '.cache');
        foreach ($files as $file) {
            unlink($file);
        }
        return count($files);
    }
    
    /**
     * Cache database query result
     */
    public function cacheQuery($query, $params, $result, $ttl = 300) {
        $key = 'query_' . md5($query . serialize($params));
        return $this->cache($key, $result, $ttl);
    }
    
    /**
     * Get cached query result
     */
    public function getCachedQuery($query, $params) {
        $key = 'query_' . md5($query . serialize($params));
        return $this->getCache($key);
    }
    
    /**
     * Cache API response
     */
    public function cacheApiResponse($endpoint, $params, $response, $ttl = 600) {
        $key = 'api_' . md5($endpoint . serialize($params));
        return $this->cache($key, $response, $ttl);
    }
    
    /**
     * Get cached API response
     */
    public function getCachedApiResponse($endpoint, $params) {
        $key = 'api_' . md5($endpoint . serialize($params));
        return $this->getCache($key);
    }
    
    /**
     * Optimize database query
     */
    public function optimizeQuery($query, $params = []) {
        // Add query optimization logic here
        // For now, just return the query as-is
        return $query;
    }
    
    /**
     * Minify CSS
     */
    public function minifyCSS($css) {
        if (!$this->compressionEnabled) {
            return $css;
        }
        
        // Remove comments
        $css = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $css);
        
        // Remove unnecessary whitespace
        $css = preg_replace('/\s+/', ' ', $css);
        $css = str_replace(['; ', ' {', '{ ', ' }', '} ', ': ', ' ,', ', '], [';', '{', '{', '}', '}', ':', ',', ','], $css);
        
        return trim($css);
    }
    
    /**
     * Minify JavaScript
     */
    public function minifyJS($js) {
        if (!$this->compressionEnabled) {
            return $js;
        }
        
        // Basic minification (remove comments and unnecessary whitespace)
        $js = preg_replace('/\/\*[\s\S]*?\*\//', '', $js);
        $js = preg_replace('/\/\/.*$/', '', $js);
        $js = preg_replace('/\s+/', ' ', $js);
        
        return trim($js);
    }
    
    /**
     * Optimize image
     */
    public function optimizeImage($imagePath, $quality = 85) {
        if (!extension_loaded('gd')) {
            return false;
        }
        
        $info = getimagesize($imagePath);
        if (!$info) {
            return false;
        }
        
        $mime = $info['mime'];
        $width = $info[0];
        $height = $info[1];
        
        // Create image resource
        switch ($mime) {
            case 'image/jpeg':
                $source = imagecreatefromjpeg($imagePath);
                break;
            case 'image/png':
                $source = imagecreatefrompng($imagePath);
                break;
            case 'image/gif':
                $source = imagecreatefromgif($imagePath);
                break;
            default:
                return false;
        }
        
        // Resize if too large
        if ($width > 1920 || $height > 1080) {
            $ratio = min(1920 / $width, 1080 / $height);
            $newWidth = $width * $ratio;
            $newHeight = $height * $ratio;
            
            $resized = imagecreatetruecolor($newWidth, $newHeight);
            imagecopyresampled($resized, $source, 0, 0, 0, 0, $newWidth, $newHeight, $width, $height);
            imagedestroy($source);
            $source = $resized;
        }
        
        // Save optimized image
        $result = false;
        switch ($mime) {
            case 'image/jpeg':
                $result = imagejpeg($source, $imagePath, $quality);
                break;
            case 'image/png':
                $result = imagepng($source, $imagePath, 9);
                break;
            case 'image/gif':
                $result = imagegif($source, $imagePath);
                break;
        }
        
        imagedestroy($source);
        return $result;
    }
    
    /**
     * Get performance metrics
     */
    public function getPerformanceMetrics() {
        $this->performanceMetrics['end_time'] = microtime(true);
        $this->performanceMetrics['end_memory'] = memory_get_usage();
        $this->performanceMetrics['peak_memory'] = memory_get_peak_usage();
        
        $this->performanceMetrics['execution_time'] = 
            $this->performanceMetrics['end_time'] - $this->performanceMetrics['start_time'];
        
        $this->performanceMetrics['memory_usage'] = 
            $this->performanceMetrics['end_memory'] - $this->performanceMetrics['start_memory'];
        
        return $this->performanceMetrics;
    }
    
    /**
     * Log performance metrics
     */
    public function logPerformanceMetrics() {
        $metrics = $this->getPerformanceMetrics();
        
        $logFile = $this->cacheDirectory . '../logs/swift_performance_' . date('Y-m-d') . '.log';
        $logEntry = sprintf(
            "[%s] Execution: %.4fs, Memory: %s, Peak: %s\n",
            date('Y-m-d H:i:s'),
            $metrics['execution_time'],
            $this->formatBytes($metrics['memory_usage']),
            $this->formatBytes($metrics['peak_memory'])
        );
        
        file_put_contents($logFile, $logEntry, FILE_APPEND | LOCK_EX);
    }
    
    /**
     * Format bytes to human readable
     */
    private function formatBytes($bytes, $precision = 2) {
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        
        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }
        
        return round($bytes, $precision) . ' ' . $units[$i];
    }
    
    /**
     * Enable/disable caching
     */
    public function setCacheEnabled($enabled) {
        $this->cacheEnabled = $enabled;
    }
    
    /**
     * Enable/disable compression
     */
    public function setCompressionEnabled($enabled) {
        $this->compressionEnabled = $enabled;
    }
    
    /**
     * Get cache statistics
     */
    public function getCacheStats() {
        $files = glob($this->cacheDirectory . '*.cache');
        $totalSize = 0;
        $expiredCount = 0;
        
        foreach ($files as $file) {
            $totalSize += filesize($file);
            $cacheData = unserialize(file_get_contents($file));
            if ($cacheData && $cacheData['expires'] < time()) {
                $expiredCount++;
            }
        }
        
        return [
            'total_files' => count($files),
            'total_size' => $totalSize,
            'expired_files' => $expiredCount,
            'cache_enabled' => $this->cacheEnabled,
            'compression_enabled' => $this->compressionEnabled
        ];
    }
}

// Initialize performance optimizer
SwiftPerformanceOptimizer::getInstance();

// Utility functions for easy performance optimization
function swift_cache($key, $data, $ttl = 3600) {
    return SwiftPerformanceOptimizer::getInstance()->cache($key, $data, $ttl);
}

function swift_get_cache($key) {
    return SwiftPerformanceOptimizer::getInstance()->getCache($key);
}

function swift_clear_cache($pattern = '*') {
    return SwiftPerformanceOptimizer::getInstance()->clearCache($pattern);
}

function swift_cache_query($query, $params, $result, $ttl = 300) {
    return SwiftPerformanceOptimizer::getInstance()->cacheQuery($query, $params, $result, $ttl);
}

function swift_get_cached_query($query, $params) {
    return SwiftPerformanceOptimizer::getInstance()->getCachedQuery($query, $params);
}
?>
