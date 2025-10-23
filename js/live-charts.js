/**
 * SWIFT IoT System - Live Charts JavaScript
 * 
 * This JavaScript file handles real-time chart updates and data visualization
 * for the SWIFT IoT Smart Swine Farming System dashboard.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Chart configuration and data management
let chartData = {
    temperature: {
        labels: [],
        data: [],
        maxPoints: 50
    },
    humidity: {
        labels: [],
        data: [],
        maxPoints: 50
    },
    ammonia: {
        labels: [],
        data: [],
        maxPoints: 50
    }
};

let chartInstances = {};
let chartUpdateInterval;

/**
 * Initialize live charts system
 */
function initializeLiveCharts() {
    console.log('Initializing live charts...');
    
    // Initialize all chart instances
    initializeTemperatureChart();
    initializeHumidityChart();
    initializeAmmoniaChart();
    
    // Start chart update interval
    startChartUpdates();
    
    console.log('Live charts initialized successfully');
}

/**
 * Initialize temperature chart
 */
function initializeTemperatureChart() {
    const ctx = document.getElementById('temperatureChart');
    if (!ctx) {
        console.warn('Temperature chart canvas not found');
        return;
    }
    
    chartInstances.temperature = new Chart(ctx, {
        type: 'line',
        data: {
            labels: chartData.temperature.labels,
            datasets: [{
                label: 'Temperature (°C)',
                data: chartData.temperature.data,
                borderColor: '#ff6b6b',
                backgroundColor: 'rgba(255, 107, 107, 0.1)',
                borderWidth: 2,
                tension: 0.4,
                fill: true,
                pointRadius: 3,
                pointHoverRadius: 6,
                pointBackgroundColor: '#ff6b6b',
                pointBorderColor: '#ffffff',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            scales: {
                x: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Time',
                        color: '#666'
                    },
                    grid: {
                        color: 'rgba(0,0,0,0.1)'
                    }
                },
                y: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Temperature (°C)',
                        color: '#666'
                    },
                    min: 0,
                    max: 50,
                    grid: {
                        color: 'rgba(0,0,0,0.1)'
                    },
                    ticks: {
                        callback: function(value) {
                            return value + '°C';
                        }
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    titleColor: '#fff',
                    bodyColor: '#fff',
                    borderColor: '#ff6b6b',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            return `Temperature: ${context.parsed.y.toFixed(1)}°C`;
                        }
                    }
                }
            },
            animation: {
                duration: 750,
                easing: 'easeInOutQuart'
            }
        }
    });
}

/**
 * Initialize humidity chart
 */
function initializeHumidityChart() {
    const ctx = document.getElementById('humidityChart');
    if (!ctx) {
        console.warn('Humidity chart canvas not found');
        return;
    }
    
    chartInstances.humidity = new Chart(ctx, {
        type: 'line',
        data: {
            labels: chartData.humidity.labels,
            datasets: [{
                label: 'Humidity (%)',
                data: chartData.humidity.data,
                borderColor: '#4ecdc4',
                backgroundColor: 'rgba(78, 205, 196, 0.1)',
                borderWidth: 2,
                tension: 0.4,
                fill: true,
                pointRadius: 3,
                pointHoverRadius: 6,
                pointBackgroundColor: '#4ecdc4',
                pointBorderColor: '#ffffff',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            scales: {
                x: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Time',
                        color: '#666'
                    },
                    grid: {
                        color: 'rgba(0,0,0,0.1)'
                    }
                },
                y: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Humidity (%)',
                        color: '#666'
                    },
                    min: 0,
                    max: 100,
                    grid: {
                        color: 'rgba(0,0,0,0.1)'
                    },
                    ticks: {
                        callback: function(value) {
                            return value + '%';
                        }
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    titleColor: '#fff',
                    bodyColor: '#fff',
                    borderColor: '#4ecdc4',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            return `Humidity: ${context.parsed.y.toFixed(1)}%`;
                        }
                    }
                }
            },
            animation: {
                duration: 750,
                easing: 'easeInOutQuart'
            }
        }
    });
}

/**
 * Initialize ammonia chart
 */
function initializeAmmoniaChart() {
    const ctx = document.getElementById('ammoniaChart');
    if (!ctx) {
        console.warn('Ammonia chart canvas not found');
        return;
    }
    
    chartInstances.ammonia = new Chart(ctx, {
        type: 'line',
        data: {
            labels: chartData.ammonia.labels,
            datasets: [{
                label: 'Ammonia (ppm)',
                data: chartData.ammonia.data,
                borderColor: '#45b7d1',
                backgroundColor: 'rgba(69, 183, 209, 0.1)',
                borderWidth: 2,
                tension: 0.4,
                fill: true,
                pointRadius: 3,
                pointHoverRadius: 6,
                pointBackgroundColor: '#45b7d1',
                pointBorderColor: '#ffffff',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            scales: {
                x: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Time',
                        color: '#666'
                    },
                    grid: {
                        color: 'rgba(0,0,0,0.1)'
                    }
                },
                y: {
                    display: true,
                    title: {
                        display: true,
                        text: 'Ammonia (ppm)',
                        color: '#666'
                    },
                    min: 0,
                    max: 100,
                    grid: {
                        color: 'rgba(0,0,0,0.1)'
                    },
                    ticks: {
                        callback: function(value) {
                            return value + ' ppm';
                        }
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    titleColor: '#fff',
                    bodyColor: '#fff',
                    borderColor: '#45b7d1',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            return `Ammonia: ${context.parsed.y.toFixed(1)} ppm`;
                        }
                    }
                }
            },
            animation: {
                duration: 750,
                easing: 'easeInOutQuart'
            }
        }
    });
}

/**
 * Start chart update interval
 */
function startChartUpdates() {
    // Update charts every 2 seconds
    chartUpdateInterval = setInterval(() => {
        updateAllCharts();
    }, 2000);
    
    console.log('Chart updates started');
}

/**
 * Update all charts with new data
 */
function updateAllCharts() {
    // This function will be called by the main dashboard to update charts
    // with the latest sensor data
    if (window.sensorData) {
        addDataPoint('temperature', window.sensorData.temperature);
        addDataPoint('humidity', window.sensorData.humidity);
        addDataPoint('ammonia', window.sensorData.ammonia);
    }
}

/**
 * Add new data point to chart
 */
function addDataPoint(chartType, value) {
    if (!chartInstances[chartType] || !chartData[chartType]) {
        return;
    }
    
    const now = new Date();
    const timeLabel = now.toLocaleTimeString();
    
    // Add new data point
    chartData[chartType].labels.push(timeLabel);
    chartData[chartType].data.push(value);
    
    // Remove old data points if exceeding max points
    if (chartData[chartType].labels.length > chartData[chartType].maxPoints) {
        chartData[chartType].labels.shift();
        chartData[chartType].data.shift();
    }
    
    // Update chart
    chartInstances[chartType].update('none');
}

/**
 * Update chart with specific sensor data
 */
function updateChartWithData(chartType, value) {
    addDataPoint(chartType, value);
}

/**
 * Clear all chart data
 */
function clearChartData() {
    Object.keys(chartData).forEach(chartType => {
        chartData[chartType].labels = [];
        chartData[chartType].data = [];
        
        if (chartInstances[chartType]) {
            chartInstances[chartType].update();
        }
    });
    
    console.log('Chart data cleared');
}

/**
 * Set chart time range
 */
function setChartTimeRange(range) {
    let maxPoints;
    
    switch (range) {
        case 'minute':
            maxPoints = 30; // 30 data points for 1 minute
            break;
        case 'hour':
            maxPoints = 60; // 60 data points for 1 hour
            break;
        case 'day':
            maxPoints = 144; // 144 data points for 1 day (10-minute intervals)
            break;
        default:
            maxPoints = 50;
    }
    
    // Update max points for all charts
    Object.keys(chartData).forEach(chartType => {
        chartData[chartType].maxPoints = maxPoints;
        
        // Trim data if necessary
        while (chartData[chartType].labels.length > maxPoints) {
            chartData[chartType].labels.shift();
            chartData[chartType].data.shift();
        }
        
        // Update chart
        if (chartInstances[chartType]) {
            chartInstances[chartType].update();
        }
    });
    
    console.log(`Chart time range set to: ${range} (${maxPoints} points)`);
}

/**
 * Export chart data
 */
function exportChartData() {
    const exportData = {
        timestamp: new Date().toISOString(),
        charts: {}
    };
    
    Object.keys(chartData).forEach(chartType => {
        exportData.charts[chartType] = {
            labels: chartData[chartType].labels,
            data: chartData[chartType].data
        };
    });
    
    // Create and download JSON file
    const dataStr = JSON.stringify(exportData, null, 2);
    const dataBlob = new Blob([dataStr], { type: 'application/json' });
    const url = URL.createObjectURL(dataBlob);
    
    const link = document.createElement('a');
    link.href = url;
    link.download = `swift_sensor_data_${new Date().toISOString().split('T')[0]}.json`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
    
    console.log('Chart data exported');
}

/**
 * Get chart statistics
 */
function getChartStatistics() {
    const stats = {};
    
    Object.keys(chartData).forEach(chartType => {
        const data = chartData[chartType].data;
        if (data.length > 0) {
            stats[chartType] = {
                min: Math.min(...data),
                max: Math.max(...data),
                avg: data.reduce((a, b) => a + b, 0) / data.length,
                count: data.length
            };
        }
    });
    
    return stats;
}

/**
 * Add threshold lines to charts
 */
function addThresholdLines() {
    // Temperature thresholds
    if (chartInstances.temperature) {
        chartInstances.temperature.options.plugins.annotation = {
            annotations: {
                highTemp: {
                    type: 'line',
                    yMin: 30,
                    yMax: 30,
                    borderColor: '#dc3545',
                    borderWidth: 2,
                    borderDash: [5, 5],
                    label: {
                        content: 'High Temp Threshold',
                        enabled: true,
                        position: 'end'
                    }
                },
                lowTemp: {
                    type: 'line',
                    yMin: 15,
                    yMax: 15,
                    borderColor: '#17a2b8',
                    borderWidth: 2,
                    borderDash: [5, 5],
                    label: {
                        content: 'Low Temp Threshold',
                        enabled: true,
                        position: 'end'
                    }
                }
            }
        };
        chartInstances.temperature.update();
    }
    
    // Ammonia threshold
    if (chartInstances.ammonia) {
        chartInstances.ammonia.options.plugins.annotation = {
            annotations: {
                highAmmonia: {
                    type: 'line',
                    yMin: 50,
                    yMax: 50,
                    borderColor: '#dc3545',
                    borderWidth: 2,
                    borderDash: [5, 5],
                    label: {
                        content: 'High Ammonia Threshold',
                        enabled: true,
                        position: 'end'
                    }
                }
            }
        };
        chartInstances.ammonia.update();
    }
}

/**
 * Cleanup charts when page is unloaded
 */
function cleanupCharts() {
    if (chartUpdateInterval) {
        clearInterval(chartUpdateInterval);
    }
    
    Object.values(chartInstances).forEach(chart => {
        if (chart) {
            chart.destroy();
        }
    });
    
    console.log('Charts cleaned up');
}

// Initialize charts when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Wait for Chart.js to be loaded
    if (typeof Chart !== 'undefined') {
        initializeLiveCharts();
    } else {
        console.error('Chart.js library not loaded');
    }
});

// Cleanup on page unload
window.addEventListener('beforeunload', cleanupCharts);

console.log('Live Charts JavaScript loaded successfully');
