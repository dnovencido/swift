/**
 * SWIFT IoT System - Live Dashboard JavaScript
 * 
 * This JavaScript file handles real-time data updates from Arduino devices
 * and provides interactive dashboard functionality for the SWIFT IoT system.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Global variables for dashboard functionality
let sensorData = {
    temperature: 0,
    humidity: 0,
    ammonia: 0,
    waterPumpStatus: false,
    heatBulbStatus: false,
    deviceStatus: 'offline',
    lastUpdate: null
};

let updateInterval;
let chartInstances = {};
let isDashboardActive = true;

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeDashboard();
    startRealTimeUpdates();
    initializeCharts();
    setupEventListeners();
});

/**
 * Initialize dashboard components
 */
function initializeDashboard() {
    console.log('Initializing SWIFT IoT Dashboard...');
    
    // Check user authentication
    checkUserAuthentication();
    
    // Load initial data
    loadSensorData();
    loadDeviceStatus();
    
    // Set up greeting
    updateGreeting();
    
    console.log('Dashboard initialized successfully');
}

/**
 * Check user authentication and redirect if needed
 */
function checkUserAuthentication() {
    try {
        const user = JSON.parse(localStorage.getItem('swift_user') || 'null');
        if (!user) {
            window.location.href = '../index.html';
            return;
        }
        
        // Update greeting with user info
        const greetingElement = document.getElementById('greeting');
        if (greetingElement) {
            const hour = new Date().getHours();
            const greeting = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
            greetingElement.textContent = `${greeting}, ${user.username}!`;
        }
        
    } catch (e) {
        console.error('Authentication check failed:', e);
        window.location.href = '../index.html';
    }
}

/**
 * Start real-time data updates
 */
function startRealTimeUpdates() {
    // Update every 2 seconds for real-time data
    updateInterval = setInterval(() => {
        if (isDashboardActive) {
            loadSensorData();
            loadDeviceStatus();
            updateCharts();
        }
    }, 2000);
    
    console.log('Real-time updates started');
}

/**
 * Load sensor data from API
 */
async function loadSensorData() {
    try {
        const response = await fetch('../php/api/v1/sensor_data.php?action=latest');
        const result = await response.json();
        
        if (result.success && result.data && result.data.length > 0) {
            const latestData = result.data[0];
            
            // Update sensor readings
            sensorData.temperature = parseFloat(latestData.temperature) || 0;
            sensorData.humidity = parseFloat(latestData.humidity) || 0;
            sensorData.ammonia = parseFloat(latestData.ammonia_level) || 0;
            sensorData.waterPumpStatus = latestData.water_sprinkler_status === 'on';
            sensorData.heatBulbStatus = latestData.heat_bulb_status === 'on';
            sensorData.deviceStatus = latestData.device_status || 'offline';
            sensorData.lastUpdate = latestData.timestamp;
            
            // Update UI elements
            updateSensorDisplays();
            updateDeviceControls();
            updateStatusIndicators();
            
        } else {
            console.warn('No sensor data available');
            setOfflineStatus();
        }
        
    } catch (error) {
        console.error('Error loading sensor data:', error);
        setOfflineStatus();
    }
}

/**
 * Load device status information
 */
async function loadDeviceStatus() {
    try {
        const response = await fetch('../php/api/v1/sensor_data.php?action=statistics');
        const result = await response.json();
        
        if (result.success) {
            updateDeviceStatistics(result);
        }
        
    } catch (error) {
        console.error('Error loading device status:', error);
    }
}

/**
 * Update sensor display elements
 */
function updateSensorDisplays() {
    // Update temperature display
    const tempElement = document.getElementById('temperature');
    if (tempElement) {
        tempElement.textContent = sensorData.temperature.toFixed(1) + '°C';
        tempElement.style.color = getTemperatureColor(sensorData.temperature);
    }
    
    // Update humidity display
    const humidityElement = document.getElementById('humidity');
    if (humidityElement) {
        humidityElement.textContent = sensorData.humidity.toFixed(1) + '%';
        humidityElement.style.color = getHumidityColor(sensorData.humidity);
    }
    
    // Update ammonia display
    const ammoniaElement = document.getElementById('ammonia');
    if (ammoniaElement) {
        ammoniaElement.textContent = sensorData.ammonia.toFixed(1) + ' ppm';
        ammoniaElement.style.color = getAmmoniaColor(sensorData.ammonia);
    }
}

/**
 * Update device control buttons
 */
function updateDeviceControls() {
    // Update water pump button
    const pumpButton = document.getElementById('pumpToggleBtn');
    if (pumpButton) {
        if (sensorData.waterPumpStatus) {
            pumpButton.innerHTML = '<i class="fas fa-power-off"></i> ON';
            pumpButton.style.background = '#28a745';
        } else {
            pumpButton.innerHTML = '<i class="fas fa-power-off"></i> OFF';
            pumpButton.style.background = '#6c757d';
        }
    }
    
    // Update heat bulb button
    const heatButton = document.getElementById('heatToggleBtn');
    if (heatButton) {
        if (sensorData.heatBulbStatus) {
            heatButton.innerHTML = '<i class="fas fa-power-off"></i> ON';
            heatButton.style.background = '#ffc107';
        } else {
            heatButton.innerHTML = '<i class="fas fa-power-off"></i> OFF';
            heatButton.style.background = '#6c757d';
        }
    }
    
    // Update device status displays
    const waterStatus = document.getElementById('waterSprinklerStatus');
    if (waterStatus) {
        waterStatus.textContent = sensorData.waterPumpStatus ? 'ACTIVE' : 'INACTIVE';
        waterStatus.style.color = sensorData.waterPumpStatus ? '#28a745' : '#6c757d';
    }
    
    const heatStatus = document.getElementById('heatStatus');
    if (heatStatus) {
        heatStatus.textContent = sensorData.heatBulbStatus ? 'ACTIVE' : 'INACTIVE';
        heatStatus.style.color = sensorData.heatBulbStatus ? '#ffc107' : '#6c757d';
    }
}

/**
 * Update status indicators
 */
function updateStatusIndicators() {
    const deviceStatusContainer = document.getElementById('deviceStatusContainer');
    if (deviceStatusContainer) {
        const statusHTML = generateDeviceStatusHTML();
        deviceStatusContainer.innerHTML = statusHTML;
    }
}

/**
 * Generate device status HTML
 */
function generateDeviceStatusHTML() {
    const statusClass = sensorData.deviceStatus === 'ACTIVE' ? 'success-state' : 
                       sensorData.deviceStatus === 'COMPONENT_ERROR' ? 'error-state' : 'warning-state';
    
    return `
        <div class="transfer-card ${statusClass}" style="display: flex; align-items: center; gap: 12px; padding: 12px;">
            <div class="card-icon">
                <i class="fas fa-microchip"></i>
            </div>
            <div style="flex: 1;">
                <div style="font-weight: 600; font-size: 14px;">Arduino Device Status</div>
                <div style="font-size: 12px; color: #666; margin-top: 2px;">
                    Status: ${sensorData.deviceStatus} | 
                    Last Update: ${sensorData.lastUpdate ? new Date(sensorData.lastUpdate).toLocaleTimeString() : 'Never'}
                </div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 12px; color: #666;">Temperature</div>
                <div style="font-weight: 600; color: ${getTemperatureColor(sensorData.temperature)};">
                    ${sensorData.temperature.toFixed(1)}°C
                </div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 12px; color: #666;">Humidity</div>
                <div style="font-weight: 600; color: ${getHumidityColor(sensorData.humidity)};">
                    ${sensorData.humidity.toFixed(1)}%
                </div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 12px; color: #666;">Ammonia</div>
                <div style="font-weight: 600; color: ${getAmmoniaColor(sensorData.ammonia)};">
                    ${sensorData.ammonia.toFixed(1)} ppm
                </div>
            </div>
        </div>
    `;
}

/**
 * Update device statistics
 */
function updateDeviceStatistics(data) {
    // Update any statistics displays if needed
    console.log('Device statistics updated:', data);
}

/**
 * Set offline status when no data is available
 */
function setOfflineStatus() {
    sensorData.deviceStatus = 'offline';
    sensorData.temperature = 0;
    sensorData.humidity = 0;
    sensorData.ammonia = 0;
    sensorData.waterPumpStatus = false;
    sensorData.heatBulbStatus = false;
    
    updateSensorDisplays();
    updateDeviceControls();
    updateStatusIndicators();
}

/**
 * Get color based on temperature value
 */
function getTemperatureColor(temp) {
    if (temp >= 30) return '#dc3545'; // Red - High
    if (temp <= 15) return '#17a2b8'; // Blue - Low
    return '#28a745'; // Green - Normal
}

/**
 * Get color based on humidity value
 */
function getHumidityColor(humidity) {
    if (humidity >= 80 || humidity <= 50) return '#ffc107'; // Yellow - Warning
    return '#28a745'; // Green - Normal
}

/**
 * Get color based on ammonia value
 */
function getAmmoniaColor(ammonia) {
    if (ammonia >= 50) return '#dc3545'; // Red - High
    return '#28a745'; // Green - Normal
}

/**
 * Initialize charts for data visualization
 */
function initializeCharts() {
    // Initialize temperature chart
    initializeTemperatureChart();
    
    // Initialize humidity chart
    initializeHumidityChart();
    
    // Initialize ammonia chart
    initializeAmmoniaChart();
}

/**
 * Initialize temperature chart
 */
function initializeTemperatureChart() {
    const ctx = document.getElementById('temperatureChart');
    if (!ctx) return;
    
    chartInstances.temperature = new Chart(ctx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Temperature (°C)',
                data: [],
                borderColor: '#ff6b6b',
                backgroundColor: 'rgba(255, 107, 107, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: false,
                    min: 0,
                    max: 50
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
}

/**
 * Initialize humidity chart
 */
function initializeHumidityChart() {
    const ctx = document.getElementById('humidityChart');
    if (!ctx) return;
    
    chartInstances.humidity = new Chart(ctx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Humidity (%)',
                data: [],
                borderColor: '#4ecdc4',
                backgroundColor: 'rgba(78, 205, 196, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    min: 0,
                    max: 100
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
}

/**
 * Initialize ammonia chart
 */
function initializeAmmoniaChart() {
    const ctx = document.getElementById('ammoniaChart');
    if (!ctx) return;
    
    chartInstances.ammonia = new Chart(ctx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Ammonia (ppm)',
                data: [],
                borderColor: '#45b7d1',
                backgroundColor: 'rgba(69, 183, 209, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    min: 0,
                    max: 100
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
}

/**
 * Update charts with new data
 */
function updateCharts() {
    const now = new Date();
    const timeLabel = now.toLocaleTimeString();
    
    // Update temperature chart
    if (chartInstances.temperature) {
        const tempChart = chartInstances.temperature;
        tempChart.data.labels.push(timeLabel);
        tempChart.data.datasets[0].data.push(sensorData.temperature);
        
        // Keep only last 20 data points
        if (tempChart.data.labels.length > 20) {
            tempChart.data.labels.shift();
            tempChart.data.datasets[0].data.shift();
        }
        
        tempChart.update('none');
    }
    
    // Update humidity chart
    if (chartInstances.humidity) {
        const humidityChart = chartInstances.humidity;
        humidityChart.data.labels.push(timeLabel);
        humidityChart.data.datasets[0].data.push(sensorData.humidity);
        
        if (humidityChart.data.labels.length > 20) {
            humidityChart.data.labels.shift();
            humidityChart.data.datasets[0].data.shift();
        }
        
        humidityChart.update('none');
    }
    
    // Update ammonia chart
    if (chartInstances.ammonia) {
        const ammoniaChart = chartInstances.ammonia;
        ammoniaChart.data.labels.push(timeLabel);
        ammoniaChart.data.datasets[0].data.push(sensorData.ammonia);
        
        if (ammoniaChart.data.labels.length > 20) {
            ammoniaChart.data.labels.shift();
            ammoniaChart.data.datasets[0].data.shift();
        }
        
        ammoniaChart.update('none');
    }
}

/**
 * Setup event listeners
 */
function setupEventListeners() {
    // Manual control buttons
    const pumpButton = document.getElementById('pumpToggleBtn');
    if (pumpButton) {
        pumpButton.addEventListener('click', toggleWaterPump);
    }
    
    const heatButton = document.getElementById('heatToggleBtn');
    if (heatButton) {
        heatButton.addEventListener('click', toggleHeatBulb);
    }
    
    // Time filter buttons
    const timeFilterButtons = document.querySelectorAll('.time-filter-btn');
    timeFilterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remove active class from all buttons
            timeFilterButtons.forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked button
            this.classList.add('active');
            
            // Update chart time range
            updateChartTimeRange(this.dataset.filter);
        });
    });
    
    // Logout button
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
    
    // Page visibility change
    document.addEventListener('visibilitychange', function() {
        if (document.hidden) {
            isDashboardActive = false;
        } else {
            isDashboardActive = true;
            loadSensorData(); // Refresh data when page becomes visible
        }
    });
}

/**
 * Toggle water pump manually
 */
async function toggleWaterPump() {
    try {
        const newStatus = !sensorData.waterPumpStatus;
        
        // Send command to Arduino (if you implement remote control)
        const response = await fetch('../php/api/v1/device_control.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                action: 'toggle_water_pump',
                status: newStatus ? 'on' : 'off'
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            sensorData.waterPumpStatus = newStatus;
            updateDeviceControls();
            showNotification(`Water pump ${newStatus ? 'activated' : 'deactivated'}`, 'success');
        } else {
            showNotification('Failed to control water pump: ' + result.message, 'error');
        }
        
    } catch (error) {
        console.error('Error controlling water pump:', error);
        showNotification('Error controlling water pump', 'error');
    }
}

/**
 * Toggle heat bulb manually
 */
async function toggleHeatBulb() {
    try {
        const newStatus = !sensorData.heatBulbStatus;
        
        // Send command to Arduino (if you implement remote control)
        const response = await fetch('../php/api/v1/device_control.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                action: 'toggle_heat_bulb',
                status: newStatus ? 'on' : 'off'
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            sensorData.heatBulbStatus = newStatus;
            updateDeviceControls();
            showNotification(`Heat bulb ${newStatus ? 'activated' : 'deactivated'}`, 'success');
        } else {
            showNotification('Failed to control heat bulb: ' + result.message, 'error');
        }
        
    } catch (error) {
        console.error('Error controlling heat bulb:', error);
        showNotification('Error controlling heat bulb', 'error');
    }
}

/**
 * Update chart time range
 */
function updateChartTimeRange(filter) {
    console.log('Updating chart time range:', filter);
    // Implement time range filtering for charts
}

/**
 * Handle user logout
 */
function handleLogout(e) {
    e.preventDefault();
    
    // Clear user session
    localStorage.removeItem('swift_user');
    
    // Stop real-time updates
    if (updateInterval) {
        clearInterval(updateInterval);
    }
    
    // Redirect to login page
    window.location.href = '../index.html';
}

/**
 * Show notification
 */
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    const bgColor = type === 'error' ? '#dc3545' : type === 'success' ? '#28a745' : '#17a2b8';
    
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${bgColor};
        color: white;
        padding: 12px 20px;
        border-radius: 4px;
        font-size: 14px;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        animation: slideIn 0.3s ease-out;
    `;
    
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 3000);
}

/**
 * Update greeting message
 */
function updateGreeting() {
    const greetingElement = document.getElementById('greeting');
    if (greetingElement) {
        const hour = new Date().getHours();
        const greeting = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
        
        try {
            const user = JSON.parse(localStorage.getItem('swift_user') || 'null');
            const username = user ? user.username : 'User';
            greetingElement.textContent = `${greeting}, ${username}!`;
        } catch (e) {
            greetingElement.textContent = `${greeting}!`;
        }
    }
}

// Cleanup when page is unloaded
window.addEventListener('beforeunload', function() {
    if (updateInterval) {
        clearInterval(updateInterval);
    }
});

console.log('SWIFT IoT Dashboard JavaScript loaded successfully');
