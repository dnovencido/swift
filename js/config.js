/**
 * SWIFT IoT System - config.js
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

if (typeof window.SWIFT_CONFIG !== 'undefined') {
    console.warn('SWIFT_CONFIG already defined. Skipping redefinition.');
} else {
    window.SWIFT_CONFIG = {
        version: '2.1.0',
        name: 'SWIFT IoT Smart Swine Farming System',
        buildDate: '2024-01-15',
        arduinoIP: 'http://192.168.1.11',
        apiBaseUrl: '/SWIFT/NEW_SWIFT/php',
        endpoints: {
            saveRealtimeData: '/save_realtime_data.php',
            getLatestSensorData: '/get_latest_sensor_data.php',
            getHistoricalData: '/get_historical_data.php',
            getReportData: '/get_report_data.php',
            toggleControl: '/toggle_control.php',
            updateDeviceStatus: '/update_device_status.php',
            adminAuth: '/admin_auth.php',
            adminLists: '/admin_lists.php',
            adminStats: '/admin_stats.php',
            adminUsers: '/admin_users.php',
            adminFarms: '/admin_farms.php',
            getActivityLog: '/get_activity_log.php',
            apiV1: {
                auth: '/api/v1/auth.php',
                sensors: '/api/v1/sensors.php',
                controls: '/api/v1/controls.php',
                reports: '/api/v1/reports.php',
                weeklyReports: '/api/v1/weekly_reports.php'
            }
        },
        timing: {
            dataRefreshInterval: 1000,        
            deviceStatusInterval: 5000,       
            chartUpdateInterval: 2000,        
            connectionTimeout: 10000,         
            retryDelay: 2000,                 
            maxRetries: 3
        },
        features: {
            realTimeCharts: true,
            deviceControl: true,
            reportGeneration: true,
            dataExport: true,
            activityLogging: true,
            responsiveDesign: true,
            offlineMode: false,
            pushNotifications: false,
            darkMode: false
        },
        charts: {
            defaultColors: {
                temperature: '#ff6b6b',
                humidity: '#4ecdc4',
                ammonia: '#45b7d1',
                pump: '#96ceb4',
                heat: '#feca57'
            },
            animationDuration: 750,
            responsive: true,
            maintainAspectRatio: false
        },
        thresholds: {
            temperature: {
                low: 18.0,
                high: 25.0,
                critical: 30.0
            },
            humidity: {
                high: 70.0,
                critical: 85.0
            },
            ammonia: {
                high: 3.5,
                critical: 5.0
            }
        },
        ui: {
            theme: 'light',
            language: 'en',
            dateFormat: 'YYYY-MM-DD',
            timeFormat: 'HH:mm:ss',
            numberFormat: {
                decimals: 2,
                thousandsSeparator: ',',
                decimalSeparator: '.'
            }
        },
        security: {
            enableCSRF: true,
            sessionTimeout: 3600000, 
            maxLoginAttempts: 5,
            passwordMinLength: 8
        },
        performance: {
            enableCaching: true,
            cacheVersion: '6',
            lazyLoadImages: true,
            debounceDelay: 300,
            throttleDelay: 100
        },
        debug: {
            enabled: false,
            logLevel: 'info', 
            showTimestamps: true,
            enableConsoleLogging: false
        },
        utils: {
            getApiUrl: function(endpoint) {
                return this.apiBaseUrl + endpoint;
            },
            getArduinoUrl: function(control) {
                return `${this.arduinoIP}/toggle${control}`;
            },
            isFeatureEnabled: function(feature) {
                return this.features[feature] === true;
            },
            getThreshold: function(sensor, level) {
                return this.thresholds[sensor]?.[level] || 0;
            },
            formatNumber: function(value) {
                const config = this.ui.numberFormat;
                return Number(value).toFixed(config.decimals)
                    .replace(/\B(?=(\d{3})+(?!\d))/g, config.thousandsSeparator);
            }
        }
    };
    Object.freeze(window.SWIFT_CONFIG);
    Object.freeze(window.SWIFT_CONFIG.endpoints);
    Object.freeze(window.SWIFT_CONFIG.features);
    Object.freeze(window.SWIFT_CONFIG.thresholds);
    Object.freeze(window.SWIFT_CONFIG.utils);
    if (window.SWIFT_CONFIG.debug.enabled) {
        console.log('SWIFT Configuration loaded:', window.SWIFT_CONFIG);
    }
}