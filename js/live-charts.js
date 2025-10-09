/**
 * SWIFT Live Charts Manager
 * Handles real-time line graphs for sensor data
 */

class LiveChartsManager {
    constructor() {
        this.charts = {};
        this.currentFilter = 'minute'; // Match the HTML default
        this.updateInterval = null;
        this.isInitialized = false;
        
        this.init();
    }
    
    init() {
        this.setupTimeFilterControls();
        this.initializeCharts();
        this.startLiveUpdates();
        this.isInitialized = true;
    }
    
    setupTimeFilterControls() {
        // Wait a bit to ensure DOM is fully ready
        setTimeout(() => {
            const filterButtons = document.querySelectorAll('.time-filter-btn');
            
            if (filterButtons.length === 0) {
                console.error('No filter buttons found!');
                return;
            }
            
            filterButtons.forEach((btn, index) => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    const filter = e.target.dataset.filter;
                    this.changeTimeFilter(filter);
                });
            });
        }, 100);
    }
    
    changeTimeFilter(filter) {
        if (filter === this.currentFilter) {
            return;
        }
        
        // Update active button
        document.querySelectorAll('.time-filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        const activeBtn = document.querySelector(`[data-filter="${filter}"]`);
        if (activeBtn) {
            activeBtn.classList.add('active');
        }
        
        this.currentFilter = filter;
        
        // Update all charts with new filter
        this.updateAllCharts();
    }
    
    initializeCharts() {
        // Temperature Chart
        this.charts.temperature = this.createChart('temperatureChart', {
            label: 'Temperature (°C)',
            color: '#ff6b6b',
            backgroundColor: 'rgba(255, 107, 107, 0.1)'
        });
        
        // Humidity Chart
        this.charts.humidity = this.createChart('humidityChart', {
            label: 'Humidity (%)',
            color: '#4ecdc4',
            backgroundColor: 'rgba(78, 205, 196, 0.1)'
        });
        
        // Ammonia Chart
        this.charts.ammonia = this.createChart('ammoniaChart', {
            label: 'Ammonia (ppm)',
            color: '#45b7d1',
            backgroundColor: 'rgba(69, 183, 209, 0.1)'
        });
        
        // Load initial data
        this.updateAllCharts();
    }
    
    createChart(canvasId, config) {
        const canvas = document.getElementById(canvasId);
        if (!canvas) {
            console.error(`Canvas element not found: ${canvasId}`);
            return null;
        }
        
        const ctx = canvas.getContext('2d');
        
        if (typeof Chart === 'undefined') {
            console.error('Chart.js is not loaded!');
            return null;
        }
        
        // Get scale values before creating chart
        const maxValue = this.getMaxValue(config.label);
        const stepSize = this.getStepSize(config.label);
        
        return new Chart(ctx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: config.label,
                    data: [],
                    borderColor: config.color,
                    backgroundColor: config.backgroundColor,
                    borderWidth: 2,
                    tension: 0.4,
                    fill: false,
                    pointRadius: 3,
                    pointHoverRadius: 5,
                    pointBackgroundColor: config.color,
                    pointBorderColor: '#fff',
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
                plugins: {
                    legend: {
                        display: false // Hide legend since we have individual chart titles
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        borderColor: config.color,
                        borderWidth: 1,
                        cornerRadius: 6,
                        displayColors: false,
                        callbacks: {
                            title: function(context) {
                                return context[0].label;
                            },
                            label: function(context) {
                                return `${config.label}: ${context.parsed.y}`;
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Time',
                            color: '#666',
                            font: {
                                size: 12
                            }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)',
                            drawBorder: false
                        },
                        ticks: {
                            color: '#666',
                            font: {
                                size: 11
                            },
                            maxTicksLimit: 8
                        }
                    },
                    y: {
                        display: true,
                        title: {
                            display: true,
                            text: config.label,
                            color: '#666',
                            font: {
                                size: 12
                            }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)',
                            drawBorder: false
                        },
                        ticks: {
                            color: '#666',
                            font: {
                                size: 11
                            },
                            stepSize: stepSize
                        },
                        min: 0,
                        max: maxValue
                    }
                },
                animation: {
                    duration: 750,
                    easing: 'easeInOutQuart'
                }
            }
        });
    }
    
    getMaxValue(label) {
        // Set specific maximum values for each sensor type
        if (label.includes('Temperature')) {
            return 50; // 0-50°C for temperature
        } else if (label.includes('Humidity')) {
            return 100; // 0-100% for humidity
        } else if (label.includes('Ammonia')) {
            return 150; // 0-150 ppm for ammonia
        }
        return 100; // Default fallback
    }
    
    getStepSize(label) {
        // Set step sizes of 5 for all sensor types
        if (label.includes('Temperature')) {
            return 5; // 5°C steps (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50)
        } else if (label.includes('Humidity')) {
            return 5; // 5% steps (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100)
        } else if (label.includes('Ammonia')) {
            return 5; // 5 ppm steps (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150)
        }
        return 5; // Default fallback
    }
    
    
    
    
    
    async updateAllCharts() {
        try {
            this.updateChartStatus('Loading...', '#666');
            
            const response = await fetch(`../php/get_historical_data.php?filter=${this.currentFilter}&limit=50`);
            const result = await response.json();
            
            if (result.status === 'success' && result.chart_data) {
                this.updateChartsWithData(result.chart_data);
                this.updateChartStatus(`Loaded ${result.data_points} data points`, '#28a745');
            } else {
                this.updateChartStatus('No data available', '#ffc107');
            }
            
        } catch (error) {
            console.error('Error updating charts:', error);
            this.updateChartStatus('Error loading data', '#f02849');
        }
    }
    
    updateChartsWithData(chartData) {
        // Update each chart with the corresponding data
        Object.keys(this.charts).forEach(sensorType => {
            const chart = this.charts[sensorType];
            const datasetIndex = this.getDatasetIndex(sensorType);
            
            if (datasetIndex !== -1 && chartData.datasets[datasetIndex]) {
                chart.data.labels = chartData.labels;
                chart.data.datasets[0].data = chartData.datasets[datasetIndex].data;
                chart.update('none'); // Update without animation for better performance
            }
        });
    }
    
    getDatasetIndex(sensorType) {
        const mapping = {
            'temperature': 0,
            'humidity': 1,
            'ammonia': 2
        };
        
        // Try exact match first
        let index = mapping[sensorType];
        
        // If not found, try case-insensitive match
        if (index === undefined) {
            const lowerSensorType = sensorType.toLowerCase();
            index = mapping[lowerSensorType];
        }
        
        // If still not found, try partial match
        if (index === undefined) {
            if (sensorType.includes('temp') || sensorType.includes('Temp')) {
                index = 0; // Temperature
            } else if (sensorType.includes('hum') || sensorType.includes('Hum')) {
                index = 1; // Humidity
            } else if (sensorType.includes('amm') || sensorType.includes('Amm')) {
                index = 2; // Ammonia
            }
        }
        
        return index !== undefined ? index : -1;
    }
    
    updateChartStatus(message, color = '#666') {
        document.querySelectorAll('.chart-status').forEach(status => {
            status.textContent = message;
            status.style.color = color;
        });
    }
    
    startLiveUpdates() {
        // Update charts every 30 seconds for live data
        this.updateInterval = setInterval(() => {
            if (this.isInitialized) {
                this.updateAllCharts();
            }
        }, 30000); // 30 seconds - charts don't need frequent updates
        
        // Also update when page becomes visible
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden && this.isInitialized) {
                this.updateAllCharts();
            }
        });
        
        console.log('Live charts updates started (30s interval)');
    }
    
    stopLiveUpdates() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
            console.log('Live charts updates stopped');
        }
    }
    
    destroy() {
        this.stopLiveUpdates();
        Object.values(this.charts).forEach(chart => {
            chart.destroy();
        });
        this.charts = {};
        this.isInitialized = false;
    }
}

// Auto-initialize when DOM is loaded
let liveChartsManager = null;

// Charts will be initialized by the dashboard to avoid conflicts
// document.addEventListener('DOMContentLoaded', () => {
//     // Only initialize if we're on the dashboard page
//     if (document.getElementById('temperatureChart')) {
//         liveChartsManager = new LiveChartsManager();
//         
//         // Export for manual access
//         window.SWIFT_CHARTS = {
//             getManager: () => liveChartsManager,
//             updateCharts: () => liveChartsManager ? liveChartsManager.updateAllCharts() : null,
//             changeFilter: (filter) => liveChartsManager ? liveChartsManager.changeTimeFilter(filter) : null
//         };
//     }
// });

// Cleanup when page unloads
window.addEventListener('beforeunload', () => {
    if (liveChartsManager) {
        liveChartsManager.destroy();
    }
});

console.log('SWIFT Live Charts Manager loaded');
