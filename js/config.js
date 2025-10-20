/**
 * SWIFT IoT Smart Swine Farming System - Configuration
 * Version: 2.1.0 (Production Ready)
 * 
 * Runtime configuration for the SWIFT web application
 * Contains all system settings, API endpoints, and feature flags
 * 
 * @author SWIFT Development Team
 * @version 2.1.0
 * @since 2024-01-15
 */

// Prevent multiple definitions
if (typeof window.SWIFT_CONFIG !== 'undefined') {
    console.warn('SWIFT_CONFIG already defined. Skipping redefinition.');
} else {
    window.SWIFT_CONFIG = {
        // System Information
        version: '2.1.0',
        name: 'SWIFT IoT Smart Swine Farming System',
        buildDate: '2024-01-15',
        
        // Network Configuration
        arduinoIP: 'http://192.168.1.100', // Arduino UNO R4 WiFi IP address
        apiBaseUrl: '/SWIFT/NEW_SWIFT/php',
        
        // API Endpoints
        endpoints: {
            // Data endpoints
            saveRealtimeData: '/save_realtime_data.php',
            getLatestSensorData: '/get_latest_sensor_data.php',
            getHistoricalData: '/get_historical_data.php',
            getReportData: '/get_report_data.php',
            
            // Control endpoints
            toggleControl: '/toggle_control.php',
            updateDeviceStatus: '/update_device_status.php',
            
            // Admin endpoints
            adminAuth: '/admin_auth.php',
            adminLists: '/admin_lists.php',
            adminStats: '/admin_stats.php',
            adminUsers: '/admin_users.php',
            adminFarms: '/admin_farms.php',
            getActivityLog: '/get_activity_log.php',
            
            // API v1 endpoints
            apiV1: {
                auth: '/api/v1/auth.php',
                sensors: '/api/v1/sensors.php',
                controls: '/api/v1/controls.php',
                reports: '/api/v1/reports.php',
                weeklyReports: '/api/v1/weekly_reports.php'
            }
        },
        
        // Timing Configuration
        timing: {
            dataRefreshInterval: 1000,        // 1 second
            deviceStatusInterval: 5000,       // 5 seconds
            chartUpdateInterval: 2000,        // 2 seconds
            connectionTimeout: 10000,         // 10 seconds
            retryDelay: 2000,                 // 2 seconds
            maxRetries: 3
        },
        
        // Feature Flags
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
        
        // Chart Configuration
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
        
        // Alert Thresholds
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
        
        // UI Configuration
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
        
        // Security Configuration
        security: {
            enableCSRF: true,
            sessionTimeout: 3600000, // 1 hour in milliseconds
            maxLoginAttempts: 5,
            passwordMinLength: 8
        },
        
        // Performance Configuration
        performance: {
            enableCaching: true,
            cacheVersion: '6',
            lazyLoadImages: true,
            debounceDelay: 300,
            throttleDelay: 100
        },
        
        // Debug Configuration
        debug: {
            enabled: false,
            logLevel: 'info', // debug, info, warn, error
            showTimestamps: true,
            enableConsoleLogging: false
        },
        
        // Utility Methods
        utils: {
            /**
             * Get full API URL for an endpoint
             * @param {string} endpoint - The endpoint path
             * @returns {string} Full URL
             */
            getApiUrl: function(endpoint) {
                return this.apiBaseUrl + endpoint;
            },
            
            /**
             * Get Arduino control URL
             * @param {string} control - Control type (pump, heat, etc.)
             * @returns {string} Full Arduino URL
             */
            getArduinoUrl: function(control) {
                return `${this.arduinoIP}/toggle${control}`;
            },
            
            /**
             * Check if feature is enabled
             * @param {string} feature - Feature name
             * @returns {boolean} True if enabled
             */
            isFeatureEnabled: function(feature) {
                return this.features[feature] === true;
            },
            
            /**
             * Get threshold value
             * @param {string} sensor - Sensor type
             * @param {string} level - Threshold level (low, high, critical)
             * @returns {number} Threshold value
             */
            getThreshold: function(sensor, level) {
                return this.thresholds[sensor]?.[level] || 0;
            },
            
            /**
             * Format number according to UI settings
             * @param {number} value - Number to format
             * @returns {string} Formatted number
             */
            formatNumber: function(value) {
                const config = this.ui.numberFormat;
                return Number(value).toFixed(config.decimals)
                    .replace(/\B(?=(\d{3})+(?!\d))/g, config.thousandsSeparator);
            }
        }
    };
    
    // Freeze configuration to prevent modifications
    Object.freeze(window.SWIFT_CONFIG);
    Object.freeze(window.SWIFT_CONFIG.endpoints);
    Object.freeze(window.SWIFT_CONFIG.features);
    Object.freeze(window.SWIFT_CONFIG.thresholds);
    Object.freeze(window.SWIFT_CONFIG.utils);
    
    // Log configuration loaded
    if (window.SWIFT_CONFIG.debug.enabled) {
        console.log('SWIFT Configuration loaded:', window.SWIFT_CONFIG);
    }
}



