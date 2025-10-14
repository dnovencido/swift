<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/AlertManager.php';

try {
    $method = $_SERVER['REQUEST_METHOD'];
    $alertManager = new AlertManager();
    
    if ($method === 'GET') {
        $startDate = $_GET['start_date'] ?? date('Y-m-d');
        $endDate = $_GET['end_date'] ?? date('Y-m-d');
        $deviceId = $_GET['device_id'] ?? null;
        $status = $_GET['status'] ?? null;
        $type = $_GET['type'] ?? null;
        
        $alerts = $alertManager->getAlerts($startDate, $endDate, $deviceId, $status);
        
        if ($type !== null) {
            $alerts = array_filter($alerts, function($alert) use ($type) {
                return $alert['alert_type'] === $type;
            });
        }
        
        echo json_encode([
            'status' => 'success',
            'data' => $alerts,
            'count' => count($alerts),
            'date_range' => ['start' => $startDate, 'end' => $endDate]
        ]);
        
    } elseif ($method === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!$input) {
            throw new Exception('Invalid input');
        }
        
        $alertId = $alertManager->createAlert($input);
        
        if ($alertId) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Alert created successfully',
                'alert_id' => $alertId
            ]);
        } else {
            throw new Exception('Failed to create alert');
        }
        
    } elseif ($method === 'PUT') {
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!$input || !isset($input['alert_id']) || !isset($input['status'])) {
            throw new Exception('Missing required fields: alert_id, status');
        }
        
        $result = $alertManager->updateAlertStatus(
            $input['alert_id'],
            $input['status'],
            $input['user_id'] ?? null,
            $input['notes'] ?? null
        );
        
        if ($result) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Alert status updated successfully'
            ]);
        } else {
            throw new Exception('Failed to update alert status');
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
