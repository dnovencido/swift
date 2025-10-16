<?php
// Configure session cookie for proper path
ini_set('session.cookie_path', '/SWIFT/NEW_SWIFT/');
session_start();
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

require_once __DIR__ . '/../../db.php';
require_once __DIR__ . '/../../device_access_control.php';

try {
    // Check if user is logged in
    if (!isset($_SESSION['user_id'])) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'User not authenticated']);
        exit;
    }
    
    $userId = (int)$_SESSION['user_id'];
    $accessControl = new DeviceAccessControl();
    
    // Get all devices assigned to the current user
    $devices = $accessControl->getDevicesByUserId($userId);
    
    echo json_encode([
        'success' => true, 
        'data' => $devices,
        'count' => count($devices)
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>