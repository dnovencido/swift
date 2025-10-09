/**
 * SWIFT Service Worker
 * Handles caching and network requests for the SWIFT application
 */

const CACHE_NAME = 'swift-cache-v5';
const STATIC_CACHE_URLS = [
    '/SWIFT/NEW_SWIFT/',
    '/SWIFT/NEW_SWIFT/js/config.js',
    '/SWIFT/NEW_SWIFT/js/dashboard.js',
    '/SWIFT/NEW_SWIFT/js/data-service.js',
    '/SWIFT/NEW_SWIFT/js/weeklyreport.js',
    '/SWIFT/NEW_SWIFT/css/style.css'
];

// Install event - cache static assets
self.addEventListener('install', (event) => {
    console.log('SWIFT Service Worker: Installing...');
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then((cache) => {
                console.log('SWIFT Service Worker: Caching static assets');
                return cache.addAll(STATIC_CACHE_URLS);
            })
            .then(() => {
                console.log('SWIFT Service Worker: Installation complete');
                return self.skipWaiting();
            })
            .catch((error) => {
                console.error('SWIFT Service Worker: Installation failed', error);
            })
    );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
    console.log('SWIFT Service Worker: Activating...');
    event.waitUntil(
        caches.keys()
            .then((cacheNames) => {
                return Promise.all(
                    cacheNames.map((cacheName) => {
                        if (cacheName !== CACHE_NAME) {
                            console.log('SWIFT Service Worker: Deleting old cache', cacheName);
                            return caches.delete(cacheName);
                        }
                    })
                );
            })
            .then(() => {
                console.log('SWIFT Service Worker: Activation complete');
                return self.clients.claim();
            })
    );
});

// Fetch event - handle network requests
self.addEventListener('fetch', (event) => {
    const request = event.request;
    const url = new URL(request.url);
    
    // Skip non-GET requests
    if (request.method !== 'GET') {
        return;
    }
    
    // Skip cross-origin requests
    if (url.origin !== location.origin) {
        return;
    }
    
    // Handle SWIFT-specific requests
    if (url.pathname.includes('/SWIFT/')) {
        event.respondWith(
            handleSWIFTRequest(request)
        );
    }
});

// Handle SWIFT-specific requests with proper error handling
async function handleSWIFTRequest(request) {
    try {
        // Always try network first for dynamic data
        if (request.url.includes('php/') || request.url.includes('api/')) {
            const networkResponse = await fetch(request);
            if (networkResponse.ok) {
                return networkResponse;
            }
            throw new Error(`Network request failed: ${networkResponse.status}`);
        }
        
        // For static assets, always try network first to get latest version
        const networkResponse = await fetch(request);
        if (networkResponse.ok) {
            const cache = await caches.open(CACHE_NAME);
            cache.put(request, networkResponse.clone());
            return networkResponse;
        }
        
        // Fallback to cache if network fails
        const cachedResponse = await caches.match(request);
        if (cachedResponse) {
            return cachedResponse;
        }
        
        return networkResponse;
        
    } catch (error) {
        console.error('SWIFT Service Worker: Request failed', request.url, error);
        
        // Return a basic error response instead of throwing
        return new Response(
            JSON.stringify({
                status: 'error',
                message: 'Network request failed',
                error: error.message
            }),
            {
                status: 503,
                statusText: 'Service Unavailable',
                headers: {
                    'Content-Type': 'application/json'
                }
            }
        );
    }
}

// Handle messages from the main thread
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        self.skipWaiting();
    }
});

// Handle background sync (if supported)
self.addEventListener('sync', (event) => {
    if (event.tag === 'background-sync') {
        console.log('SWIFT Service Worker: Background sync triggered');
        event.waitUntil(doBackgroundSync());
    }
});

async function doBackgroundSync() {
    try {
        // Perform any background sync operations here
        console.log('SWIFT Service Worker: Background sync completed');
    } catch (error) {
        console.error('SWIFT Service Worker: Background sync failed', error);
    }
}

// Error handling
self.addEventListener('error', (event) => {
    console.error('SWIFT Service Worker: Error occurred', event.error);
});

self.addEventListener('unhandledrejection', (event) => {
    console.error('SWIFT Service Worker: Unhandled promise rejection', event.reason);
    event.preventDefault();
});

console.log('SWIFT Service Worker: Loaded successfully');
