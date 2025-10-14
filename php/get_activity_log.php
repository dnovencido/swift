<?php

require_once __DIR__ . '/db.php';

class ActivityLogManager {
    private $db;
    private $itemsPerPage = 20;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::admin();
    }
    
    public function getActivities($filters = []) {
        try {
            $query = "
                SELECT 
                    al.id,
                    al.action,
                    al.description,
                    al.ip_address,
                    al.created_at,
                    u.username
                FROM activity_logs al
                LEFT JOIN users u ON al.user_id = u.id
                WHERE 1=1
                AND (
                    -- Only admin actions
                    al.action IN ('login', 'logout', 'admin_action', 'system')
                    -- Only admin users (super_user or admin username)
                    AND (u.role = 'super_user' OR u.username = 'admin' OR u.username IS NULL)
                )
            ";
            
            $params = [];
            
            if (!empty($filters['action'])) {
                $query .= " AND al.action = ?";
                $params[] = $filters['action'];
            }
            
            if (!empty($filters['from_date'])) {
                $query .= " AND DATE(al.created_at) >= ?";
                $params[] = $filters['from_date'];
            }
            
            if (!empty($filters['to_date'])) {
                $query .= " AND DATE(al.created_at) <= ?";
                $params[] = $filters['to_date'];
            }
            
            if (!empty($filters['search'])) {
                $query .= " AND (al.description LIKE ? OR al.action LIKE ? OR u.username LIKE ?)";
                $searchTerm = '%' . $filters['search'] . '%';
                $params[] = $searchTerm;
                $params[] = $searchTerm;
                $params[] = $searchTerm;
            }
            
            $countQuery = "SELECT COUNT(*) as total FROM activity_logs al LEFT JOIN users u ON al.user_id = u.id WHERE 1=1
                AND (
                    -- Only admin actions
                    al.action IN ('login', 'logout', 'admin_action', 'system')
                    -- Only admin users (super_user or admin username)
                    AND (u.role = 'super_user' OR u.username = 'admin' OR u.username IS NULL)
                )";
            $countParams = [];
            
            if (!empty($filters['action'])) {
                $countQuery .= " AND al.action = ?";
                $countParams[] = $filters['action'];
            }
            
            if (!empty($filters['from_date'])) {
                $countQuery .= " AND DATE(al.created_at) >= ?";
                $countParams[] = $filters['from_date'];
            }
            
            if (!empty($filters['to_date'])) {
                $countQuery .= " AND DATE(al.created_at) <= ?";
                $countParams[] = $filters['to_date'];
            }
            
            if (!empty($filters['search'])) {
                $countQuery .= " AND (al.description LIKE ? OR al.action LIKE ? OR u.username LIKE ?)";
                $searchTerm = '%' . $filters['search'] . '%';
                $countParams[] = $searchTerm;
                $countParams[] = $searchTerm;
                $countParams[] = $searchTerm;
            }
            
            $countStmt = $this->db->prepare($countQuery);
            $countStmt->execute($countParams);
            $totalItems = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];
            
            $currentPage = isset($filters['page']) ? (int)$filters['page'] : 1;
            $totalPages = ceil($totalItems / $this->itemsPerPage);
            $offset = ($currentPage - 1) * $this->itemsPerPage;
            
            $query .= " ORDER BY al.created_at DESC LIMIT ? OFFSET ?";
            $params[] = $this->itemsPerPage;
            $params[] = $offset;
            
            $stmt = $this->db->prepare($query);
            $stmt->execute($params);
            $activities = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            return [
                'success' => true,
                'activities' => $activities,
                'pagination' => [
                    'current_page' => $currentPage,
                    'total_pages' => $totalPages,
                    'total_items' => $totalItems,
                    'items_per_page' => $this->itemsPerPage
                ]
            ];
            
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Error retrieving activity logs: ' . $e->getMessage()
            ];
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    header('Content-Type: application/json');
    
    $filters = [
        'action' => $_GET['action'] ?? '',
        'from_date' => $_GET['from_date'] ?? '',
        'to_date' => $_GET['to_date'] ?? '',
        'search' => $_GET['search'] ?? '',
        'page' => $_GET['page'] ?? 1
    ];
    
    $manager = new ActivityLogManager();
    $result = $manager->getActivities($filters);
    echo json_encode($result);
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
