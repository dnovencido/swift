<?php
session_start();
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/activity_logger.php';

try {
    $db = DatabaseConnectionProvider::admin();
    $method = $_SERVER['REQUEST_METHOD'];
    
    if ($method === 'GET') {
        $q = isset($_GET['q']) ? trim($_GET['q']) : '';
        $userId = isset($_GET['user_id']) ? (int)$_GET['user_id'] : 0;
        
        if ($userId > 0) {
            // Get devices for specific user
            $stmt = $db->prepare("
                SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status, 
                       d.last_seen, d.created_at, d.updated_at,
                       u.username as device_owner, f.farm_name
                FROM devices d
                LEFT JOIN users u ON u.id = d.user_id
                LEFT JOIN farms f ON f.id = d.farm_id
                WHERE d.user_id = ? 
                ORDER BY d.created_at DESC
            ");
            $stmt->execute([$userId]);
        } elseif ($q !== '') {
            // Search devices by name, IP, or owner
            $stmt = $db->prepare("
                SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status, 
                       d.last_seen, d.created_at, d.updated_at,
                       u.username as device_owner, f.farm_name
                FROM devices d
                LEFT JOIN users u ON u.id = d.user_id
                LEFT JOIN farms f ON f.id = d.farm_id
                WHERE d.device_name LIKE ? OR d.ip_address LIKE ? OR u.username LIKE ?
                ORDER BY d.created_at DESC
            ");
            $searchTerm = '%'.$q.'%';
            $stmt->execute([$searchTerm, $searchTerm, $searchTerm]);
        } else {
            // Get all devices
            $stmt = $db->query("
                SELECT d.id, d.device_name, d.device_code, d.ip_address, d.device_type, d.status, 
                       d.last_seen, d.created_at, d.updated_at,
                       u.username as device_owner, f.farm_name
                FROM devices d
                LEFT JOIN users u ON u.id = d.user_id
                LEFT JOIN farms f ON f.id = d.farm_id
                ORDER BY d.created_at DESC
            ");
        }
        
        echo json_encode(['success' => true, 'data' => $stmt->fetchAll()]);
        
    } elseif ($method === 'POST') {
        // Create new device assignment
        $in = json_decode(file_get_contents('php://input'), true);
        
        $deviceName = trim($in['device_name'] ?? '');
        $deviceCode = trim($in['device_code'] ?? '');
        $ipAddress = trim($in['ip_address'] ?? '');
        $deviceType = trim($in['device_type'] ?? 'sensor');
        $userId = (int)($in['user_id'] ?? 0);
        $farmId = isset($in['farm_id']) ? (int)$in['farm_id'] : null;
        
        // Validation
        if ($deviceName === '') throw new Exception('Device name is required');
        if ($ipAddress === '') throw new Exception('IP address is required');
        if ($userId <= 0) throw new Exception('Valid user ID is required');
        
        // Validate IP format
        if (!filter_var($ipAddress, FILTER_VALIDATE_IP)) {
            throw new Exception('Invalid IP address format');
    }
    
    // Check if user exists
        $userCheck = $db->prepare('SELECT id, username FROM users WHERE id = ?');
        $userCheck->execute([$userId]);
        $user = $userCheck->fetch();
        if (!$user) {
            throw new Exception('User with ID ' . $userId . ' does not exist');
        }
        
        // Check if IP address is already assigned to another user
        $ipCheck = $db->prepare('SELECT id, user_id FROM devices WHERE ip_address = ?');
        $ipCheck->execute([$ipAddress]);
        $existingDevice = $ipCheck->fetch();
        
        if ($existingDevice) {
            if ($existingDevice['user_id'] != $userId) {
                throw new Exception('IP address ' . $ipAddress . ' is already assigned to another user');
            } else {
                throw new Exception('IP address ' . $ipAddress . ' is already assigned to this user');
            }
        }
        
        // Check if device code is already used (if provided)
        if ($deviceCode !== '') {
            $codeCheck = $db->prepare('SELECT id FROM devices WHERE device_code = ?');
            $codeCheck->execute([$deviceCode]);
            if ($codeCheck->fetch()) {
                throw new Exception('Device code ' . $deviceCode . ' is already in use');
            }
        }
        
        // Validate farm if provided
        if ($farmId !== null && $farmId > 0) {
            $farmCheck = $db->prepare('SELECT id FROM farms WHERE id = ? AND user_id = ?');
            $farmCheck->execute([$farmId, $userId]);
            if (!$farmCheck->fetch()) {
                throw new Exception('Farm with ID ' . $farmId . ' does not exist or does not belong to this user');
            }
        }
        
        // Insert device
        $stmt = $db->prepare('
            INSERT INTO devices (user_id, farm_id, device_name, device_code, device_type, ip_address, status, created_at) 
            VALUES (?, ?, ?, ?, ?, ?, "down", NOW())
        ');
        $stmt->execute([$userId, $farmId, $deviceName, $deviceCode, $deviceType, $ipAddress]);
        $deviceId = (int)$db->lastInsertId();
        
        // Log activity
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1;
        $logger->logDeviceAssign($adminUserId, $deviceId, $deviceName, $user['username'], $ipAddress);
        
        echo json_encode(['success' => true, 'id' => $deviceId, 'message' => 'Device assigned successfully']);
        
    } elseif ($method === 'PUT') {
        // Update device assignment
        $in = json_decode(file_get_contents('php://input'), true);
        
        $deviceId = (int)($in['id'] ?? 0);
        $deviceName = trim($in['device_name'] ?? '');
        $deviceCode = trim($in['device_code'] ?? '');
        $ipAddress = trim($in['ip_address'] ?? '');
        $deviceType = trim($in['device_type'] ?? 'sensor');
        $userId = (int)($in['user_id'] ?? 0);
        $farmId = isset($in['farm_id']) ? (int)$in['farm_id'] : null;
        
        if ($deviceId <= 0) throw new Exception('Valid device ID is required');
        if ($deviceName === '') throw new Exception('Device name is required');
        if ($ipAddress === '') throw new Exception('IP address is required');
        if ($userId <= 0) throw new Exception('Valid user ID is required');
        
        // Validate IP format
        if (!filter_var($ipAddress, FILTER_VALIDATE_IP)) {
            throw new Exception('Invalid IP address format');
    }
    
    // Check if device exists
        $deviceCheck = $db->prepare('SELECT id, user_id FROM devices WHERE id = ?');
        $deviceCheck->execute([$deviceId]);
        $device = $deviceCheck->fetch();
    if (!$device) {
            throw new Exception('Device with ID ' . $deviceId . ' does not exist');
        }
        
        // Check if user exists
        $userCheck = $db->prepare('SELECT id, username FROM users WHERE id = ?');
        $userCheck->execute([$userId]);
        $user = $userCheck->fetch();
        if (!$user) {
            throw new Exception('User with ID ' . $userId . ' does not exist');
        }
        
        // Check if IP address is already assigned to another device
        $ipCheck = $db->prepare('SELECT id FROM devices WHERE ip_address = ? AND id != ?');
        $ipCheck->execute([$ipAddress, $deviceId]);
        if ($ipCheck->fetch()) {
            throw new Exception('IP address ' . $ipAddress . ' is already assigned to another device');
        }
        
        // Check if device code is already used by another device (if provided)
        if ($deviceCode !== '') {
            $codeCheck = $db->prepare('SELECT id FROM devices WHERE device_code = ? AND id != ?');
            $codeCheck->execute([$deviceCode, $deviceId]);
            if ($codeCheck->fetch()) {
                throw new Exception('Device code ' . $deviceCode . ' is already in use by another device');
            }
        }
        
        // Validate farm if provided
        if ($farmId !== null && $farmId > 0) {
            $farmCheck = $db->prepare('SELECT id FROM farms WHERE id = ? AND user_id = ?');
            $farmCheck->execute([$farmId, $userId]);
            if (!$farmCheck->fetch()) {
                throw new Exception('Farm with ID ' . $farmId . ' does not exist or does not belong to this user');
            }
        }
        
        // Update device
        $stmt = $db->prepare('
            UPDATE devices 
            SET user_id = ?, farm_id = ?, device_name = ?, device_code = ?, device_type = ?, ip_address = ?, updated_at = NOW()
        WHERE id = ?
        ');
        $stmt->execute([$userId, $farmId, $deviceName, $deviceCode, $deviceType, $ipAddress, $deviceId]);
        
        // Log activity
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1;
        $logger->logDeviceUpdate($adminUserId, $deviceId, $deviceName, $user['username'], $ipAddress);
        
        echo json_encode(['success' => true, 'message' => 'Device updated successfully']);
        
    } elseif ($method === 'DELETE') {
        // Delete device assignment
        $in = json_decode(file_get_contents('php://input'), true);
        $deviceId = (int)($in['id'] ?? 0);
        
        if ($deviceId <= 0) throw new Exception('Valid device ID is required');
        
        // Get device info for logging
        $deviceCheck = $db->prepare('SELECT device_name, user_id FROM devices WHERE id = ?');
        $deviceCheck->execute([$deviceId]);
        $device = $deviceCheck->fetch();
    if (!$device) {
            throw new Exception('Device with ID ' . $deviceId . ' does not exist');
    }
    
    // Delete device
        $stmt = $db->prepare('DELETE FROM devices WHERE id = ?');
        $stmt->execute([$deviceId]);
        
        // Log activity
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1;
        $logger->logDeviceDelete($adminUserId, $deviceId, $device['device_name']);
        
        echo json_encode(['success' => true, 'message' => 'Device deleted successfully']);
    }
    
} catch (Exception $e) {
        http_response_code(400);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>