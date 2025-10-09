<?php
/**
 * Get Activity Log
 * Retrieves activity logs with filtering and pagination
 */

require_once __DIR__ . '/db.php';

class ActivityLogManager {
    private $db;
    private $itemsPerPage = 20;
    
    public function __construct() {
        $this->db = DatabaseConnectionProvider::admin();
    }
    
    public function getActivities($filters = []) {
        try {
            // Build the base query - only show admin-side activities
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
                    al.action IN ('login', 'logout', 'admin_action', 'system')
                    OR u.role = 'super_user'
                    OR al.description LIKE '%admin%'
                    OR al.description LIKE '%Created new user%'
                    OR al.description LIKE '%Updated user%'
                    OR al.description LIKE '%Deleted user%'
                    OR al.description LIKE '%Created new farm%'
                    OR al.description LIKE '%Updated farm%'
                    OR al.description LIKE '%Deleted farm%'
                    OR al.description LIKE '%device management%'
                )
            ";
            
            $params = [];
            
            // Apply filters
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
            
            // Get total count for pagination - only admin-side activities
            $countQuery = "SELECT COUNT(*) as total FROM activity_logs al LEFT JOIN users u ON al.user_id = u.id WHERE 1=1
                AND (
                    al.action IN ('login', 'logout', 'admin_action', 'system')
                    OR u.role = 'super_user'
                    OR al.description LIKE '%admin%'
                    OR al.description LIKE '%Created new user%'
                    OR al.description LIKE '%Updated user%'
                    OR al.description LIKE '%Deleted user%'
                    OR al.description LIKE '%Created new farm%'
                    OR al.description LIKE '%Updated farm%'
                    OR al.description LIKE '%Deleted farm%'
                    OR al.description LIKE '%device management%'
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
            
            // Calculate pagination
            $currentPage = isset($filters['page']) ? (int)$filters['page'] : 1;
            $totalPages = ceil($totalItems / $this->itemsPerPage);
            $offset = ($currentPage - 1) * $this->itemsPerPage;
            
            // Add ordering and pagination to main query
            $query .= " ORDER BY al.created_at DESC LIMIT ? OFFSET ?";
            $params[] = $this->itemsPerPage;
            $params[] = $offset;
            
            // Execute main query
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

// Handle the request
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
