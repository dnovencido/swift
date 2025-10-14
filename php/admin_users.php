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
        if ($q !== '') {
            $stmt = $db->prepare("SELECT u.id, u.username, u.role, u.created_at,
                                          p.first_name, p.last_name, p.mobile, p.email
                                   FROM users u
                                   LEFT JOIN user_profiles p ON p.user_id = u.id
                                   WHERE u.username LIKE ? AND u.role <> 'super_user' AND u.username <> 'admin'
                                   ORDER BY u.created_at DESC");
            $stmt->execute(['%'.$q.'%']);
        } else {
            $stmt = $db->query("SELECT u.id, u.username, u.role, u.created_at,
                                        p.first_name, p.last_name, p.mobile, p.email
                                 FROM users u
                                 LEFT JOIN user_profiles p ON p.user_id = u.id
                                 WHERE u.role <> 'super_user' AND u.username <> 'admin'
                                 ORDER BY u.created_at DESC");
        }
        echo json_encode(['success'=>true,'data'=>$stmt->fetchAll()]);
    } elseif ($method === 'POST') {
        $in = json_decode(file_get_contents('php://input'), true);
        $username = trim($in['username'] ?? '');
        $password = (string)($in['password'] ?? '');
        $role = trim($in['role'] ?? 'user');
        if ($username === '' || $password === '') { throw new Exception('username and password required'); }
        if (strtolower($username) === 'admin' || strtolower($role) === 'super_user') { throw new Exception('not allowed to create admin via this endpoint'); }
        $exists = $db->prepare('SELECT id FROM users WHERE username=?'); $exists->execute([$username]);
        if ($exists->fetch()) { throw new Exception('username already exists'); }
        $hash = password_hash($password, PASSWORD_BCRYPT);
        $db->beginTransaction();
        try {
            $stmt = $db->prepare('INSERT INTO users (username, password_hash, role, created_at) VALUES (?,?,?,NOW())');
            $stmt->execute([$username,$hash,$role]);
            $userId = (int)$db->lastInsertId();
            $p = [
                'first_name' => trim($in['first_name'] ?? ''),
                'last_name' => trim($in['last_name'] ?? ''),
                'mobile' => trim($in['mobile'] ?? ''),
                'email' => trim($in['email'] ?? '')
            ];
            $any = implode('', $p) !== '';
            if ($any) {
                $ps = $db->prepare('INSERT INTO user_profiles (user_id, first_name, last_name, mobile, email) VALUES (?,?,?,?,?)');
                $ps->execute([$userId, $p['first_name'],$p['last_name'],$p['mobile'],$p['email']]);
            }
            $db->commit();
            $logger = new ActivityLogger();
            $adminUserId = $_SESSION['user_id'] ?? 1; 
            $logger->logUserCreate($adminUserId, $userId, $username);
            echo json_encode(['success'=>true,'id'=>$userId]);
        } catch (Throwable $e) {
            $db->rollBack(); throw $e;
        }
    } elseif ($method === 'PUT') {
        $in = json_decode(file_get_contents('php://input'), true);
        if (isset($in['action']) && $in['action'] === 'update_farm') {
            $userId = (int)($in['user_id'] ?? 0);
            $farmId = isset($in['farm_id']) ? (int)$in['farm_id'] : null;
            if ($userId <= 0) throw new Exception('user_id required');
            $stmt = $db->prepare('UPDATE users SET farm_id = ? WHERE id = ?');
            $stmt->execute([$farmId, $userId]);
            echo json_encode(['success' => true, 'message' => 'Farm assignment updated']);
            exit;
        }
        $id = (int)($in['id'] ?? 0); if ($id<=0) throw new Exception('id required');
        $username = trim($in['username'] ?? '');
        $role = trim($in['role'] ?? 'user');
        $password = (string)($in['password'] ?? '');
        if ($username==='') throw new Exception('username required');
        $db->beginTransaction();
        try {
            if ($password!=='') {
                $hash = password_hash($password, PASSWORD_BCRYPT);
                $stmt = $db->prepare('UPDATE users SET username=?, role=?, password_hash=? WHERE id=?');
                $stmt->execute([$username,$role,$hash,$id]);
            } else {
                $stmt = $db->prepare('UPDATE users SET username=?, role=? WHERE id=?');
                $stmt->execute([$username,$role,$id]);
            }
            $p = [
                'first_name' => trim($in['first_name'] ?? ''),
                'last_name' => trim($in['last_name'] ?? ''),
                'mobile' => trim($in['mobile'] ?? ''),
                'email' => trim($in['email'] ?? '')
            ];
            $exists = $db->prepare('SELECT id FROM user_profiles WHERE user_id=?');
            $exists->execute([$id]);
            if ($exists->fetch()) {
                $ps = $db->prepare('UPDATE user_profiles SET first_name=?, last_name=?, mobile=?, email=? WHERE user_id=?');
                $ps->execute([$p['first_name'],$p['last_name'],$p['mobile'],$p['email'],$id]);
            } else {
                $ps = $db->prepare('INSERT INTO user_profiles (user_id, first_name, last_name, mobile, email) VALUES (?,?,?,?,?)');
                $ps->execute([$id,$p['first_name'],$p['last_name'],$p['mobile'],$p['email']]);
            }
            $db->commit();
            $logger = new ActivityLogger();
            $adminUserId = $_SESSION['user_id'] ?? 1; 
            $changes = [];
            if ($password !== '') $changes[] = 'password';
            if (!empty($p)) $changes[] = 'profile';
            $logger->logUserUpdate($adminUserId, $id, $username, $changes);
            echo json_encode(['success'=>true]);
        } catch (Throwable $e) {
            $db->rollBack(); throw $e;
        }
    } elseif ($method === 'DELETE') {
        $in = json_decode(file_get_contents('php://input'), true);
        $id = (int)($in['id'] ?? 0); if ($id<=0) throw new Exception('id required');
        $userStmt = $db->prepare('SELECT username FROM users WHERE id=?');
        $userStmt->execute([$id]);
        $user = $userStmt->fetch(PDO::FETCH_ASSOC);
        $username = $user ? $user['username'] : 'Unknown';
        $stmt = $db->prepare('DELETE FROM users WHERE id=?'); 
        $stmt->execute([$id]);
        $logger = new ActivityLogger();
        $adminUserId = $_SESSION['user_id'] ?? 1; 
        $logger->logUserDelete($adminUserId, $id, $username);
        echo json_encode(['success'=>true]);
    } else {
        http_response_code(405); echo json_encode(['success'=>false,'message'=>'Method not allowed']);
    }
} catch (Throwable $e) {
    http_response_code(400);
    echo json_encode(['success'=>false,'message'=>$e->getMessage()]);
}
?>