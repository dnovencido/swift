class Dashboard {
    constructor() {
        this.sensorData = null;
        this.controlStates = { waterSprinkler: null, heat: null, mode: 'AUTO' };
        this.arduinoIP = (window.SWIFT_CONFIG && window.SWIFT_CONFIG.arduinoIP) ? window.SWIFT_CONFIG.arduinoIP : null;
        this.updateInterval = null;
        this.liveChartsManager = null;
        this.isInitialized = false;
        this.lastHeatmapUpdate = 0;
        this.heatmapUpdateInterval = 1000;
        
        this.controlLock = false;
        this.controlTimeout = null;
        this.scheduleActive = false;
        this.deviceControlMode = 'AUTO';
        this.deviceStatus = [];
        
        this.init();
    }
    init() {
        this.setupEventListeners();
        this.updateGreeting();
        this.loadControlStates();
        this.loadDeviceStatus();
        this.setupHeatmap();
        this.startSensorUpdates();
        this.initializeCharts();
        // this.forceArduinoToAutoMode(); // Disabled due to CORS issues
        this.isInitialized = true;
    }
    setupEventListeners() {
        document.querySelectorAll('.control-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.target.style.transform = 'scale(0.95)';
                e.target.style.opacity = '0.7';
                setTimeout(() => {
                    e.target.style.transform = 'scale(1)';
                    e.target.style.opacity = '';
                }, 150);
                
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
    
    async loadDeviceStatus() {
        try {
            const deviceRes = await fetch('../php/admin_lists.php?type=devices');
            const deviceData = await deviceRes.json();
            this.deviceStatus = deviceData.success ? deviceData.data : [];
            this.displayDeviceStatus();
        } catch (e) {
            console.warn('Failed to load device status:', e);
            this.deviceStatus = [];
            this.displayDeviceStatus();
        }
    }
    
    displayDeviceStatus() {
        const container = document.getElementById('deviceStatusContainer');
        if (!container) return;
        
        if (this.deviceStatus.length === 0) {
            container.innerHTML = `
                <div style="text-align: center; padding: 20px; color: var(--text-secondary);">
                    <i class="fas fa-exclamation-triangle" style="font-size: 24px; margin-bottom: 8px; color: var(--warning);"></i>
                    <p>No devices found</p>
                </div>
            `;
            return;
        }
        
        const getComponentStatus = (status) => {
            if (status === 'active') return '<span style="color: #22c55e; font-weight: 600;">● Active</span>';
            if (status === 'error') return '<span style="color: #f59e0b; font-weight: 600;">● Error</span>';
            return '<span style="color: #ef4444; font-weight: 600;">● Offline</span>';
        };
        
        container.innerHTML = this.deviceStatus.map(device => {
            const getComponentStatus = (status) => {
                if (status === 'active') return { color: 'var(--success)', text: 'Active', icon: 'check' };
                if (status === 'error') return { color: 'var(--warning)', text: 'Error', icon: 'exclamation-triangle' };
                return { color: 'var(--danger)', text: 'Offline', icon: 'times' };
            };
            
            const deviceStatus = device.status === 'up' ? { color: 'var(--success)', text: 'Online', icon: 'check' } : { color: 'var(--danger)', text: 'Offline', icon: 'times' };
            const tempHumidity = getComponentStatus(device.temp_humidity_sensor);
            const ammonia = getComponentStatus(device.ammonia_sensor);
            const thermal = getComponentStatus(device.thermal_camera);
            
            return `
                <div style="margin-bottom: 16px;">
                    <h4 style="margin: 0 0 12px 0; font-size: 16px; font-weight: 600; color: var(--text-primary);">${device.device_name || 'Unknown Device'}</h4>
                    <div class="transfer-cards">
                        <div class="transfer-card">
                            <div class="card-icon" style="background: ${deviceStatus.color}; color: white;"><i class="fas fa-${deviceStatus.icon}"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Device Status</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 16px; font-weight: 600; color: ${deviceStatus.color};">${deviceStatus.text}</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: ${tempHumidity.color}; color: white;"><i class="fas fa-${tempHumidity.icon}"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">DHT22 Sensor</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 16px; font-weight: 600; color: ${tempHumidity.color};">${tempHumidity.text}</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: ${ammonia.color}; color: white;"><i class="fas fa-${ammonia.icon}"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">MQ137 Sensor</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 16px; font-weight: 600; color: ${ammonia.color};">${ammonia.text}</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: ${thermal.color}; color: white;"><i class="fas fa-${thermal.icon}"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">AMG8833 Sensor</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 16px; font-weight: 600; color: ${thermal.color};">${thermal.text}</h2>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }).join('');
    }
    startSensorUpdates() {
        this.updateSensorData();
        
        this.updateInterval = setInterval(() => {
            this.updateSensorData();
        }, 2000);
        
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.updateSensorData();
            }
        });
        
        window.addEventListener('focus', () => {
            this.updateSensorData();
        });
        
        this.startAutoTransfer();
    }
    async updateSensorData() {
        try {
            const arduinoData = await this.getDataFromArduino();
            
            if (arduinoData) {
                this.updateSensorDisplay({
                    temperature: arduinoData.temperature,
                    humidity: arduinoData.humidity,
                    ammonia: arduinoData.ammonia
                });
                
                if (!this.controlLock) {
                    this.updateControlStates(arduinoData);
                }
                
                await this.enforceManualControl(arduinoData);
                
            const now = Date.now();
            if (now - this.lastHeatmapUpdate >= this.heatmapUpdateInterval) {
                this.updateDashboardHeatmap();
                this.lastHeatmapUpdate = now;
            }
                
            } else {
                const timestamp = Date.now();
                const res = await fetch(`../php/get_latest_sensor_data.php?t=${timestamp}`);
                if (!res.ok) throw new Error('fetch failed');
                const d = await res.json();
                
                if (d.status === 'success' && d.data) {
                    const dataTimestamp = new Date(d.data.timestamp);
                    const now = new Date();
                    const diffMinutes = (now - dataTimestamp) / (1000 * 60);
                    
                    if (diffMinutes > 5) {
                        console.log('Database data is stale, attempting to transfer fresh data...');
                        try {
                            await fetch('../php/transfer_to_database.php?run=transfer', { method: 'GET' });
                            console.log('Fresh data transferred successfully');
                        } catch (transferError) {
                            console.log('Failed to transfer fresh data:', transferError.message);
                        }
                    }
                    
                    this.updateSensorDisplay({
                        temperature: d.data.temperature,
                        humidity: d.data.humidity,
                        ammonia: d.data.ammonia
                    });
                }
            }
            
        } catch (e) {
            this.updateSensorDisplay({ temperature: '...', humidity: '...', ammonia: '...' });
            console.log('Failed to fetch sensor data:', e.message);
        }
    }
    
    updateControlStates(arduinoData) {
        if (typeof arduinoData.pump_temp !== 'undefined') {
            const newState = this.normalizeOnOff(arduinoData.pump_temp);
            if (this.controlStates.waterSprinkler !== newState) {
                this.controlStates.waterSprinkler = newState;
                this.updateControlDisplay('waterSprinkler', newState);
            }
        }
        
        if (typeof arduinoData.heat !== 'undefined') {
            const newState = this.normalizeOnOff(arduinoData.heat);
            if (this.controlStates.heat !== newState) {
                this.controlStates.heat = newState;
                this.updateControlDisplay('heat', newState);
            }
        }
        
        if (typeof arduinoData.mode !== 'undefined') {
            const arduinoMode = String(arduinoData.mode);
            const newState = arduinoMode;
            if (this.controlStates.mode !== newState) {
                this.controlStates.mode = newState;
                this.updateControlDisplay('mode', newState);
                this.updateButtonsDisabled(newState);
            }
        }
        
        if (typeof arduinoData.schedule_active !== 'undefined') {
            this.scheduleActive = arduinoData.schedule_active;
        }
        if (typeof arduinoData.device_control_mode !== 'undefined') {
            this.deviceControlMode = arduinoData.device_control_mode;
        }
        
        this.updateModeIndicators();
    }
    
    async forceArduinoToAutoMode() {
        if (this.arduinoIP) {
            try {
                console.log('Attempting to connect to Arduino...');
                
                // Test if Arduino is reachable first
                const testResponse = await fetch(`${this.arduinoIP}/data`, {
                    method: 'GET',
                    mode: 'cors',
                    timeout: 3000
                });
                
                if (testResponse.ok) {
                    console.log('Arduino is reachable, attempting mode switch...');
                    
                    for (let i = 0; i < 3; i++) {
                        const response = await fetch(`${this.arduinoIP}/togglemode`, {
                            method: 'GET',
                            mode: 'cors',
                            timeout: 5000
                        });
                        
                        if (response.ok) {
                            const result = await response.json();
                            console.log('Arduino mode toggle result:', result);
                            
                            const dataResponse = await fetch(`${this.arduinoIP}/data`, {
                                method: 'GET',
                                mode: 'cors',
                                timeout: 3000
                            });
                            
                            if (dataResponse.ok) {
                                const data = await dataResponse.json();
                                if (data.mode === 'AUTO') {
                                    console.log('✅ Successfully switched to AUTO mode');
                                    break;
                                } else {
                                    console.log('⚠️ Still in', data.mode, 'mode, retrying...');
                                    await new Promise(resolve => setTimeout(resolve, 1000));
                                }
                            }
                        }
                    }
                } else {
                    console.log('Arduino not responding, skipping mode switch');
                }
            } catch (error) {
                if (error.name === 'TypeError' && error.message.includes('CORS')) {
                    console.log('Arduino CORS policy blocks direct connection - using database data only');
                } else {
                    console.log('Could not connect to Arduino:', error.message);
                }
            }
        }
    }
    
    async enforceManualControl(sensorData) {
        if (this.arduinoIP && sensorData) {
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
        if (this.arduinoIP) {
            try {
                console.log('🚨 EMERGENCY: Forcing AUTO mode');
                
                for (let i = 0; i < 5; i++) {
                    const response = await fetch(`${this.arduinoIP}/togglemode`, {
                        method: 'GET',
                        timeout: 5000
                    });
                    
                    if (response.ok) {
                        const result = await response.json();
                        console.log('Toggle result:', result);
                        
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
                                await new Promise(resolve => setTimeout(resolve, 1000));
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
        // Wait for Chart.js to be loaded
        setTimeout(() => {
            if (typeof LiveChartsManager !== 'undefined' && !this.liveChartsManager) {
                this.liveChartsManager = new LiveChartsManager();
                
                window.SWIFT_CHARTS = {
                    getManager: () => this.liveChartsManager,
                    updateCharts: () => this.liveChartsManager ? this.liveChartsManager.updateAllCharts() : null,
                    changeFilter: (filter) => this.liveChartsManager ? this.liveChartsManager.changeTimeFilter(filter) : null,
                    emergencyHeatOff: () => this.emergencyHeatOff(),
                    emergencyAutoMode: () => this.emergencyAutoMode()
                };
                
                console.log('Charts initialized by dashboard');
            }
        }, 500); // Wait 500ms for Chart.js to load
    }
    
    async getDataFromArduino() {
        const arduinoIP = (window.SWIFT_CONFIG && window.SWIFT_CONFIG.arduinoIP) ? window.SWIFT_CONFIG.arduinoIP : null;
        
        if (!arduinoIP) {
            console.log('Arduino IP not configured');
            return null;
        }
        
        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 1000); // Reduced timeout
            
            const timestamp = Date.now();
            const response = await fetch(`${arduinoIP}/data?t=${timestamp}`, {
                signal: controller.signal,
                method: 'GET',
                cache: 'no-cache',
                mode: 'cors',
                headers: {
                    'Accept': 'application/json'
                }
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
            
            return {
                temperature: parseFloat(data.temp),
                humidity: parseFloat(data.hum),
                ammonia: parseFloat(data.ammonia),
                pump_temp: data.pump_temp || 'OFF',
                pump_trigger: data.pump_trigger || 'NONE',
                heat: data.heat || 'OFF',
                mode: data.mode || 'Auto',
                device_control_mode: data.device_control_mode || 'AUTO',
                schedule_active: data.schedule_active || false
            };
            
        } catch (error) {
            if (error.name === 'AbortError') {
                console.log('Arduino connection timeout - using database data');
            } else if (error.name === 'TypeError' && error.message.includes('CORS')) {
                console.log('Arduino CORS policy blocks connection - using database data');
            } else {
                console.log('Arduino connection failed:', error.message);
            }
            return null;
        }
    }
    
    async saveDataToServer(data) {
        console.log('Automatic data logging is disabled');
        return;
    }
    
    startAutoTransfer() {
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
        }, 5 * 60 * 1000);
        
        console.log('Automatic data transfer enabled - every 5 minutes');
    }
    
    async transferToDatabase() {
        console.log('Automatic database transfer is disabled');
        return;
    }
    
    updateTransferStatus(message) {
        console.log(message);
        
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
        console.log('Manual control disabled - system uses schedule-based control only');
        alert('Manual control has been disabled. The system now operates automatically based on schedules.\n\nDevices will:\n• Turn ON when scheduled\n• Automatically switch to SCHEDULED mode\n• Turn OFF when schedule duration ends\n• Return to AUTO mode for sensor-based control');
        return;
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
        
        this.updateModeIndicators();
    }
    
    updateModeIndicators() {
        const waterSprinklerMode = document.getElementById('waterSprinklerMode');
        const heatMode = document.getElementById('heatMode');
        
        if (waterSprinklerMode) {
            if (this.deviceControlMode === 'SCHEDULED') {
                waterSprinklerMode.textContent = 'Scheduled Mode';
                waterSprinklerMode.style.color = '#ff9800';
            } else {
                waterSprinklerMode.textContent = 'Auto Mode';
                waterSprinklerMode.style.color = '#666';
            }
        }
        
        if (heatMode) {
            if (this.deviceControlMode === 'SCHEDULED') {
                heatMode.textContent = 'Scheduled Mode';
                heatMode.style.color = '#ff9800';
            } else {
                heatMode.textContent = 'Auto Mode';
                heatMode.style.color = '#666';
            }
        }
    }
    updateButtonsDisabled(modeStr) { 
        document.querySelectorAll('.control-btn').forEach(btn => {
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.title = 'Manual control disabled - system uses schedule-based control only';
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
        this.controlStates.waterSprinkler = null;
        this.controlStates.heat = null;
        this.controlStates.mode = 'AUTO';
        
        Object.keys(this.controlStates).forEach(c => this.updateControlDisplay(c, this.controlStates[c]));
        
        this.updateButtonsDisabled('AUTO');
    }
    setupHeatmap() { 
        this.heatmapCanvas = document.getElementById('heatmapCanvas'); 
        this.heatmapCtx = this.heatmapCanvas ? this.heatmapCanvas.getContext('2d') : null;
        
        if (this.heatmapCanvas) {
            this.heatmapCanvas.width = 400;
            this.heatmapCanvas.height = 400;
        }
    }
    async updateDashboardHeatmap() { 
        if (!this.heatmapCtx) return; 
        
        try {
            const arduinoData = await this.getDataFromArduino();
            
            if (arduinoData && arduinoData.components) {
                if (arduinoData.components.thermal_camera === 'active') {
                    if (arduinoData.thermal && Array.isArray(arduinoData.thermal)) {
                        this.drawInterpolatedHeatmap(arduinoData.thermal);
                    } else {
                        this.drawThermalCameraOffline();
                    }
                } else {
                    this.drawThermalCameraOffline();
                }
            } else {
                const timestamp = Date.now();
                const res = await fetch(`../php/get_latest_sensor_data.php?t=${timestamp}`);
                if (!res.ok) {
                    this.drawThermalCameraOffline();
                    return;
                }
                const d = await res.json();
                
                if (d.status === 'success' && d.data) {
                    if (d.data.components && d.data.components.thermal_camera === 'active') {
                        this.drawThermalCameraOffline();
                    } else {
                        this.drawThermalCameraOffline();
                    }
                } else {
                    this.drawThermalCameraOffline();
                }
            }
            
        } catch (e) {
            console.log('Failed to update thermal map:', e.message);
            this.drawThermalCameraOffline();
        }
    }

    drawThermalCameraOffline() {
        if (!this.heatmapCtx) return;
        
        const w = 400;
        const h = 400;
        
        this.heatmapCtx.clearRect(0, 0, w, h);
        
        const gradient = this.heatmapCtx.createLinearGradient(0, 0, w, h);
        gradient.addColorStop(0, '#2a2a2a');
        gradient.addColorStop(1, '#1a1a1a');
        
        this.heatmapCtx.fillStyle = gradient;
        this.heatmapCtx.fillRect(0, 0, w, h);
        
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
        
        const gradient = this.heatmapCtx.createLinearGradient(0, 0, w, h);
        gradient.addColorStop(0, '#0000ff');
        gradient.addColorStop(0.5, '#00ff00');
        gradient.addColorStop(1, '#ff0000');
        
        this.heatmapCtx.fillStyle = gradient;
        this.heatmapCtx.fillRect(0, 0, w, h);
        
        this.heatmapCtx.fillStyle = 'white';
        this.heatmapCtx.font = '20px Arial';
        this.heatmapCtx.textAlign = 'center';
        this.heatmapCtx.fillText('Thermal Map', w/2, h/2);
        this.heatmapCtx.fillText('(Simulated)', w/2, h/2 + 25);
    }
    drawInterpolatedHeatmap(thermal8x8) { 
        if (!this.heatmapCtx) return; 
        
        const gridSize = 80;
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
        
        this.heatmapCtx.imageSmoothingEnabled = false;
        
        let i=0; 
        for (let y=0; y<gridSize; y++){ 
            for (let x=0; x<gridSize; x++){ 
                const v=values[i++]; 
                const n=(v-min)/(max-min||1); 
                this.heatmapCtx.fillStyle=this.getTriColor(n); 
                this.heatmapCtx.fillRect(x*cw-0.5, y*ch-0.5, cw+1, ch+1); 
            }
        } 
    }
    getTriColor(t){ t=Math.max(0,Math.min(1,t)); if (t<=0.5){ const k=t/0.5; const r=Math.round(255*k), g=Math.round(165*k), b=Math.round(255*(1-k)); return `rgb(${r},${g},${b})`; } const k=(t-0.5)/0.5; return `rgb(255,${Math.round(165*(1-k))},0)`; }
    
    destroy() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
        }
        
        if (this.liveChartsManager) {
            this.liveChartsManager.destroy();
            this.liveChartsManager = null;
        }
        
        console.log('Dashboard destroyed');
    }
    
    logout(){ if (!confirm('Are you sure you want to logout?')) return; fetch('../php/admin_auth.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({action:'logout'})}).finally(()=>{ try{localStorage.removeItem('swift_user');}catch(e){} window.location.href = '../login.html'; }); }
}
let dashboardInstance = null;

document.addEventListener('DOMContentLoaded', () => {
    dashboardInstance = new Dashboard();
    
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

window.addEventListener('beforeunload', () => {
    if (dashboardInstance) {
        dashboardInstance.destroy();
    }
});

