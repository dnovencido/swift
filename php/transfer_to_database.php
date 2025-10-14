<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
if ($_SERVER['REQUEST_METHOD'] !== 'GET' || !isset($_GET['run']) || $_GET['run'] !== 'transfer') {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Invalid request. Use ?run=transfer']);
    exit;
}
require_once __DIR__ . '/data_buffer.php';
try {
    $buffer = new DataBuffer();
    $transferred = $buffer->forceTransfer();
    if ($transferred > 0) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Data transferred to database successfully',
            'records_transferred' => $transferred
        ]);
    } else {
        echo json_encode([
            'status' => 'success',
            'message' => 'No data to transfer',
            'records_transferred' => 0
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Transfer failed: ' . $e->getMessage()
    ]);
}
?>