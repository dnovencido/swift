<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require_once __DIR__ . '/db.php';

function tableExists(PDO $pdo, string $table): bool {
    try { $pdo->query("SELECT 1 FROM `{$table}` LIMIT 1"); return true; } catch (Throwable $e) { return false; }
}

try {
    $db = DatabaseConnectionProvider::admin();
    $type = isset($_GET['type']) ? strtolower(trim($_GET['type'])) : '';
    $status = isset($_GET['status']) ? strtolower(trim($_GET['status'])) : '';

    $data = [];
    if ($type === 'users' && tableExists($db, 'users')) {
        // Exclude admin and super_user from user list, include farm information
        $stmt = $db->query('
            SELECT u.id, u.username, u.role, u.is_active, u.created_at,
                   p.first_name, p.last_name, p.mobile, p.email
            FROM users u 
            LEFT JOIN user_profiles p ON p.user_id = u.id
            WHERE u.role <> "super_user" AND u.username <> "admin" 
            ORDER BY u.created_at DESC
        ');
        $users = $stmt->fetchAll();
        
        // Get farms for each user
        $data = [];
        foreach ($users as $user) {
            $farmStmt = $db->prepare('SELECT id, farm_name, street, barangay, city, province, postal FROM farms WHERE user_id = ?');
            $farmStmt->execute([$user['id']]);
            $user['farms'] = $farmStmt->fetchAll();
            $data[] = $user;
        }
    } elseif ($type === 'farms' && tableExists($db, 'farms')) {
        $stmt = $db->query('
            SELECT f.id, f.farm_name, f.farm_type,
                   f.street, f.barangay, f.city, f.province, f.postal,
                   f.is_active, f.created_at, f.updated_at,
                   f.user_id, u.username as owner_name, p.first_name, p.last_name, p.email, p.mobile
            FROM farms f 
            LEFT JOIN users u ON f.user_id = u.id 
            LEFT JOIN user_profiles p ON p.user_id = u.id
            ORDER BY f.id DESC
        ');
        $data = $stmt->fetchAll();
    } elseif ($type === 'devices' && tableExists($db, 'devices')) {
        if ($status === 'up' || $status === 'down') {
            // Emulate NULLS LAST for MySQL by ordering NULLs as lowest using IS NULL
            $stmt = $db->prepare("
                SELECT id, device_name, ip_address, status, last_seen, 
                       device_type, device_code,
                       temp_humidity_sensor, ammonia_sensor, thermal_camera, 
                       sd_card_module, rtc_module, component_last_checked
                FROM devices 
                WHERE status = ? 
                ORDER BY last_seen IS NULL ASC, last_seen DESC
            ");
            $stmt->execute([$status]);
        } else {
            $stmt = $db->query('
                SELECT id, device_name, ip_address, status, last_seen, 
                       device_type, device_code,
                       temp_humidity_sensor, ammonia_sensor, thermal_camera, 
                       sd_card_module, rtc_module, component_last_checked
                FROM devices 
                ORDER BY last_seen IS NULL ASC, last_seen DESC
            ');
        }
        $data = $stmt->fetchAll();
    } else {
        echo json_encode(['success' => false, 'message' => 'Unknown type or missing table']);
        exit;
    }

    echo json_encode(['success' => true, 'type' => $type, 'status' => $status, 'data' => $data]);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>


