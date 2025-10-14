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
            $stmt = $db->prepare('SELECT id, farm_name, street, barangay, city, province, postal FROM farms WHERE user_id = ? ORDER BY id DESC');
            $stmt->execute([$userId]);
        } elseif ($q !== '') {
            $stmt = $db->prepare('SELECT id, farm_name, street, barangay, city, province, postal FROM farms WHERE farm_name LIKE ? ORDER BY id DESC');
            $stmt->execute(['%'.$q.'%']);
        } else {
            $stmt = $db->query('SELECT id, farm_name, street, barangay, city, province, postal FROM farms ORDER BY id DESC');
        }
        echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
    } elseif ($method === 'POST') {
        $in = json_decode(file_get_contents('php://input'), true);
        $farm = trim($in['farm_name'] ?? '');
        $street = trim($in['street'] ?? '');
        $barangay = trim($in['barangay'] ?? '');
        $city = trim($in['city'] ?? '');
        $province = trim($in['province'] ?? '');
        $postal = trim($in['postal'] ?? '');
        $userId = (int)($in['user_id'] ?? 0);
        if ($farm==='') throw new Exception('farm_name required');
        if ($userId <= 0) throw new Exception('Valid user_id is required');
        $userCheck = $db->prepare('SELECT id FROM users WHERE id = ?');
        $userCheck->execute([$userId]);
        if (!$userCheck->fetch()) {
            throw new Exception('User with ID ' . $userId . ' does not exist');
        }
        $stmt = $db->prepare('INSERT INTO farms (user_id, farm_name, street, barangay, city, province, postal) VALUES (?,?,?,?,?,?,?)');
        $stmt->execute([$userId,$farm,$street,$barangay,$city,$province,$postal]);
        $id = (int)$db->lastInsertId();
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1; 
        $logger->logFarmCreate($adminUserId, $id, $farm);
        echo json_encode(['success'=>true,'id'=>$id]);
    } elseif ($method === 'PUT') {
        $in = json_decode(file_get_contents('php://input'), true);
        $id = (int)($in['id'] ?? 0); if ($id<=0) throw new Exception('id required');
        $farm = trim($in['farm_name'] ?? '');
        $street = trim($in['street'] ?? '');
        $barangay = trim($in['barangay'] ?? '');
        $city = trim($in['city'] ?? '');
        $province = trim($in['province'] ?? '');
        $postal = trim($in['postal'] ?? '');
        $userId = isset($in['user_id'])?(int)$in['user_id']:null;
        if ($farm==='') throw new Exception('farm_name required');
        if ($userId!==null) {
            if ($userId <= 0) throw new Exception('Valid user_id is required');
            $userCheck = $db->prepare('SELECT id FROM users WHERE id = ?');
            $userCheck->execute([$userId]);
            if (!$userCheck->fetch()) {
                throw new Exception('User with ID ' . $userId . ' does not exist');
            }
            $stmt = $db->prepare('UPDATE farms SET farm_name=?, street=?, barangay=?, city=?, province=?, postal=?, user_id=? WHERE id=?');
            $stmt->execute([$farm,$street,$barangay,$city,$province,$postal,$userId,$id]);
        } else {
            $stmt = $db->prepare('UPDATE farms SET farm_name=?, street=?, barangay=?, city=?, province=?, postal=? WHERE id=?');
            $stmt->execute([$farm,$street,$barangay,$city,$province,$postal,$id]);
        }
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1; 
        $changes = ['farm_name', 'address'];
        $logger->logFarmUpdate($adminUserId, $id, $farm, $changes);
        echo json_encode(['success'=>true]);
    } elseif ($method === 'DELETE') {
        $in = json_decode(file_get_contents('php://input'), true);
        $id = (int)($in['id'] ?? 0); if ($id<=0) throw new Exception('id required');
        $farmStmt = $db->prepare('SELECT farm_name FROM farms WHERE id = ?');
        $farmStmt->execute([$id]);
        $farm = $farmStmt->fetch(PDO::FETCH_ASSOC);
        $farmName = $farm ? $farm['farm_name'] : 'Unknown';
        $stmt = $db->prepare('DELETE FROM farms WHERE id=?'); 
        $stmt->execute([$id]);
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1; 
        $logger->logFarmDelete($adminUserId, $id, $farmName);
        echo json_encode(['success'=>true]);
    } else {
        http_response_code(405); echo json_encode(['success'=>false,'message'=>'Method not allowed']);
    }
} catch (Throwable $e) {
    http_response_code(400);
    echo json_encode(['success'=>false,'message'=>$e->getMessage()]);
}
?>