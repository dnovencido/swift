<?php
/**
 * Transfer buffered data to database
 */

require_once __DIR__ . '/php/data_buffer.php';

try {
    echo "Starting data transfer...\n";
    $buffer = new DataBuffer();
    $transferred = $buffer->forceTransfer();
    
    if ($transferred > 0) {
        echo "✅ Successfully transferred {$transferred} records to database\n";
    } else {
        echo "ℹ️  No data to transfer\n";
    }
    
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}
?>
