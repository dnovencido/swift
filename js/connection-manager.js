/**
 * SWIFT Connection Manager
 * Handles all network connections and provides status monitoring
 */

class ConnectionManager {
    constructor() {
        this.arduinoIP = (window.SWIFT_CONFIG && window.SWIFT_CONFIG.arduinoIP) ? window.SWIFT_CONFIG.arduinoIP : null;
        this.webappIP = window.location.hostname;
        this.connectionStatus = {
            arduino: 'unknown',
            webapp: 'unknown',
            lastCheck: null
        };
        this.retryCount = 0;
        this.maxRetries = 3;
        this.retryDelay = 5000; // 5 seconds
        
        this.init();
    }
    
    init() {
        // Remove any existing status indicators from DOM
        this.removeExistingStatusIndicators();
        
        // Start periodic connection checks
        this.startConnectionMonitoring();
        
        // Handle page visibility changes
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.checkConnections();
            }
        });
    }
    
    removeExistingStatusIndicators() {
        // Remove any existing status indicators
        const existingIndicator = document.getElementById('swift-connection-status');
        if (existingIndicator) {
            existingIndicator.remove();
        }
        
        // Also remove any elements with "Checking Connections" text
        const allElements = document.querySelectorAll('*');
        allElements.forEach(element => {
            if (element.textContent && element.textContent.includes('Checking Connections')) {
                element.remove();
            }
        });
    }
    
    // Status indicator functionality completely removed
    
    async startConnectionMonitoring() {
        // Initial check
        await this.checkConnections();
        
        // Check every 10 seconds for faster offline detection
        setInterval(() => {
            this.checkConnections();
        }, 10000);
    }
    
    async checkConnections() {
        this.connectionStatus.lastCheck = new Date();
        
        // Check Arduino connection
        await this.checkArduinoConnection();
        
        // Check webapp endpoints
        await this.checkWebappConnection();
        
        // Status indicator removed - no visual updates needed
    }
    
    async checkArduinoConnection() {
        if (!this.arduinoIP) {
            this.connectionStatus.arduino = 'unknown';
            return;
        }
        
        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 1000); // Reduced to 1 second timeout for faster detection
            
            const response = await fetch(`${this.arduinoIP}/data`, {
                signal: controller.signal,
                mode: 'cors',
                cache: 'no-cache'
            });
            
            clearTimeout(timeoutId);
            
            if (response.ok) {
                this.connectionStatus.arduino = 'online';
                this.retryCount = 0;
            } else {
                this.connectionStatus.arduino = 'offline';
                this.retryCount = 0; // Reset retry count on HTTP error
            }
            
        } catch (error) {
            this.connectionStatus.arduino = 'offline';
            
            // Only retry on network errors, not on timeouts
            if (error.name !== 'AbortError' && this.retryCount < this.maxRetries) {
                this.retryCount++;
                console.log(`Arduino connection retry ${this.retryCount}/${this.maxRetries}`);
                
                setTimeout(() => {
                    this.checkArduinoConnection();
                }, this.retryDelay);
            } else {
                // Reset retry count after max retries or timeout
                this.retryCount = 0;
            }
        }
    }
    
    async checkWebappConnection() {
        try {
            const response = await fetch('../php/get_latest_sensor_data.php', {
                method: 'GET',
                cache: 'no-cache'
            });
            
            if (response.ok) {
                this.connectionStatus.webapp = 'online';
            } else {
                this.connectionStatus.webapp = 'offline';
            }
            
        } catch (error) {
            this.connectionStatus.webapp = 'offline';
        }
    }
    
    // Safe fetch with timeout and error handling
    async safeFetch(url, options = {}) {
        const defaultOptions = {
            timeout: 5000,
            mode: 'cors',
            cache: 'no-cache'
        };
        
        const finalOptions = { ...defaultOptions, ...options };
        
        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), finalOptions.timeout);
            
            const response = await fetch(url, {
                ...finalOptions,
                signal: controller.signal
            });
            
            clearTimeout(timeoutId);
            return response;
            
        } catch (error) {
            if (error.name === 'AbortError') {
                throw new Error(`Request timeout after ${finalOptions.timeout}ms`);
            }
            throw error;
        }
    }
    
    // Get current connection status
    getStatus() {
        return {
            ...this.connectionStatus,
            timestamp: new Date().toISOString()
        };
    }
    
    // Force a connection check
    async forceCheck() {
        await this.checkConnections();
        return this.getStatus();
    }
}

// Auto-initialize the connection manager
let connectionManager = null;

document.addEventListener('DOMContentLoaded', () => {
    connectionManager = new ConnectionManager();
    
    // Export for manual access
    window.SWIFT_CONNECTION = {
        getManager: () => connectionManager,
        getStatus: () => connectionManager ? connectionManager.getStatus() : null,
        forceCheck: () => connectionManager ? connectionManager.forceCheck() : null
    };
});

// Handle service worker errors gracefully
window.addEventListener('error', (event) => {
    if (event.message && event.message.includes('swift-service-worker')) {
        console.warn('SWIFT: Service worker error detected, clearing cache...');
        
        // Clear service worker cache
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.getRegistrations().then(registrations => {
                registrations.forEach(registration => {
                    registration.unregister();
                });
            });
        }
    }
});

// Handle unhandled promise rejections
window.addEventListener('unhandledrejection', (event) => {
    if (event.reason && event.reason.message && event.reason.message.includes('swift-service-worker')) {
        console.warn('SWIFT: Service worker promise rejection detected');
        event.preventDefault();
    }
});

console.log('SWIFT Connection Manager loaded');
