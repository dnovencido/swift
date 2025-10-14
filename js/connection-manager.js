/**
 * SWIFT IoT System - connection-manager.js
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
        this.retryDelay = 5000; 
        this.init();
    }
    init() {
        this.removeExistingStatusIndicators();
        this.startConnectionMonitoring();
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.checkConnections();
            }
        });
    }
    removeExistingStatusIndicators() {
        const existingIndicator = document.getElementById('swift-connection-status');
        if (existingIndicator) {
            existingIndicator.remove();
        }
        const allElements = document.querySelectorAll('*');
        allElements.forEach(element => {
            if (element.textContent && element.textContent.includes('Checking Connections')) {
                element.remove();
            }
        });
    }
    async startConnectionMonitoring() {
        await this.checkConnections();
        setInterval(() => {
            this.checkConnections();
        }, 10000);
    }
    async checkConnections() {
        this.connectionStatus.lastCheck = new Date();
        await this.checkArduinoConnection();
        await this.checkWebappConnection();
    }
    async checkArduinoConnection() {
        if (!this.arduinoIP) {
            this.connectionStatus.arduino = 'unknown';
            return;
        }
        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 1000); 
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
                this.retryCount = 0; 
            }
        } catch (error) {
            this.connectionStatus.arduino = 'offline';
            if (error.name !== 'AbortError' && this.retryCount < this.maxRetries) {
                this.retryCount++;
                console.log(`Arduino connection retry ${this.retryCount}/${this.maxRetries}`);
                setTimeout(() => {
                    this.checkArduinoConnection();
                }, this.retryDelay);
            } else {
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
    getStatus() {
        return {
            ...this.connectionStatus,
            timestamp: new Date().toISOString()
        };
    }
    async forceCheck() {
        await this.checkConnections();
        return this.getStatus();
    }
}
let connectionManager = null;
document.addEventListener('DOMContentLoaded', () => {
    connectionManager = new ConnectionManager();
    window.SWIFT_CONNECTION = {
        getManager: () => connectionManager,
        getStatus: () => connectionManager ? connectionManager.getStatus() : null,
        forceCheck: () => connectionManager ? connectionManager.forceCheck() : null
    };
});
window.addEventListener('error', (event) => {
    if (event.message && event.message.includes('swift-service-worker')) {
        console.warn('SWIFT: Service worker error detected, clearing cache...');
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.getRegistrations().then(registrations => {
                registrations.forEach(registration => {
                    registration.unregister();
                });
            });
        }
    }
});
window.addEventListener('unhandledrejection', (event) => {
    if (event.reason && event.reason.message && event.reason.message.includes('swift-service-worker')) {
        console.warn('SWIFT: Service worker promise rejection detected');
        event.preventDefault();
    }
});
console.log('SWIFT Connection Manager loaded');