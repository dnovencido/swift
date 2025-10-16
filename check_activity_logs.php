<?php
/**
 * Check current activity logs to see what's being logged
 */

require_once __DIR__ . '/php/db.php';

try {
    $adminDb = DatabaseConnectionProvider::admin();
    
    echo "=== RECENT ACTIVITY LOGS ===\n";
    
    $stmt = $adminDb->prepare("
        SELECT al.id, al.action, al.description, al.created_at, u.username
        FROM activity_logs al
        LEFT JOIN users u ON al.user_id = u.id
        ORDER BY al.created_at DESC
        LIMIT 20
    ");
    $stmt->execute();
    $logs = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($logs as $log) {
        echo "ID: {$log['id']}, Action: {$log['action']}, User: {$log['username']}, Time: {$log['created_at']}\n";
        echo "Description: {$log['description']}\n\n";
    }
    
    echo "\n=== ACTION COUNTS ===\n";
    $stmt = $adminDb->prepare("
        SELECT action, COUNT(*) as count
        FROM activity_logs
        GROUP BY action
        ORDER BY count DESC
    ");
    $stmt->execute();
    $counts = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($counts as $count) {
        echo "Action: {$count['action']} - {$count['count']} entries\n";
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
