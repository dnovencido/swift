<?php
// Local Time API - Fallback time sync for Arduino
// File: php/api/time.php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Set Philippines timezone
date_default_timezone_set('Asia/Manila');

// Get current time in Philippines timezone
$currentTime = time();
$formattedTime = date('Y-m-d H:i:s', $currentTime);

// Return JSON response
$response = [
    'success' => true,
    'epoch' => $currentTime,
    'formatted' => $formattedTime,
    'timezone' => 'Asia/Manila',
    'timestamp' => date('c', $currentTime)
];

echo json_encode($response);
?>
