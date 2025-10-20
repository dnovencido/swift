<?php
require 'php/db.php';

try {
    $pdo = DatabaseConnectionProvider::client();
    $stmt = $pdo->query('DESCRIBE raw_sensor_data');
    
    echo "Database table structure:\n";
    while($row = $stmt->fetch()) {
        echo $row['Field'] . ' - ' . $row['Type'] . "\n";
    }
    
    echo "\nLatest sensor data:\n";
    $stmt = $pdo->query('SELECT * FROM raw_sensor_data ORDER BY timestamp DESC LIMIT 1');
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    print_r($data);
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
