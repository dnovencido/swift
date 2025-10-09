<?php
/**
 * Control Events API
 * Handles logging and retrieving control events
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/../control_event_logger.php';

try {
    $method = $_SERVER['REQUEST_METHOD'];
    $logger = new ControlEventLogger();
    
    if ($method === 'GET') {
        // Get control events
        $deviceId = isset($_GET['device_id']) ? (int)$_GET['device_id'] : null;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 50;
        
        $events = $logger->getControlEvents($deviceId, $limit);
        
        echo json_encode([
            'status' => 'success',
            'data' => $events,
            'count' => count($events)
        ]);
        
    } elseif ($method === 'POST') {
        // Log a control event
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!$input) {
            throw new Exception('Invalid input');
        }
        
        $required = ['device_id', 'event_type', 'trigger_reason', 'new_state'];
        foreach ($required as $field) {
            if (!isset($input[$field])) {
                throw new Exception("Missing required field: $field");
            }
        }
        
        $result = $logger->logControlEvent(
            $input['device_id'],
            $input['event_type'],
            $input['trigger_reason'],
            $input['trigger_value'] ?? null,
            $input['previous_state'] ?? null,
            $input['new_state']
        );
        
        if ($result) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Control event logged successfully'
            ]);
        } else {
            throw new Exception('Failed to log control event');
        }
        
    } else {
        http_response_code(405);
        echo json_encode([
            'status' => 'error',
            'message' => 'Method not allowed'
        ]);
    }
    
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>