/**
 * SWIFT IoT System - Configuration File
 * 
 * This configuration file contains all the system settings and constants
 * for the SWIFT IoT Smart Swine Farming System.
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// System Configuration
const SWIFT_CONFIG = {
    // API Endpoints
    API: {
        BASE_URL: '../php/api/v1/',
        SENSOR_DATA: 'sensor_data.php',
        DEVICE_CONTROL: 'device_control.php',
        AUTH: 'auth.php',
        SCHEDULES: 'schedules.php'
    },
    
    // Arduino Device Configuration
    DEVICE: {
        DEFAULT_ID: 1,
        UPDATE_INTERVAL: 2000, // 2 seconds
        TIMEOUT: 300000, // 5 minutes
        MAX_RETRIES: 3
    },
    
    // Environmental Thresholds (Philippines-specific for swine farming)
    THRESHOLDS: {
        TEMPERATURE: {
            HIGH: 30.0, // Celsius - Trigger water sprinkler
            LOW: 15.0,  // Celsius - Trigger heat bulb
            OPTIMAL_MIN: 18.0,
            OPTIMAL_MAX: 24.0
        },
        HUMIDITY: {
            HIGH: 80.0, // Percentage
            LOW: 50.0,  // Percentage
            OPTIMAL_MIN: 60.0,
            OPTIMAL_MAX: 70.0
        },
        AMMONIA: {
            HIGH: 50.0, // ppm - Trigger water sprinkler
            SAFE: 25.0, // ppm - Safe level
            OPTIMAL_MAX: 20.0
        }
    },
    
    // Chart Configuration
    CHARTS: {
        UPDATE_INTERVAL: 2000, // 2 seconds
        MAX_DATA_POINTS: {
            MINUTE: 30,
            HOUR: 60,
            DAY: 144
        },
        COLORS: {
            TEMPERATURE: '#ff6b6b',
            HUMIDITY: '#4ecdc4',
            AMMONIA: '#45b7d1',
            SUCCESS: '#28a745',
            WARNING: '#ffc107',
            DANGER: '#dc3545',
            INFO: '#17a2b8'
        }
    },
    
    // UI Configuration
    UI: {
        NOTIFICATION_DURATION: 3000, // 3 seconds
        ANIMATION_DURATION: 300, // 300ms
        REFRESH_INTERVAL: 5000, // 5 seconds
        MODAL_TIMEOUT: 10000 // 10 seconds
    },
    
    // Security Configuration
    SECURITY: {
        SESSION_TIMEOUT: 3600000, // 1 hour
        MAX_LOGIN_ATTEMPTS: 5,
        PASSWORD_MIN_LENGTH: 8,
        TOKEN_EXPIRY: 86400 // 24 hours
    },
    
    // Database Configuration
    DATABASE: {
        RETENTION_DAYS: 30,
        BACKUP_INTERVAL: 86400, // 24 hours
        MAX_CONNECTIONS: 10
    },
    
    // Alert Configuration
    ALERTS: {
        CHECK_INTERVAL: 60000, // 1 minute
        ESCALATION_TIME: 300000, // 5 minutes
        MAX_ALERTS_PER_HOUR: 10
    }
};

// Device Status Constants
const DEVICE_STATUS = {
    ONLINE: 'up',
    OFFLINE: 'down',
    ERROR: 'error',
    MAINTENANCE: 'maintenance'
};

// Component Status Constants
const COMPONENT_STATUS = {
    ACTIVE: 'active',
    ERROR: 'error',
    OFFLINE: 'offline'
};

// Alert Types
const ALERT_TYPES = {
    TEMPERATURE_HIGH: 'temperature_high',
    TEMPERATURE_LOW: 'temperature_low',
    AMMONIA_HIGH: 'ammonia_high',
    DEVICE_OFFLINE: 'device_offline',
    SENSOR_ERROR: 'sensor_error',
    HUMIDITY_HIGH: 'humidity_high',
    HUMIDITY_LOW: 'humidity_low'
};

// Device Control Actions
const DEVICE_ACTIONS = {
    TOGGLE_WATER_PUMP: 'toggle_water_pump',
    TOGGLE_HEAT_BULB: 'toggle_heat_bulb',
    EMERGENCY_STOP: 'emergency_stop',
    RESET_DEVICE: 'reset_device',
    UPDATE_SETTINGS: 'update_settings'
};

// Schedule Types
const SCHEDULE_TYPES = {
    ONCE: 'once',
    DAILY: 'daily',
    WEEKDAYS: 'weekdays',
    WEEKENDS: 'weekends',
    CUSTOM: 'custom'
};

// User Roles
const USER_ROLES = {
    SUPER_USER: 'super_user',
    ADMIN: 'admin',
    USER: 'user',
    VIEWER: 'viewer'
};

// API Response Status
const API_STATUS = {
    SUCCESS: 'success',
    ERROR: 'error',
    WARNING: 'warning',
    INFO: 'info'
};

// Utility Functions
const SWIFT_UTILS = {
    /**
     * Format temperature value with unit
     */
    formatTemperature: function(value) {
        return `${parseFloat(value).toFixed(1)}°C`;
    },
    
    /**
     * Format humidity value with unit
     */
    formatHumidity: function(value) {
        return `${parseFloat(value).toFixed(1)}%`;
    },
    
    /**
     * Format ammonia value with unit
     */
    formatAmmonia: function(value) {
        return `${parseFloat(value).toFixed(1)} ppm`;
    },
    
    /**
     * Get color based on temperature value
     */
    getTemperatureColor: function(temp) {
        if (temp >= SWIFT_CONFIG.THRESHOLDS.TEMPERATURE.HIGH) {
            return SWIFT_CONFIG.CHARTS.COLORS.DANGER;
        }
        if (temp <= SWIFT_CONFIG.THRESHOLDS.TEMPERATURE.LOW) {
            return SWIFT_CONFIG.CHARTS.COLORS.INFO;
        }
        return SWIFT_CONFIG.CHARTS.COLORS.SUCCESS;
    },
    
    /**
     * Get color based on humidity value
     */
    getHumidityColor: function(humidity) {
        if (humidity >= SWIFT_CONFIG.THRESHOLDS.HUMIDITY.HIGH || 
            humidity <= SWIFT_CONFIG.THRESHOLDS.HUMIDITY.LOW) {
            return SWIFT_CONFIG.CHARTS.COLORS.WARNING;
        }
        return SWIFT_CONFIG.CHARTS.COLORS.SUCCESS;
    },
    
    /**
     * Get color based on ammonia value
     */
    getAmmoniaColor: function(ammonia) {
        if (ammonia >= SWIFT_CONFIG.THRESHOLDS.AMMONIA.HIGH) {
            return SWIFT_CONFIG.CHARTS.COLORS.DANGER;
        }
        return SWIFT_CONFIG.CHARTS.COLORS.SUCCESS;
    },
    
    /**
     * Format timestamp for display
     */
    formatTimestamp: function(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleString();
    },
    
    /**
     * Get time ago string
     */
    getTimeAgo: function(timestamp) {
        const now = new Date();
        const past = new Date(timestamp);
        const diffMs = now - past;
        const diffMins = Math.floor(diffMs / 60000);
        const diffHours = Math.floor(diffMins / 60);
        const diffDays = Math.floor(diffHours / 24);
        
        if (diffMins < 1) return 'Just now';
        if (diffMins < 60) return `${diffMins} minute${diffMins > 1 ? 's' : ''} ago`;
        if (diffHours < 24) return `${diffHours} hour${diffHours > 1 ? 's' : ''} ago`;
        return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`;
    },
    
    /**
     * Validate email format
     */
    isValidEmail: function(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },
    
    /**
     * Validate IP address format
     */
    isValidIP: function(ip) {
        const ipRegex = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
        return ipRegex.test(ip);
    },
    
    /**
     * Debounce function for API calls
     */
    debounce: function(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },
    
    /**
     * Throttle function for frequent updates
     */
    throttle: function(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }
};

// Export configuration for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        SWIFT_CONFIG,
        DEVICE_STATUS,
        COMPONENT_STATUS,
        ALERT_TYPES,
        DEVICE_ACTIONS,
        SCHEDULE_TYPES,
        USER_ROLES,
        API_STATUS,
        SWIFT_UTILS
    };
}

console.log('SWIFT IoT Configuration loaded successfully');
