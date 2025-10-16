<?php
// Configure session cookie for proper path
ini_set('session.cookie_path', '/SWIFT/NEW_SWIFT/');
session_start();
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/activity_logger.php';
class Auth {
    private $db;
    public function __construct() { $this->db = DatabaseConnectionProvider::admin(); }
    public function login($username, $password) {
        $stmt = $this->db->prepare('SELECT id, username, password_hash, role FROM users WHERE username = ?');
        $stmt->execute([$username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        $passwordMatch = false;
        if ($user) {
            if (password_verify($password, $user['password_hash'])) {
                $passwordMatch = true;
            }
            elseif ($password === $user['password_hash']) {
                $passwordMatch = true;
            }
        }
        if ($user && $passwordMatch) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['role'] = $user['role'];
            $logger = new ActivityLogger();
            $logger->logLogin($user['id'], $user['username']);
            return ['success' => true, 'role' => $user['role'], 'username' => $user['username']];
        }
        return ['success' => false, 'message' => 'Invalid username or password'];
    }
    public function isLoggedIn() { return isset($_SESSION['user_id']); }
    public function getCurrentUser() {
        if ($this->isLoggedIn()) {
            return ['id' => $_SESSION['user_id'], 'username' => $_SESSION['username'], 'role' => $_SESSION['role']];
        }
        return null;
    }
    public function logout() { 
        if ($this->isLoggedIn()) {
            $user = $this->getCurrentUser();
            $logger = new ActivityLogger();
            $logger->logLogout($user['id'], $user['username']);
        }
        session_destroy(); 
        return ['success' => true]; 
    }
}
$auth = new Auth();
$method = $_SERVER['REQUEST_METHOD'];
if ($method === 'OPTIONS') { http_response_code(200); exit(); }
try {
    if ($method === 'POST') {
        $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
        if (stripos($contentType, 'application/json') !== false) {
            $data = json_decode(file_get_contents('php://input'), true);
        } else {
            $data = $_POST; 
            if (empty($data)) { 
                parse_str(file_get_contents('php://input'), $data); 
            }
        }
        $action = $data['action'] ?? 'login';
        if ($action === 'login') {
            echo json_encode($auth->login($data['username'] ?? '', $data['password'] ?? ''));
        } elseif ($action === 'logout') {
            echo json_encode($auth->logout());
        } elseif ($action === 'check_auth') {
            echo json_encode(['success' => true, 'authenticated' => $auth->isLoggedIn(), 'user' => $auth->getCurrentUser()]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Unknown action']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    }
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>