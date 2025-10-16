/**
 * SWIFT IoT System - live-charts.js
 * 
 * This file contains JavaScript functionality for the SWIFT IoT Smart Swine Farming System.
 * It handles user interface interactions, data visualization, and system control.
 * 
 * Features:
 * - Real-time data updates and visualization
 * - User interface interactions and controls
 * - Chart and graph rendering
 * - API communication and data handling
 * - Error handling and user feedback
 */

class LiveChartsManager {
    constructor() {
        this.charts = {};
        this.currentFilter = 'minute'; 
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
        document.querySelectorAll('.time-filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        const activeBtn = document.querySelector(`[data-filter="${filter}"]`);
        if (activeBtn) {
            activeBtn.classList.add('active');
        }
        this.currentFilter = filter;
        this.updateAllCharts();
    }
    initializeCharts() {
        this.charts.temperature = this.createChart('temperatureChart', {
            label: 'Temperature (°C)',
            color: '#ff6b6b',
            backgroundColor: 'rgba(255, 107, 107, 0.1)'
        });
        this.charts.humidity = this.createChart('humidityChart', {
            label: 'Humidity (%)',
            color: '#4ecdc4',
            backgroundColor: 'rgba(78, 205, 196, 0.1)'
        });
        this.charts.ammonia = this.createChart('ammoniaChart', {
            label: 'Ammonia (ppm)',
            color: '#45b7d1',
            backgroundColor: 'rgba(69, 183, 209, 0.1)'
        });
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
            // Try to wait a bit and retry
            setTimeout(() => {
                if (typeof Chart !== 'undefined') {
                    console.log('Chart.js loaded, retrying chart creation...');
                    this.createChart(canvasId, config);
                }
            }, 1000);
            return null;
        }
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
                        display: false 
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
        if (label.includes('Temperature')) {
            return 50; 
        } else if (label.includes('Humidity')) {
            return 100; 
        } else if (label.includes('Ammonia')) {
            return 150; 
        }
        return 100; 
    }
    getStepSize(label) {
        if (label.includes('Temperature')) {
            return 5; 
        } else if (label.includes('Humidity')) {
            return 5; 
        } else if (label.includes('Ammonia')) {
            return 5; 
        }
        return 5; 
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
        if (!chartData || !chartData.datasets || !chartData.labels) {
            console.warn('Invalid chart data received:', chartData);
            return;
        }
        
        Object.keys(this.charts).forEach(sensorType => {
            const chart = this.charts[sensorType];
            if (!chart || !chart.data) {
                console.warn(`Chart not initialized for ${sensorType}`);
                return;
            }
            
            const datasetIndex = this.getDatasetIndex(sensorType);
            if (datasetIndex !== -1 && chartData.datasets[datasetIndex]) {
                chart.data.labels = chartData.labels;
                chart.data.datasets[0].data = chartData.datasets[datasetIndex].data;
                chart.update('none'); 
            }
        });
    }
    getDatasetIndex(sensorType) {
        const mapping = {
            'temperature': 0,
            'humidity': 1,
            'ammonia': 2
        };
        let index = mapping[sensorType];
        if (index === undefined) {
            const lowerSensorType = sensorType.toLowerCase();
            index = mapping[lowerSensorType];
        }
        if (index === undefined) {
            if (sensorType.includes('temp') || sensorType.includes('Temp')) {
                index = 0; 
            } else if (sensorType.includes('hum') || sensorType.includes('Hum')) {
                index = 1; 
            } else if (sensorType.includes('amm') || sensorType.includes('Amm')) {
                index = 2; 
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
        this.updateInterval = setInterval(() => {
            if (this.isInitialized) {
                this.updateAllCharts();
            }
        }, 30000); 
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
let liveChartsManager = null;
window.addEventListener('beforeunload', () => {
    if (liveChartsManager) {
        liveChartsManager.destroy();
    }
});
console.log('SWIFT Live Charts Manager loaded');
