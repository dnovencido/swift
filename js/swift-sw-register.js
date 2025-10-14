/**
 * SWIFT IoT System - swift-sw-register.js
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

(function() {
    'use strict';
    if (!('serviceWorker' in navigator)) {
        console.log('SWIFT: Service Worker not supported');
        return;
    }
    const SW_VERSION = '1.0.0';
    const SW_URL = '../swift-service-worker.js';
    async function clearExistingServiceWorkers() {
        try {
            const registrations = await navigator.serviceWorker.getRegistrations();
            for (let registration of registrations) {
                console.log('SWIFT: Unregistering old service worker', registration.scope);
                await registration.unregister();
            }
        } catch (error) {
            console.error('SWIFT: Error clearing service workers', error);
        }
    }
    async function registerServiceWorker() {
        try {
            console.log('SWIFT: Registering service worker...');
            const registration = await navigator.serviceWorker.register(SW_URL, {
                scope: '/SWIFT/NEW_SWIFT/',
                updateViaCache: 'none'
            });
            console.log('SWIFT: Service worker registered successfully', registration.scope);
            registration.addEventListener('updatefound', () => {
                console.log('SWIFT: Service worker update found');
                const newWorker = registration.installing;
                newWorker.addEventListener('statechange', () => {
                    if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                        console.log('SWIFT: New service worker installed, reloading page');
                        window.location.reload();
                    }
                });
            });
            return registration;
        } catch (error) {
            console.error('SWIFT: Service worker registration failed', error);
            return null;
        }
    }
    async function initServiceWorker() {
        try {
            await clearExistingServiceWorkers();
            await new Promise(resolve => setTimeout(resolve, 100));
            const registration = await registerServiceWorker();
            if (registration) {
                console.log('SWIFT: Service worker initialized successfully');
                navigator.serviceWorker.addEventListener('message', (event) => {
                    console.log('SWIFT: Message from service worker', event.data);
                });
                navigator.serviceWorker.addEventListener('controllerchange', () => {
                    console.log('SWIFT: Service worker controller changed');
                });
            }
        } catch (error) {
            console.error('SWIFT: Service worker initialization failed', error);
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initServiceWorker);
    } else {
        initServiceWorker();
    }
    window.SWIFT_SW = {
        init: initServiceWorker,
        clear: clearExistingServiceWorkers,
        version: SW_VERSION
    };
})();