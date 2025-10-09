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

// Arduino IP configuration - Update this to match your Arduino's IP
$arduinoIP = 'http://192.168.1.11'; // Update this IP address

try {
    // Map control names to Arduino API endpoints
    $endpointMap = [
        'pumpTemp' => '/togglepump',    // Water sprinkler control
        'heat' => '/toggleheat',         // Heat control
        'mode' => '/togglemode'          // Mode toggle
    ];
    
    $endpoint = $endpointMap[$control] ?? null;
    if (!$endpoint) {
        throw new Exception('Invalid control type');
    }
    
    // Try to send control command to Arduino
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
            // Map Arduino response field names to our expected format
            $stateFieldMap = [
                'pumpTemp' => 'pump',      // Arduino returns 'pump' field
                'heat' => 'heat',          // Arduino returns 'heat' field
                'mode' => 'mode'           // Arduino returns 'mode' field
            ];
            
            $stateField = $stateFieldMap[$control] ?? $control;
            $state = $result[$stateField] ?? 'unknown';
            
            echo json_encode([
                'status' => 'success',
                'state' => $state,
                'message' => 'Water sprinkler control updated successfully' // Updated message
            ]);
        } else {
            throw new Exception('Arduino returned error: ' . ($result['message'] ?? 'Unknown error'));
        }
    } else {
        throw new Exception('Failed to connect to Arduino device');
    }
    
} catch (Exception $e) {
    // Fallback: return error but don't crash
    echo json_encode([
        'status' => 'error',
        'state' => 'unknown',
        'message' => 'Control temporarily unavailable: ' . $e->getMessage()
    ]);
}
?>
