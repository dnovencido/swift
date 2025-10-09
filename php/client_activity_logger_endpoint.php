<?php
/**
 * Client Activity Logger Endpoint
 * Handles client-side activity logging requests
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
    exit;
}

require_once __DIR__ . '/client_activity_logger.php';

try {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input || !isset($input['action'])) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'Invalid request data']);
        exit;
    }
    
    $logger = new ClientActivityLogger();
    $result = false;
    
    switch ($input['action']) {
        case 'log_dashboard_access':
            $result = $logger->logDashboardAccess();
            break;
            
        case 'log_report_view':
            $reportType = $input['report_type'] ?? 'unknown';
            $result = $logger->logReportView($reportType);
            break;
            
        case 'log_data_export':
            $exportType = $input['export_type'] ?? 'unknown';
            $result = $logger->logDataExport($exportType);
            break;
            
        case 'log_chart_interaction':
            $chartType = $input['chart_type'] ?? 'unknown';
            $interaction = $input['interaction'] ?? 'unknown';
            $result = $logger->logChartInteraction($chartType, $interaction);
            break;
            
        case 'log_client_action':
            $description = $input['description'] ?? 'Client action';
            $result = $logger->logClientAction('client_action', $description);
            break;
            
        default:
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Unknown action']);
            exit;
    }
    
    if ($result) {
        echo json_encode(['status' => 'success', 'message' => 'Activity logged']);
    } else {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'Failed to log activity']);
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Server error: ' . $e->getMessage()]);
}
?>
