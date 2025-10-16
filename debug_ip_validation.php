<?php
/**
 * Debug IP detection in save_realtime_data.php
 */

echo "=== IP DETECTION DEBUG ===\n";
echo "REMOTE_ADDR: " . ($_SERVER['REMOTE_ADDR'] ?? 'NOT SET') . "\n";
echo "HTTP_X_FORWARDED_FOR: " . ($_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'NOT SET') . "\n";
echo "HTTP_X_REAL_IP: " . ($_SERVER['HTTP_X_REAL_IP'] ?? 'NOT SET') . "\n";

// Test the IP validation logic
$remoteAddr = $_SERVER['REMOTE_ADDR'] ?? '';

// Check for forwarded IP headers (for testing or proxy scenarios)
if (empty($remoteAddr) || $remoteAddr === '127.0.0.1') {
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $forwardedIPs = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $remoteAddr = trim($forwardedIPs[0]);
        echo "Using forwarded IP: " . $remoteAddr . "\n";
    } elseif (!empty($_SERVER['HTTP_X_REAL_IP'])) {
        $remoteAddr = $_SERVER['HTTP_X_REAL_IP'];
        echo "Using real IP: " . $remoteAddr . "\n";
    }
}

echo "Final remote IP: " . $remoteAddr . "\n";

$isValidIP = preg_match('/^192\.168\.\d+\.\d+$/', $remoteAddr) ||
             preg_match('/^172\.20\.10\.\d+$/', $remoteAddr) ||
             $remoteAddr === '::1' ||
             $remoteAddr === '127.0.0.1';

echo "IP validation result: " . ($isValidIP ? 'VALID' : 'INVALID') . "\n";

// Test device assignment check
if ($isValidIP) {
    echo "\n=== TESTING DEVICE ASSIGNMENT ===\n";
    require_once __DIR__ . '/php/device_access_control.php';
    $deviceInfo = checkDeviceAssignment($remoteAddr);
    if ($deviceInfo) {
        echo "Device assignment: SUCCESS\n";
        echo "Device: {$deviceInfo['device_name']} ({$deviceInfo['device_code']})\n";
        echo "User: {$deviceInfo['username']}\n";
    } else {
        echo "Device assignment: FAILED\n";
    }
}
?>
