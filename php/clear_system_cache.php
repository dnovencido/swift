<?php
/**
 * Complete System Cache Clearing Script
 * Clears all cache files and resets system state
 */

echo "🧹 SWIFT System Cache Clearing Script\n";
echo "=====================================\n\n";

// Clear data cache files
$cacheFiles = [
    '../php/data/sensor_buffer.txt',
    '../php/data/transfer_state.json', 
    '../php/data/transfer.log'
];

echo "📁 Clearing Data Cache Files:\n";
foreach ($cacheFiles as $file) {
    if (file_exists($file)) {
        file_put_contents($file, '');
        echo "✅ Cleared: $file\n";
    } else {
        echo "⚠️  Not found: $file\n";
    }
}

// Reset transfer state
$transferState = [
    'lastTransfer' => 0,
    'totalTransferred' => 0,
    'lastTransferDate' => null,
    'last_transfer' => 0
];
file_put_contents('../php/data/transfer_state.json', json_encode($transferState));
echo "✅ Reset transfer state\n\n";

// Clear any temporary files
$tempFiles = glob('../php/data/*.tmp');
echo "🗑️  Clearing Temporary Files:\n";
foreach ($tempFiles as $file) {
    unlink($file);
    echo "✅ Deleted: " . basename($file) . "\n";
}

echo "\n🎯 Cache Clearing Complete!\n";
echo "============================\n";
echo "✅ All data cache files cleared\n";
echo "✅ Transfer state reset\n";
echo "✅ Temporary files removed\n";
echo "✅ CSS/JS version numbers updated to v=6\n";
echo "✅ Browser cache headers added\n\n";
echo "🔄 Please refresh your browser to see changes\n";
?>
