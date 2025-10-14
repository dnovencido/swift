<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}
$input = json_decode(file_get_contents('php://input'), true);
$control = $input['control'] ?? '';
$arduinoIP = 'http://192.168.1.10';
try {
    $endpointMap = [
        'pumpTemp' => '/togglepump',    
        'heat' => '/toggleheat',         
        'mode' => '/togglemode'          
    ];
    $endpoint = $endpointMap[$control] ?? null;
    if (!$endpoint) {
        throw new Exception('Invalid control type');
    }
    $timestamp = time();
    $url = $arduinoIP . $endpoint . '?t=' . $timestamp;
    $context = stream_context_create([
        'http' => [
            'method' => 'GET',
            'timeout' => 5,
            'ignore_errors' => true
        ]
    ]);
    $response = file_get_contents($url, false, $context);
    if ($response !== false) {
        $result = json_decode($response, true);
        if ($result && isset($result['status']) && $result['status'] === 'success') {
            $stateFieldMap = [
                'pumpTemp' => 'pump',      
                'heat' => 'heat',          
                'mode' => 'mode'           
            ];
            $stateField = $stateFieldMap[$control] ?? $control;
            $state = $result[$stateField] ?? 'unknown';
            echo json_encode([
                'status' => 'success',
                'state' => $state,
                'message' => 'Water sprinkler control updated successfully' 
            ]);
        } else {
            throw new Exception('Arduino returned error: ' . ($result['message'] ?? 'Unknown error'));
        }
    } else {
        throw new Exception('Failed to connect to Arduino device');
    }
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'state' => 'unknown',
        'message' => 'Control temporarily unavailable: ' . $e->getMessage()
    ]);
}
?>