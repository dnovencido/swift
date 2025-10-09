<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require_once __DIR__ . '/db.php';

function tableExists(PDO $pdo, string $table): bool {
    try {
        $pdo->query("SELECT 1 FROM `{$table}` LIMIT 1");
        return true;
    } catch (Throwable $e) {
        return false;
    }
}

try {
    $db = DatabaseConnectionProvider::admin();

    $farmers = 0; $farms = 0; $devices = 0; $devices_up = 0; $devices_down = 0;

    if (tableExists($db, 'users')) {
        // Count only non-admin users
        $farmers = (int)$db->query('SELECT COUNT(*) FROM users WHERE role = "user" AND username <> "admin"')->fetchColumn();
    }
    if (tableExists($db, 'farms')) {
        $farms = (int)$db->query('SELECT COUNT(*) FROM farms')->fetchColumn();
    }
    if (tableExists($db, 'devices')) {
        $devices = (int)$db->query('SELECT COUNT(*) FROM devices')->fetchColumn();
        $devices_up = (int)$db->query("SELECT COUNT(*) FROM devices WHERE status = 'up'")->fetchColumn();
        $devices_down = (int)$db->query("SELECT COUNT(*) FROM devices WHERE status = 'down'")->fetchColumn();
    }

    echo json_encode([
        'success' => true,
        'stats' => [
            'farmers' => $farmers,
            'farms' => $farms,
            'devices' => $devices,
            'devices_up' => $devices_up,
            'devices_down' => $devices_down,
        ]
    ]);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>


