class Dashboard {
    constructor() {
        this.sensorData = null;
        this.controlStates = { waterSprinkler: null, heat: null, mode: 'AUTO' }; // Default mode to AUTO
        this.arduinoIP = (window.SWIFT_CONFIG && window.SWIFT_CONFIG.arduinoIP) ? window.SWIFT_CONFIG.arduinoIP : null;
        this.updateInterval = null;
        this.liveChartsManager = null;
        this.isInitialized = false;
        this.lastHeatmapUpdate = 0;
        this.heatmapUpdateInterval = 1000;
        
        // New simplified control system
        this.controlLock = false;
        this.controlTimeout = null;
        
        this.init();
    }
    init() {
        this.setupEventListeners();
        this.updateGreeting();
        this.loadControlStates();
        this.setupHeatmap();
        this.startSensorUpdates();
        this.initializeCharts();
        this.forceArduinoToAutoMode(); // Force Arduino to AUTO mode on startup
        this.isInitialized = true;
    }
    setupEventListeners() {
        document.querySelectorAll('.control-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                // Add visual feedback
                e.target.style.transform = 'scale(0.95)';
                e.target.style.opacity = '0.7';
                setTimeout(() => {
                    e.target.style.transform = 'scale(1)';
                    e.target.style.opacity = '';
                }, 150);
                
                // Notify continuous data saver about control activity
                document.dispatchEvent(new CustomEvent('controlActivity'));
                
                this.toggleControl(e.target.dataset.control);
            });
        });
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) logoutBtn.addEventListener('click', (e) => { e.preventDefault(); this.logout(); });
    }
    updateGreeting() {
        const hour = new Date().getHours();
        const salutation = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
        let nickname = 'User';
        try { const stored = localStorage.getItem('swift_user'); if (stored) nickname = (JSON.parse(stored).username || nickname); } catch(e) {}
        const el = document.getElementById('greeting'); if (el) el.textContent = `${salutation}, ${nickname}!`;
    }
    startSensorUpdates() {
        // Load data immediately when dashboard becomes visible
        this.updateSensorData();
        
        // Use a single interval for all updates
        this.updateInterval = setInterval(() => {
            this.updateSensorData();
        }, 2000); // Update every 2 seconds for better performance
        
        // Also load data when page becomes visible again
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.updateSensorData();
            }
        });
        
        // Load data when window regains focus
        window.addEventListener('focus', () => {
            this.updateSensorData();
        });
        
        // Start automatic database transfer every 5 minutes
        this.startAutoTransfer();
    }
    async updateSensorData() {
        try {
            // Get live data directly from Arduino device
            const arduinoData = await this.getDataFromArduino();
            
            if (arduinoData) {
                // Use live Arduino data
                this.updateSensorDisplay({
                    temperature: arduinoData.temperature,
                    humidity: arduinoData.humidity,
                    ammonia: arduinoData.ammonia
                });
                
                // Update control states from Arduino (only if not locked)
                if (!this.controlLock) {
                    this.updateControlStates(arduinoData);
                }
                
                // Enforce manual control - prevent Arduino from overriding user commands
                await this.enforceManualControl(arduinoData);
                
                // Update heatmap with live data
            const now = Date.now();
            if (now - this.lastHeatmapUpdate >= this.heatmapUpdateInterval) {
                this.updateDashboardHeatmap();
                this.lastHeatmapUpdate = now;
            }
                
            } else {
                // Fallback to database data if Arduino is not available
                const timestamp = Date.now();
                const res = await fetch(`../php/get_latest_sensor_data.php?t=${timestamp}`);
                if (!res.ok) throw new Error('fetch failed');
                const d = await res.json();
                
                if (d.status === 'success' && d.data) {
                    this.updateSensorDisplay({
                        temperature: d.data.temperature,
                        humidity: d.data.humidity,
                        ammonia: d.data.ammonia
                    });
                }
            }
            
        } catch (e) {
            // Show loading state on error
            this.updateSensorDisplay({ temperature: '...', humidity: '...', ammonia: '...' });
            console.log('Failed to fetch sensor data:', e.message);
        }
    }
    
    updateControlStates(arduinoData) {
        // Update water sprinkler state
        if (typeof arduinoData.pump_temp !== 'undefined') {
            const newState = this.normalizeOnOff(arduinoData.pump_temp);
            if (this.controlStates.waterSprinkler !== newState) {
                this.controlStates.waterSprinkler = newState;
                this.updateControlDisplay('waterSprinkler', newState);
            }
        }
        
        // Update heat state
        if (typeof arduinoData.heat !== 'undefined') {
            const newState = this.normalizeOnOff(arduinoData.heat);
            if (this.controlStates.heat !== newState) {
                this.controlStates.heat = newState;
                this.updateControlDisplay('heat', newState);
            }
        }
        
        // Update mode state - Accept Arduino mode without forcing AUTO
        if (typeof arduinoData.mode !== 'undefined') {
            const arduinoMode = String(arduinoData.mode);
            const newState = arduinoMode;
            if (this.controlStates.mode !== newState) {
                this.controlStates.mode = newState;
                this.updateControlDisplay('mode', newState);
                this.updateButtonsDisabled(newState);
            }
        }
    }
    
    async forceArduinoToAutoMode() {
        // Force Arduino to AUTO mode when dashboard loads
        if (this.arduinoIP) {
            try {
                console.log('Forcing Arduino to AUTO mode...');
                
                // Try multiple times to ensure mode switch works
                for (let i = 0; i < 3; i++) {
                    const response = await fetch(`${this.arduinoIP}/togglemode`, {
                        method: 'GET',
                        timeout: 5000
                    });
                    
                    if (response.ok) {
                        const result = await response.json();
                        console.log('Arduino mode toggle result:', result);
                        
                        // Check if we're in AUTO mode now
                        const dataResponse = await fetch(`${this.arduinoIP}/data`, {
                            method: 'GET',
                            timeout: 3000
                        });
                        
                        if (dataResponse.ok) {
                            const data = await dataResponse.json();
                            if (data.mode === 'AUTO') {
                                console.log('✅ Successfully switched to AUTO mode');
                                break;
                            } else {
                                console.log('⚠️ Still in', data.mode, 'mode, retrying...');
                                await new Promise(resolve => setTimeout(resolve, 1000)); // Wait 1 second
                            }
                        }
                    }
                }
            } catch (error) {
                console.log('Could not force Arduino to AUTO mode:', error.message);
            }
        }
    }
    
    async enforceManualControl(sensorData) {
        // Enforce manual control - prevent Arduino from overriding user commands
        if (this.arduinoIP && sensorData) {
            // If user manually turned heat ON in MANUAL mode, keep it ON
            if (sensorData.mode === 'MANUAL' && this.controlStates.heat === 'ON' && sensorData.heat === 'OFF') {
                try {
                    console.log('🔄 MANUAL CONTROL: Re-enabling heat that Arduino turned OFF');
                    const response = await fetch(`${this.arduinoIP}/setheat?status=ON`, {
                        method: 'GET',
                        timeout: 5000
                    });
                    
                    if (response.ok) {
                        console.log('✅ Manual control: Heat re-enabled');
                    }
                } catch (error) {
                    console.log('Could not re-enable heat:', error.message);
                }
            }
        }
    }
    
    async emergencyHeatOff() {
        // Emergency function to force heat OFF regardless of mode
        if (this.arduinoIP) {
            try {
                console.log('🚨 EMERGENCY: Forcing heat OFF');
                const response = await fetch(`${this.arduinoIP}/setheat?status=OFF`, {
                    method: 'GET',
                    timeout: 5000
                });
                
                if (response.ok) {
                    console.log('✅ Emergency override: Heat turned OFF');
                    this.controlStates.heat = 'OFF';
                    this.updateControlDisplay('heat', 'OFF');
                    alert('Emergency heat override: Heat turned OFF');
                } else {
                    alert('Failed to turn off heat. Please check Arduino connection.');
                }
            } catch (error) {
                console.log('Emergency heat off failed:', error.message);
                alert('Failed to turn off heat. Please check Arduino connection.');
            }
        } else {
            alert('Arduino IP not configured. Cannot control heat.');
        }
    }
    
    async emergencyAutoMode() {
        // Emergency function to force AUTO mode
        if (this.arduinoIP) {
            try {
                console.log('🚨 EMERGENCY: Forcing AUTO mode');
                
                // Try multiple times to ensure mode switch works
                for (let i = 0; i < 5; i++) {
                    const response = await fetch(`${this.arduinoIP}/togglemode`, {
                        method: 'GET',
                        timeout: 5000
                    });
                    
                    if (response.ok) {
                        const result = await response.json();
                        console.log('Toggle result:', result);
                        
                        // Check if we're in AUTO mode now
                        const dataResponse = await fetch(`${this.arduinoIP}/data`, {
                            method: 'GET',
                            timeout: 3000
                        });
                        
                        if (dataResponse.ok) {
                            const data = await dataResponse.json();
                            if (data.mode === 'AUTO') {
                                console.log('✅ Emergency override: Mode switched to AUTO');
                                this.controlStates.mode = 'AUTO';
                                this.updateControlDisplay('mode', 'AUTO');
                                this.updateButtonsDisabled('AUTO');
                                alert('Emergency mode override: Switched to AUTO mode');
                                return;
                            } else {
                                console.log('⚠️ Still in', data.mode, 'mode, retrying...');
                                await new Promise(resolve => setTimeout(resolve, 1000)); // Wait 1 second
                            }
                        }
                    }
                }
                
                alert('Failed to switch to AUTO mode. Arduino may need reprogramming.');
            } catch (error) {
                console.log('Emergency auto mode failed:', error.message);
                alert('Failed to switch to AUTO mode. Please check Arduino connection.');
            }
        } else {
            alert('Arduino IP not configured. Cannot control mode.');
        }
    }
    
    initializeCharts() {
        // Initialize charts manager if it doesn't exist
        if (typeof LiveChartsManager !== 'undefined' && !this.liveChartsManager) {
            this.liveChartsManager = new LiveChartsManager();
            
            // Export for manual access
            window.SWIFT_CHARTS = {
                getManager: () => this.liveChartsManager,
                updateCharts: () => this.liveChartsManager ? this.liveChartsManager.updateAllCharts() : null,
                changeFilter: (filter) => this.liveChartsManager ? this.liveChartsManager.changeTimeFilter(filter) : null,
                emergencyHeatOff: () => this.emergencyHeatOff(),
                emergencyAutoMode: () => this.emergencyAutoMode()
            };
            
            console.log('Charts initialized by dashboard');
        }
    }
    
    async getDataFromArduino() {
        const arduinoIP = (window.SWIFT_CONFIG && window.SWIFT_CONFIG.arduinoIP) ? window.SWIFT_CONFIG.arduinoIP : null;
        
        if (!arduinoIP) {
            console.log('Arduino IP not configured');
            return null;
        }
        
        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 1000); // Reduced to 1 second timeout for faster offline detection
            
            const timestamp = Date.now();
            const response = await fetch(`${arduinoIP}/data?t=${timestamp}`, {
                signal: controller.signal,
                method: 'GET',
                cache: 'no-cache',
                mode: 'cors'
            });
            
            clearTimeout(timeoutId);
            
            if (!response.ok) {
                console.log('Arduino response not OK:', response.status);
                return null;
            }
            
            const data = await response.json();
            
            if (!data || typeof data.temp === 'undefined' || typeof data.hum === 'undefined' || typeof data.ammonia === 'undefined') {
                console.log('Invalid Arduino data format:', data);
                return null;
            }
            
            // Convert Arduino data format to dashboard format
            return {
                temperature: parseFloat(data.temp),
                humidity: parseFloat(data.hum),
                ammonia: parseFloat(data.ammonia),
                pump_temp: data.pump_temp || 'OFF',
                pump_trigger: data.pump_trigger || 'NONE',
                heat: data.heat || 'OFF',
                mode: data.mode || 'Auto'
            };
            
        } catch (error) {
            if (error.name === 'AbortError') {
                console.log('Arduino connection timeout - device may be offline');
            } else {
                console.log('Arduino connection failed:', error.message);
            }
            return null;
        }
    }
    
    async saveDataToServer(data) {
        // LOGGING DISABLED - No automatic data logging
        console.log('Automatic data logging is disabled');
        return;
    }
    
    // Auto-transfer data to database every 5 minutes
    startAutoTransfer() {
        // Enable automatic data transfer to database
        setInterval(async () => {
            try {
                const timestamp = Date.now();
                const response = await fetch(`../php/transfer_to_database.php?run=transfer&t=${timestamp}`);
                if (response.ok) {
                    const result = await response.json();
                    console.log('Auto-transfer completed:', result.message);
                }
            } catch (error) {
                console.log('Auto-transfer failed:', error.message);
            }
        }, 5 * 60 * 1000); // Every 5 minutes
        
        console.log('Automatic data transfer enabled - every 5 minutes');
    }
    
    async transferToDatabase() {
        // TRANSFER DISABLED - No automatic data transfer
        console.log('Automatic database transfer is disabled');
        return;
    }
    
    updateTransferStatus(message) {
        // Update status in console and optionally on screen
        console.log(message);
        
        // You can add a status element to the dashboard if needed
        const statusElement = document.getElementById('transferStatus');
        if (statusElement) {
            statusElement.textContent = message;
        }
    }
    updateSensorDisplay(data) {
        const t = document.getElementById('temperature'); 
        if (t) {
            if (data.temperature != null) {
                const temp = parseFloat(data.temperature);
                t.textContent = `${temp.toFixed(1)}°C`;
            } else {
                t.textContent = '--';
            }
        }
        
        const h = document.getElementById('humidity'); 
        if (h) {
            if (data.humidity != null) {
                const hum = parseFloat(data.humidity);
                h.textContent = `${hum.toFixed(1)}%`;
            } else {
                h.textContent = '--';
            }
        }
        
        const a = document.getElementById('ammonia'); 
        if (a) {
            if (data.ammonia != null) {
                const amm = parseFloat(data.ammonia);
                a.textContent = `${amm.toFixed(1)}ppm`;
            } else {
                a.textContent = '--';
            }
        }
    }
    async toggleControl(control) {
        console.log('toggleControl called with:', control);
        
        // Check if we're in AUTO mode and trying to control heat/pump
        if (this.controlStates.mode === 'AUTO' && (control === 'heat' || control === 'waterSprinkler')) {
            alert('Heat and Pump controls are only available in MANUAL mode. Please switch to MANUAL mode first.');
            return;
        }
        
        // Prevent multiple simultaneous control updates
        if (this.controlLock) {
            console.log('Control update already in progress, skipping');
            return;
        }
        this.controlLock = true;
        
        console.log('Starting control update for:', control);
        
        // Store the current state before toggling
        const currentState = this.controlStates[control];
        
        // Temporarily pause continuous data saver to prioritize control request
        if (window.swiftDataSaver || window.continuousDataSaver) {
            const dataSaver = window.swiftDataSaver || window.continuousDataSaver;
            if (dataSaver.stopService) {
                dataSaver.stopService();
            }
        }
        
        try {
            if (this.arduinoIP) {
                const timestamp = Date.now();
                let url;
                if (control === 'waterSprinkler') {
                    url = `${this.arduinoIP.replace(/\/$/, '')}/togglepump?t=${timestamp}`;
                } else if (control === 'heat') {
                    url = `${this.arduinoIP.replace(/\/$/, '')}/toggleheat?t=${timestamp}`;
                } else if (control === 'mode') {
                    url = `${this.arduinoIP.replace(/\/$/, '')}/togglemode?t=${timestamp}`;
                } else {
                    url = `${this.arduinoIP.replace(/\/$/, '')}/toggle${control}?t=${timestamp}`;
                }
                console.log('Sending control request to:', url);
                
                // Use AbortController for timeout and priority
                const controller = new AbortController();
                const timeoutId = setTimeout(() => controller.abort(), 5000); // 5 second timeout for controls
                
                const response = await fetch(url, { 
                    method: 'GET',
                    signal: controller.signal,
                    cache: 'no-cache'
                });
                
                clearTimeout(timeoutId);
                console.log('Control response received:', response.status);
                
                if (response.ok) {
                    const result = await response.json();
                    
                    // Update control states based on Arduino response
                    if (result.status === 'success') {
                        if (control === 'waterSprinkler' && (result.pump || result.waterSprinkler)) {
                            this.controlStates[control] = this.normalizeOnOff(result.pump || result.waterSprinkler);
                        } else if (control === 'heat' && result.heat) {
                            this.controlStates[control] = this.normalizeOnOff(result.heat);
                        } else if (control === 'mode' && result.mode) {
                            this.controlStates[control] = result.mode;
                        }
                        
                        this.updateControlDisplay(control, this.controlStates[control]);
                        this.updateButtonsDisabled(String(this.controlStates.mode));
                        
                        // Show success feedback
                        this.showControlFeedback(control, 'success');
                        console.log('Control updated successfully:', control, '=', this.controlStates[control]);
                    } else {
                        throw new Error('Control command failed');
                    }
                } else {
                    // Handle specific error responses
                    if (response.status === 403) {
                        const errorResult = await response.json();
                        throw new Error(errorResult.message || 'Control not available in current mode');
                    } else if (response.status === 404) {
                        throw new Error('Device endpoint not found - check device connection');
                    } else {
                        throw new Error(`Device command failed (${response.status})`);
                    }
                }
            } else {
                const timestamp = Date.now();
                const res = await fetch(`../php/api/v1/controls.php?t=${timestamp}`, { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ control }),
                    cache: 'no-cache'
                });
                if (!res.ok) throw new Error('toggle failed');
                const r = await res.json(); 
                this.controlStates[control] = r.state; 
                this.updateControlDisplay(control, r.state);
                this.showControlFeedback(control, 'success');
            }
        } catch (e) { 
            // Revert to original state on error
            this.controlStates[control] = currentState;
            this.updateControlDisplay(control, currentState);
            this.updateButtonsDisabled(String(this.controlStates.mode));
            this.showControlFeedback(control, 'error', e.message);
        } finally {
            this.controlLock = false;
            
            // Resume continuous data saver after control operation
            setTimeout(() => {
                if (window.swiftDataSaver || window.continuousDataSaver) {
                    const dataSaver = window.swiftDataSaver || window.continuousDataSaver;
                    if (dataSaver.startService) {
                        dataSaver.startService();
                    }
                }
            }, 1000); // Resume after 1 second
        }
    }
    updateControlDisplay(control, state) {
        const el = document.getElementById(`${control}Status`); if (!el) return;
        if (state == null) { el.textContent = '--'; el.style.color = '#999999'; return; }
        if (control === 'mode') {
            const label = (String(state).toLowerCase() === 'manual' || String(state).toLowerCase() === 'auto') ? String(state) : (state ? 'ON' : 'OFF');
            el.textContent = label; el.style.color = (String(label).toLowerCase() === 'auto' || label === 'ON') ? '#4CAF50' : '#f44336';
        } else {
            const v = typeof state === 'string' ? this.normalizeOnOff(state) : !!state; el.textContent = v ? 'ON' : 'OFF'; el.style.color = v ? '#4CAF50' : '#f44336';
        }
    }
    updateButtonsDisabled(modeStr) { 
        const isAuto = String(modeStr).toLowerCase() === 'auto'; 
        document.querySelectorAll('.control-btn').forEach(btn => {
            // Only disable water sprinkler and heat buttons in auto mode, keep mode button enabled
            if (btn.dataset.control === 'mode') {
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.title = 'Switch between Auto and Manual mode';
            } else {
                btn.disabled = isAuto;
                if (isAuto) {
                    btn.style.opacity = '0.5';
                    btn.title = 'Disabled in Auto mode - switch to Manual mode to control';
                } else {
                    btn.style.opacity = '1';
                    btn.title = 'Click to toggle';
                }
            }
        }); 
    }
    
    showControlFeedback(control, type, message = '') {
        const button = document.querySelector(`[data-control="${control}"]`);
        if (!button) return;
        
        const originalText = button.textContent;
        
        if (type === 'success') {
            button.style.background = '#4CAF50';
            button.style.color = 'white';
            button.textContent = '✓ Done';
            
            setTimeout(() => {
                button.style.background = '';
                button.style.color = '';
                button.textContent = originalText;
            }, 1500);
        } else if (type === 'error') {
            button.style.background = '#f44336';
            button.style.color = 'white';
            button.textContent = '✗ Error';
            
            setTimeout(() => {
                button.style.background = '';
                button.style.color = '';
                button.textContent = originalText;
                button.disabled = false;
            }, 2000);
            
            console.error(`Control ${control} failed:`, message);
        }
    }
    saveToStorage(p) { try { localStorage.setItem('swift_latest_payload', JSON.stringify(p)); } catch(e) {} }
    renderFromStorage() { try { const raw = localStorage.getItem('swift_latest_payload'); if (!raw) return; const p = JSON.parse(raw); this.updateSensorDisplay({ temperature: p.temperature ?? null, humidity: p.humidity ?? null, ammonia: p.ammonia ?? null }); ['waterSprinkler','heat','mode'].forEach(k=> this.updateControlDisplay(k, p[k] ?? null)); if (typeof p.mode !== 'undefined') this.updateButtonsDisabled(String(p.mode)); } catch(e) {} }
    normalizeOnOff(value) { const s = String(value).toLowerCase(); if (s==='on'||s==='1'||s==='true') return true; if (s==='off'||s==='0'||s==='false') return false; return null; }
    loadControlStates() { 
        // Set default control states
        this.controlStates.waterSprinkler = null;
        this.controlStates.heat = null;
        this.controlStates.mode = 'AUTO'; // Default mode to AUTO
        
        // Update display for each control
        Object.keys(this.controlStates).forEach(c => this.updateControlDisplay(c, this.controlStates[c]));
        
        // Update button states based on default mode
        this.updateButtonsDisabled('AUTO');
    }
    setupHeatmap() { 
        this.heatmapCanvas = document.getElementById('heatmapCanvas'); 
        this.heatmapCtx = this.heatmapCanvas ? this.heatmapCanvas.getContext('2d') : null;
        
        // Set canvas size for high resolution
        if (this.heatmapCanvas) {
            this.heatmapCanvas.width = 400;
            this.heatmapCanvas.height = 400;
        }
    }
    async updateDashboardHeatmap() { 
        if (!this.heatmapCtx) return; 
        
        // Check thermal camera status before showing thermal map
        try {
            // Get live data directly from Arduino device
            const arduinoData = await this.getDataFromArduino();
            
            if (arduinoData && arduinoData.components) {
                // Check if thermal camera is active
                if (arduinoData.components.thermal_camera === 'active') {
                    // Thermal camera is working - show real thermal data
                    if (arduinoData.thermal && Array.isArray(arduinoData.thermal)) {
                        this.drawInterpolatedHeatmap(arduinoData.thermal);
                    } else {
                        // No thermal data available, show offline message
                        this.drawThermalCameraOffline();
                    }
                } else {
                    // Thermal camera is offline - show offline message
                    this.drawThermalCameraOffline();
                }
            } else {
                // Fallback to database data if Arduino is not available
                const timestamp = Date.now();
                const res = await fetch(`../php/get_latest_sensor_data.php?t=${timestamp}`);
                if (!res.ok) {
                    this.drawThermalCameraOffline();
                    return;
                }
                const d = await res.json();
                
                if (d.status === 'success' && d.data) {
                    // Check thermal camera status from database
                    if (d.data.components && d.data.components.thermal_camera === 'active') {
                        // Thermal camera is active but no thermal data - show offline
                        this.drawThermalCameraOffline();
                    } else {
                        // Thermal camera is offline - show offline message
                        this.drawThermalCameraOffline();
                    }
                } else {
                    this.drawThermalCameraOffline();
                }
            }
            
        } catch (e) {
            console.log('Failed to update thermal map:', e.message);
            // Show offline message if data fetch fails
            this.drawThermalCameraOffline();
        }
    }
    
    
    drawThermalCameraOffline() {
        if (!this.heatmapCtx) return;
        
        const w = 400;
        const h = 400;
        
        // Clear canvas
        this.heatmapCtx.clearRect(0, 0, w, h);
        
        // Create a dark background to indicate offline status
        const gradient = this.heatmapCtx.createLinearGradient(0, 0, w, h);
        gradient.addColorStop(0, '#2a2a2a');
        gradient.addColorStop(1, '#1a1a1a');
        
        this.heatmapCtx.fillStyle = gradient;
        this.heatmapCtx.fillRect(0, 0, w, h);
        
        // Add offline message
        this.heatmapCtx.fillStyle = '#ff6b6b';
        this.heatmapCtx.font = 'bold 24px Arial';
        this.heatmapCtx.textAlign = 'center';
        this.heatmapCtx.fillText('Thermal Camera', w/2, h/2 - 20);
        
        this.heatmapCtx.fillStyle = '#cccccc';
        this.heatmapCtx.font = '18px Arial';
        this.heatmapCtx.fillText('OFFLINE', w/2, h/2 + 10);
        
        this.heatmapCtx.fillStyle = '#888888';
        this.heatmapCtx.font = '14px Arial';
        this.heatmapCtx.fillText('Camera not responding', w/2, h/2 + 35);
    }
    
    drawDefaultThermalMap() {
        if (!this.heatmapCtx) return;
        
        const w = 400;
        const h = 400;
        
        this.heatmapCtx.clearRect(0, 0, w, h);
        
        // Draw a simple gradient pattern
        const gradient = this.heatmapCtx.createLinearGradient(0, 0, w, h);
        gradient.addColorStop(0, '#0000ff'); // Blue (cool)
        gradient.addColorStop(0.5, '#00ff00'); // Green (medium)
        gradient.addColorStop(1, '#ff0000'); // Red (hot)
        
        this.heatmapCtx.fillStyle = gradient;
        this.heatmapCtx.fillRect(0, 0, w, h);
        
        // Add text overlay
        this.heatmapCtx.fillStyle = 'white';
        this.heatmapCtx.font = '20px Arial';
        this.heatmapCtx.textAlign = 'center';
        this.heatmapCtx.fillText('Thermal Map', w/2, h/2);
        this.heatmapCtx.fillText('(Simulated)', w/2, h/2 + 25);
    }
    drawInterpolatedHeatmap(thermal8x8) { 
        if (!this.heatmapCtx) return; 
        
        // High resolution for crisp thermal map
        const gridSize = 80; // Higher resolution for 400x400 canvas
        const w = 400;
        const h = 400;
        const cw = w / gridSize; 
        const ch = h / gridSize; 
        
        const values = []; 
        for (let y=0; y<gridSize; y++){ 
            for (let x=0; x<gridSize; x++){ 
                const gx = x*7/(gridSize-1), gy = y*7/(gridSize-1); 
                const x0=Math.floor(gx), x1=Math.min(x0+1,7), y0=Math.floor(gy), y1=Math.min(y0+1,7); 
                const dx=gx-x0, dy=gy-y0; 
                const c00=thermal8x8[y0*8+x0], c10=thermal8x8[y0*8+x1]; 
                const c01=thermal8x8[y1*8+x0], c11=thermal8x8[y1*8+x1]; 
                const c0=c00*(1-dx)+c10*dx; 
                const c1=c01*(1-dx)+c11*dx; 
                values.push(c0*(1-dy)+c1*dy); 
            }
        } 
        
        const min=Math.min(...values), max=Math.max(...values); 
        this.heatmapCtx.clearRect(0,0,w,h); 
        
        // Disable anti-aliasing for crisp pixel edges
        this.heatmapCtx.imageSmoothingEnabled = false;
        
        let i=0; 
        for (let y=0; y<gridSize; y++){ 
            for (let x=0; x<gridSize; x++){ 
                const v=values[i++]; 
                const n=(v-min)/(max-min||1); 
                this.heatmapCtx.fillStyle=this.getTriColor(n); 
                // Draw slightly overlapping rectangles to remove grid lines
                this.heatmapCtx.fillRect(x*cw-0.5, y*ch-0.5, cw+1, ch+1); 
            }
        } 
    }
    getTriColor(t){ t=Math.max(0,Math.min(1,t)); if (t<=0.5){ const k=t/0.5; const r=Math.round(255*k), g=Math.round(165*k), b=Math.round(255*(1-k)); return `rgb(${r},${g},${b})`; } const k=(t-0.5)/0.5; return `rgb(255,${Math.round(165*(1-k))},0)`; }
    
    destroy() {
        // Clean up intervals
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
        }
        
        // Clean up charts
        if (this.liveChartsManager) {
            this.liveChartsManager.destroy();
            this.liveChartsManager = null;
        }
        
        console.log('Dashboard destroyed');
    }
    
    logout(){ if (!confirm('Are you sure you want to logout?')) return; fetch('../php/admin_auth.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({action:'logout'})}).finally(()=>{ try{localStorage.removeItem('swift_user');}catch(e){} window.location.href = '../admin/login.html'; }); }
}
let dashboardInstance = null;

document.addEventListener('DOMContentLoaded', () => {
    dashboardInstance = new Dashboard();
    
    // Store globally for cleanup
    window.SWIFT_DASHBOARD = {
        getInstance: () => dashboardInstance,
        destroy: () => {
            if (dashboardInstance) {
                dashboardInstance.destroy();
                dashboardInstance = null;
            }
        }
    };
});

// Cleanup when page unloads
window.addEventListener('beforeunload', () => {
    if (dashboardInstance) {
        dashboardInstance.destroy();
    }
});


