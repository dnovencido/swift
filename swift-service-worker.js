/**
 * SWIFT IoT System - Service Worker for Progressive Web App (PWA)
 *
 * This service worker provides offline capabilities, caching strategies, and background
 * synchronization for the SWIFT IoT Smart Swine Farming System. It implements a
 * network-first caching strategy with fallback to cached content for improved
 * performance and reliability.
 *
 * Key Features:
 * - Static asset caching for offline access
 * - Network-first strategy for dynamic data
 * - Cache versioning and cleanup
 * - Background synchronization support
 * - Error handling and fallback responses
 * - Cross-origin request filtering
 * - Message handling for service worker updates
 *
 * Caching Strategy:
 * - Static assets (JS, CSS, HTML): Network-first with cache fallback
 * - API endpoints: Network-only (always fresh data)
 * - Dynamic content: Network-first with cache fallback
 *
 * @version 2.1.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Cache configuration
const CACHE_NAME = 'swift-cache-v5';                        // Cache version identifier (increment for updates)
const STATIC_CACHE_URLS = [                                 // Static assets to cache during installation
    '/SWIFT/NEW_SWIFT/',                                    // Main application directory
    '/SWIFT/NEW_SWIFT/js/config.js',                       // Configuration module
    '/SWIFT/NEW_SWIFT/js/dashboard.js',                    // Main dashboard controller
    '/SWIFT/NEW_SWIFT/js/data-service.js',                 // Data service module
    '/SWIFT/NEW_SWIFT/js/weeklyreport.js',                // Weekly report module
    '/SWIFT/NEW_SWIFT/css/style.css'                        // Main stylesheet
];

/**
 * Service Worker Install Event Handler
 * 
 * This event fires when the service worker is first installed or updated.
 * It caches all static assets defined in STATIC_CACHE_URLS to enable offline access.
 * The service worker immediately takes control after installation.
 */
self.addEventListener('install', (event) => {
    console.log('SWIFT Service Worker: Installing...');
    event.waitUntil(
        caches.open(CACHE_NAME)                             // Open the cache with current version name
            .then((cache) => {
                console.log('SWIFT Service Worker: Caching static assets');
                return cache.addAll(STATIC_CACHE_URLS);     // Cache all static assets
            })
            .then(() => {
                console.log('SWIFT Service Worker: Installation complete');
                return self.skipWaiting();                  // Immediately activate new service worker
            })
            .catch((error) => {
                console.error('SWIFT Service Worker: Installation failed', error);
            })
    );
});

/**
 * Service Worker Activate Event Handler
 * 
 * This event fires when the service worker becomes active. It cleans up old cache
 * versions to prevent storage bloat and ensures the new service worker takes control
 * of all clients immediately.
 */
self.addEventListener('activate', (event) => {
    console.log('SWIFT Service Worker: Activating...');
    event.waitUntil(
        caches.keys()                                       // Get all existing cache names
            .then((cacheNames) => {
                return Promise.all(
                    cacheNames.map((cacheName) => {
                        if (cacheName !== CACHE_NAME) {     // Delete old cache versions
                            console.log('SWIFT Service Worker: Deleting old cache', cacheName);
                            return caches.delete(cacheName);
                        }
                    })
                );
            })
            .then(() => {
                console.log('SWIFT Service Worker: Activation complete');
                return self.clients.claim();                // Take control of all clients immediately
            })
    );
});

/**
 * Service Worker Fetch Event Handler
 * 
 * This event intercepts all network requests from the application. It implements
 * different caching strategies based on the request type and URL pattern.
 * 
 * Strategy:
 * - Non-GET requests: Pass through without caching
 * - Cross-origin requests: Pass through without caching
 * - SWIFT application requests: Apply caching strategy
 */
self.addEventListener('fetch', (event) => {
    const request = event.request;
    const url = new URL(request.url);
    
    // Skip non-GET requests (POST, PUT, DELETE, etc.)
    // These should always go to the network for data integrity
    if (request.method !== 'GET') {
        return;
    }
    
    // Skip cross-origin requests to external domains
    // Only handle requests from the same origin for security
    if (url.origin !== location.origin) {
        return;
    }
    
    // Handle SWIFT-specific requests with custom caching strategy
    if (url.pathname.includes('/SWIFT/')) {
        event.respondWith(
            handleSWIFTRequest(request)
        );
    }
});

/**
 * SWIFT Request Handler
 * 
 * Implements the caching strategy for SWIFT application requests:
 * - API/PHP requests: Network-first (always try to get fresh data)
 * - Static assets: Network-first with cache fallback
 * - Error handling: Graceful fallback with error responses
 * 
 * @param {Request} request - The fetch request to handle
 * @returns {Promise<Response>} - The response (network or cached)
 */
async function handleSWIFTRequest(request) {
    try {
        // API and PHP endpoints: Always try network first for fresh data
        // These contain dynamic sensor data and should be as current as possible
        if (request.url.includes('php/') || request.url.includes('api/')) {
            const networkResponse = await fetch(request);
            if (networkResponse.ok) {
                return networkResponse;                     // Return fresh data from network
            }
            throw new Error(`Network request failed: ${networkResponse.status}`);
        }
        
        // Static assets: Network-first with cache update
        // Try to get the latest version from network, update cache, then serve
        const networkResponse = await fetch(request);
        if (networkResponse.ok) {
            const cache = await caches.open(CACHE_NAME);
            cache.put(request, networkResponse.clone());    // Update cache with fresh content
            return networkResponse;                         // Return fresh content
        }
        
        // Fallback to cache if network fails
        // This enables offline functionality for static assets
        const cachedResponse = await caches.match(request);
        if (cachedResponse) {
            return cachedResponse;                          // Return cached content
        }
        
        return networkResponse;                             // Return network response (even if not ok)
        
    } catch (error) {
        console.error('SWIFT Service Worker: Request failed', request.url, error);
        
        // Return a structured error response instead of throwing
        // This prevents the application from crashing and provides useful error information
        return new Response(
            JSON.stringify({
                status: 'error',
                message: 'Network request failed',
                error: error.message
            }),
            {
                status: 503,                                // Service Unavailable
                statusText: 'Service Unavailable',
                headers: {
                    'Content-Type': 'application/json'      // Proper content type for JSON response
                }
            }
        );
    }
}

/**
 * Message Event Handler
 * 
 * Handles messages sent from the main application thread to the service worker.
 * Currently supports the SKIP_WAITING message to force immediate activation
 * of a new service worker version.
 * 
 * @param {MessageEvent} event - The message event from the main thread
 */
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        self.skipWaiting();                                // Force immediate activation
    }
});

/**
 * Background Sync Event Handler
 * 
 * Handles background synchronization when the device comes back online.
 * This is useful for syncing offline data or performing maintenance tasks
 * when connectivity is restored.
 * 
 * @param {SyncEvent} event - The background sync event
 */
self.addEventListener('sync', (event) => {
    if (event.tag === 'background-sync') {
        console.log('SWIFT Service Worker: Background sync triggered');
        event.waitUntil(doBackgroundSync());                // Perform background sync operations
    }
});

/**
 * Background Sync Implementation
 * 
 * Performs background synchronization tasks when the device comes back online.
 * This could include syncing offline sensor data, updating cached content,
 * or performing maintenance operations.
 * 
 * @returns {Promise<void>} - Resolves when sync operations complete
 */
async function doBackgroundSync() {
    try {
        // Perform any background sync operations here
        // Examples:
        // - Sync offline sensor data to server
        // - Update cached static assets
        // - Perform maintenance tasks
        // - Send queued notifications
        
        console.log('SWIFT Service Worker: Background sync completed');
    } catch (error) {
        console.error('SWIFT Service Worker: Background sync failed', error);
    }
}

/**
 * Error Event Handler
 * 
 * Handles general errors that occur in the service worker context.
 * Logs errors for debugging and monitoring purposes.
 * 
 * @param {ErrorEvent} event - The error event
 */
self.addEventListener('error', (event) => {
    console.error('SWIFT Service Worker: Error occurred', event.error);
});

/**
 * Unhandled Promise Rejection Handler
 * 
 * Handles unhandled promise rejections in the service worker context.
 * Prevents the service worker from crashing and logs the error for debugging.
 * 
 * @param {PromiseRejectionEvent} event - The unhandled rejection event
 */
self.addEventListener('unhandledrejection', (event) => {
    console.error('SWIFT Service Worker: Unhandled promise rejection', event.reason);
    event.preventDefault();                                 // Prevent the default behavior
});

// Service worker loaded successfully
console.log('SWIFT Service Worker: Loaded successfully');
