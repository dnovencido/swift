<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
date_default_timezone_set('Asia/Manila');
$currentTime = time();
$formattedTime = date('Y-m-d H:i:s', $currentTime);
$response = [
    'success' => true,
    'epoch' => $currentTime,
    'formatted' => $formattedTime,
    'timezone' => 'Asia/Manila',
    'timestamp' => date('c', $currentTime)
];
echo json_encode($response);
?>