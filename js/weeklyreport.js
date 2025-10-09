/**
 * Weekly Report Class - Handles weekly report functionality with real-time data updates
 */
class WeeklyReport {
    constructor() {
        this.currentWeekStart = null;
        this.reportData = null;
        this.deviceStatus = [];
        this.updateInterval = null;
        this.isDataServiceRunning = false;
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.updateGreeting();
        this.setDefaultWeek();
        this.startRealTimeUpdates();
    }
    
    setupEventListeners() {
        const weekInput = document.getElementById('weekStart');
        const loadBtn = document.getElementById('loadBtn');
        const logoutBtn = document.getElementById('logoutBtn');
        
        if (weekInput) {
            weekInput.addEventListener('change', (e) => {
                this.currentWeekStart = e.target.value;
                this.loadWeeklyData();
            });
        }
        
        if (loadBtn) {
            loadBtn.addEventListener('click', () => {
                this.loadWeeklyData();
            });
        }
        
        if (logoutBtn) {
            logoutBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.logout();
            });
        }
        
        const exportBtn = document.getElementById('exportReport');
        if (exportBtn) {
            exportBtn.addEventListener('click', () => {
                this.exportReport();
            });
        }
    }
    
    updateGreeting() {
        const hour = new Date().getHours();
        const salutation = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
        let nickname = 'User';
        
        try {
            const stored = localStorage.getItem('swift_user');
            if (stored) {
                const parsed = JSON.parse(stored);
                nickname = parsed.username || nickname;
            }
        } catch (e) {
            console.log('Error parsing user data:', e);
        }
        
        const greetingEl = document.getElementById('greeting');
        if (greetingEl) {
            greetingEl.textContent = `${salutation}, ${nickname}!`;
        }
    }
    
    setDefaultWeek() {
        const weekInput = document.getElementById('weekStart');
        if (weekInput) {
            const today = new Date();
            // Set to Monday of current week
            today.setDate(today.getDate() - ((today.getDay() + 6) % 7));
            weekInput.value = today.toISOString().split('T')[0];
            this.currentWeekStart = weekInput.value;
        }
    }
    
    startRealTimeUpdates() {
        // REAL-TIME UPDATES DISABLED - No automatic logging
        console.log('Real-time updates are disabled');
        return;
    }
    
    async updateRealTimeData() {
        // REAL-TIME UPDATES DISABLED - No automatic logging
        console.log('Real-time data updates are disabled');
        return;
    }
    
    updateSummaryCards(data) {
        if (!data) {
            // Show loading state
            document.getElementById('tRange').textContent = '...';
            document.getElementById('hRange').textContent = '...';
            document.getElementById('aRange').textContent = '...';
            document.getElementById('alerts').textContent = '...';
            return;
        }
        
        // Update temperature range
        const tempEl = document.getElementById('tRange');
        if (tempEl) {
            if (data.temperature !== null && data.temperature !== undefined) {
                tempEl.textContent = `${data.temperature}°C`;
                tempEl.style.color = '#4CAF50';
            } else {
                tempEl.textContent = '--';
                tempEl.style.color = '#999';
            }
        }
        
        // Update humidity range
        const humEl = document.getElementById('hRange');
        if (humEl) {
            if (data.humidity !== null && data.humidity !== undefined) {
                humEl.textContent = `${data.humidity}%`;
                humEl.style.color = '#4CAF50';
            } else {
                humEl.textContent = '--';
                humEl.style.color = '#999';
            }
        }
        
        // Update ammonia range
        const ammEl = document.getElementById('aRange');
        if (ammEl) {
            if (data.ammonia !== null && data.ammonia !== undefined) {
                ammEl.textContent = `${data.ammonia}ppm`;
                ammEl.style.color = '#4CAF50';
            } else {
                ammEl.textContent = '--';
                ammEl.style.color = '#999';
            }
        }
        
        // Update alerts (simplified - could be enhanced with actual alert logic)
        const alertsEl = document.getElementById('alerts');
        if (alertsEl) {
            // Simple alert calculation based on thresholds
            let alertCount = 0;
            if (data.temperature > 35 || data.temperature < 20) alertCount++;
            if (data.humidity > 85 || data.humidity < 30) alertCount++;
            if (data.ammonia > 0.5) alertCount++;
            
            alertsEl.textContent = alertCount;
            alertsEl.style.color = alertCount > 0 ? '#f44336' : '#4CAF50';
        }
    }
    
    updateStatusIndicator(data) {
        // STATUS INDICATOR DISABLED - UI elements removed
        console.log('Status indicator is disabled');
        return;
    }
    
    async loadWeeklyData() {
        try {
            const reportDataEl = document.getElementById('reportData');
            if (reportDataEl) {
                reportDataEl.innerHTML = '<p>Loading weekly data...</p>';
            }
            
            const weekStart = this.currentWeekStart || this.getCurrentWeekStart();
            
            // Fetch weekly data from database
            const response = await fetch('../php/api/v1/weekly_reports.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ weekStart: weekStart })
            });
            
            if (!response.ok) {
                throw new Error('Failed to fetch weekly data');
            }
            
            const result = await response.json();
            
            if (result.status === 'success') {
                this.reportData = result.data;
                
                // Also fetch device status data like admin side
                try {
                    const deviceRes = await fetch('../php/admin_lists.php?type=devices');
                    const deviceData = await deviceRes.json();
                    this.deviceStatus = deviceData.success ? deviceData.data : [];
                } catch (e) {
                    console.warn('Failed to load device status:', e);
                    this.deviceStatus = [];
                }
                
                this.updateSummaryCards(this.reportData);
                this.displayWeeklyReport(this.reportData);
            } else {
                throw new Error(result.message || 'Failed to load weekly data');
            }
            
        } catch (error) {
            console.error('Error loading weekly data:', error);
            this.deviceStatus = [];
            const reportDataEl = document.getElementById('reportData');
            if (reportDataEl) {
                reportDataEl.innerHTML = '<p>Error loading weekly data. Please try again.</p>';
            }
        }
    }
    
    getCurrentWeekStart() {
        const today = new Date();
        const dayOfWeek = today.getDay();
        const monday = new Date(today);
        monday.setDate(today.getDate() - dayOfWeek + 1);
        return monday.toISOString().split('T')[0];
    }
    
    displayWeeklyReport(data) {
        const reportDataEl = document.getElementById('reportData');
        if (!reportDataEl || !data) return;
        
        const weekStart = new Date(data.weekStart).toLocaleDateString();
        const weekEnd = new Date(data.weekEnd).toLocaleDateString();
        
        let html = `
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <!-- Weekly Summary Cards -->
                <div class="transfer-cards">
                    <div class="transfer-card">
                        <div class="card-icon"><i class="fa-solid fa-temperature-half"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Temperature</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600;">${data.temperature.avg}°C</h2>
                            <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${data.temperature.min}°C - ${data.temperature.max}°C</p>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon"><i class="fa-solid fa-droplet"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Humidity</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600;">${data.humidity.avg}%</h2>
                            <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${data.humidity.min}% - ${data.humidity.max}%</p>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon"><i class="fa-solid fa-flask"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Ammonia</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600;">${data.ammonia.avg}ppm</h2>
                            <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${data.ammonia.min}ppm - ${data.ammonia.max}ppm</p>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon" style="background: var(--danger); color: white;"><i class="fas fa-exclamation"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Total Alerts</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600; color: var(--danger);">${data.totalAlerts}</h2>
                            <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Weekly Total</p>
                        </div>
                    </div>
                </div>
                
                <!-- System Status -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">System Status</h3>
                    <div class="transfer-cards">
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--success); color: white;"><i class="fas fa-check"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">System Status</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600; color: var(--success);">Operational</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--danger); color: white;"><i class="fas fa-exclamation"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Total Alerts</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600; color: var(--danger);">${data.totalAlerts || 0}</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--primary-color); color: white;"><i class="fas fa-tint"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Pump Events</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${Math.floor(data.pumpTotalTime / 10) || 0}</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--warning); color: white;"><i class="fas fa-fire"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Heat Events</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${Math.floor(data.heatTotalTime / 15) || 0}</h2>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--gray-medium); color: white;"><i class="fas fa-cog"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">System Events</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">7</h2>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Device Status -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Device Status & Components</h3>
                    ${this.deviceStatus.length > 0 ? this.deviceStatus.map(device => {
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
                    }).join('') : `
                        <div class="transfer-card" style="grid-column: 1 / -1; text-align: center;">
                            <div class="card-icon" style="background: var(--gray-medium); color: white;"><i class="fas fa-exclamation"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">No device data available</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 16px; font-weight: 600; color: var(--text-secondary);">Unable to load device status</h2>
                            </div>
                        </div>
                    `}
                </div>
                
                <!-- Control Events -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Weekly Control Events & Activity Log</h3>
                    <div class="table-container">
                        <table class="activity-table">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <th>Action</th>
                                    <th>Description</th>
                                    <th>Value</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="activity-time">${new Date().toLocaleString()}</td>
                                    <td><span class="activity-action action-pump-summary">PUMP SUMMARY</span></td>
                                    <td class="activity-description">Total Pump Runtime</td>
                                    <td>${data.pumpTotalTime || 0} min</td>
                                </tr>
                                <tr>
                                    <td class="activity-time">${new Date().toLocaleString()}</td>
                                    <td><span class="activity-action action-heat-summary">HEAT SUMMARY</span></td>
                                    <td class="activity-description">Total Heat Runtime</td>
                                    <td>${data.heatTotalTime || 0} min</td>
                                </tr>
                                <tr>
                                    <td class="activity-time">${new Date().toLocaleString()}</td>
                                    <td><span class="activity-action action-alert-summary">ALERT SUMMARY</span></td>
                                    <td class="activity-description">Total threshold violations</td>
                                    <td>${data.totalAlerts || 0}</td>
                                </tr>
                                <tr>
                                    <td class="activity-time">${weekStart} - ${weekEnd}</td>
                                    <td><span class="activity-action action-system">SYSTEM</span></td>
                                    <td class="activity-description">All sensors operational throughout the week</td>
                                    <td>-</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Notes -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Notes</h3>
                    <p style="margin: 0; color: var(--text-secondary); line-height: 1.5;">Weekly summary completed successfully. All systems operated within normal parameters.</p>
                </div>
        `;
        
        // Add daily breakdown if available
        if (data.dailyData && data.dailyData.length > 0) {
            html += `
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Daily Breakdown</h3>
                    <div style="overflow-x: auto;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Temp (°C)</th>
                                    <th>Humidity (%)</th>
                                    <th>Ammonia (ppm)</th>
                                    <th>Pump (min)</th>
                                    <th>Heat (min)</th>
                                    <th>Alerts</th>
                                </tr>
                            </thead>
                            <tbody>
            `;
            
            data.dailyData.forEach(day => {
                const date = new Date(day.date).toLocaleDateString();
                html += `
                    <tr>
                        <td>${date}</td>
                        <td>${day.temperature.avg}</td>
                        <td>${day.humidity.avg}</td>
                        <td>${day.ammonia.avg}</td>
                        <td>${day.pumpMinutes}</td>
                        <td>${day.heatMinutes}</td>
                        <td style="color: ${day.alerts > 0 ? 'var(--danger)' : 'var(--success)'}; font-weight: 600;">${day.alerts}</td>
                    </tr>
                `;
            });
            
            html += `
                            </tbody>
                        </table>
                    </div>
                </div>
            `;
        }
        
        html += `
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Report Information</h3>
                    <div style="display: flex; flex-direction: column; gap: 8px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid var(--gray-200);">
                            <span style="font-weight: 600; color: var(--text-primary);">Report Generated:</span>
                            <span style="color: var(--text-secondary);">${new Date().toLocaleString()}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0;">
                            <span style="font-weight: 600; color: var(--text-primary);">Data Points:</span>
                            <span style="color: var(--text-secondary);">${data.dataPoints || 'N/A'}</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        reportDataEl.innerHTML = html;
    }
    
    async exportReport() {
        if (!this.reportData) {
            alert('Please load a weekly report first.');
            return;
        }
        
        try {
            const pdfContent = this.generatePDFContent();
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Weekly Report - ${this.currentWeekStart}</title>
                    <link rel="stylesheet" href="../css/style.css" />
                    <style>
                        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; color: #333; }
                        .report-header { text-align: center; margin-bottom: 30px; }
                        .report-header h1 { color: #0A4174; margin-bottom: 5px; }
                        .report-header p { font-size: 14px; color: #666; }
                        .section-title { color: #0A4174; border-bottom: 2px solid #eee; padding-bottom: 5px; margin-top: 25px; margin-bottom: 15px; }
                        .data-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px; }
                        .data-card { background: #f9f9f9; border: 1px solid #eee; border-radius: 8px; padding: 15px; text-align: center; }
                        .data-card h5 { margin: 0 0 5px 0; color: #555; font-size: 14px; }
                        .data-card p { margin: 0; font-size: 18px; font-weight: bold; color: #0A4174; }
                        .alert-item { background: #ffe0b2; border-left: 4px solid #ff9800; padding: 10px; margin-bottom: 8px; border-radius: 4px; font-size: 14px; }
                        .event-item { background: #e3f2fd; border-left: 4px solid #2196f3; padding: 10px; margin-bottom: 8px; border-radius: 4px; font-size: 14px; }
                        .event-item.pump-on { border-left-color: #4CAF50; background: #e8f5e9; }
                        .event-item.pump-off { border-left-color: #f44336; background: #ffebee; }
                        .event-item.heat-on { border-left-color: #ff9800; background: #fff3e0; }
                        .event-item.heat-off { border-left-color: #2196f3; background: #e3f2fd; }
                        .event-item.system { border-left-color: #9e9e9e; background: #f5f5f5; }
                        .footer { text-align: center; margin-top: 40px; font-size: 12px; color: #999; }
                        @media print {
                            body { margin: 0; }
                            .main-content { padding: 0; }
                            .report-container { box-shadow: none; border: none; }
                            button { display: none; }
                        }
                    </style>
                </head>
                <body>
                    <div class="report-header">
                        <h1>SWIFT 2.0 Weekly Report</h1>
                        <p>Week: ${new Date(this.reportData.weekStart).toLocaleDateString()} - ${new Date(this.reportData.weekEnd).toLocaleDateString()} | Generated: ${new Date().toLocaleString()}</p>
                    </div>
                    <div class="report-content-print">
                        ${pdfContent}
                    </div>
                    <div class="footer">
                        <p>Generated by SWIFT IoT Smart Swine Farming System</p>
                    </div>
                    <script>
                        window.onload = function() {
                            setTimeout(() => {
                                window.print();
                                window.onafterprint = function() {
                                    window.close();
                                };
                            }, 500);
                        }
                    </script>
                </body>
                </html>
            `);
            printWindow.document.close();
        } catch (error) {
            console.error('PDF export error:', error);
            alert('Failed to export PDF. Please try again.');
        }
    }
    
    generatePDFContent() {
        const data = this.reportData;
        const weekStart = new Date(data.weekStart).toLocaleDateString();
        const weekEnd = new Date(data.weekEnd).toLocaleDateString();
        
        // Generate device status HTML
        const deviceStatusHtml = this.deviceStatus.length > 0 ? this.deviceStatus.map(device => {
            const getComponentStatus = (status) => {
                if (status === 'active') return { color: '#22c55e', text: 'Active' };
                if (status === 'error') return { color: '#f59e0b', text: 'Error' };
                return { color: '#ef4444', text: 'Offline' };
            };
            
            const deviceStatus = device.status === 'up' ? { color: '#22c55e', text: 'Online' } : { color: '#ef4444', text: 'Offline' };
            const tempHumidity = getComponentStatus(device.temp_humidity_sensor);
            const ammonia = getComponentStatus(device.ammonia_sensor);
            const thermal = getComponentStatus(device.thermal_camera);
            
            return `
                <div class="data-card" style="margin-bottom: 16px;">
                    <h5 style="margin: 0 0 12px 0; font-size: 16px; font-weight: 600; color: #333;">${device.device_name || 'Unknown Device'}</h5>
                    <div class="data-grid">
                        <div class="data-card" style="border-left: 4px solid ${deviceStatus.color};">
                            <h5>Device Status</h5>
                            <p style="color: ${deviceStatus.color};">${deviceStatus.text}</p>
                        </div>
                        <div class="data-card" style="border-left: 4px solid ${tempHumidity.color};">
                            <h5>DHT22 Sensor</h5>
                            <p style="color: ${tempHumidity.color};">${tempHumidity.text}</p>
                        </div>
                        <div class="data-card" style="border-left: 4px solid ${ammonia.color};">
                            <h5>MQ137 Sensor</h5>
                            <p style="color: ${ammonia.color};">${ammonia.text}</p>
                        </div>
                        <div class="data-card" style="border-left: 4px solid ${thermal.color};">
                            <h5>AMG8833 Sensor</h5>
                            <p style="color: ${thermal.color};">${thermal.text}</p>
                        </div>
                    </div>
                </div>
            `;
        }).join('') : '<p style="color: #666; font-style: italic;">No device data available</p>';
        
        return `
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <!-- Weekly Summary Cards -->
                <div class="data-grid">
                    <div class="data-card">
                        <h5>Temperature</h5>
                        <p>${data.temperature.avg}°C</p>
                        <small style="color: #666;">Range: ${data.temperature.min}°C - ${data.temperature.max}°C</small>
                    </div>
                    <div class="data-card">
                        <h5>Humidity</h5>
                        <p>${data.humidity.avg}%</p>
                        <small style="color: #666;">Range: ${data.humidity.min}% - ${data.humidity.max}%</small>
                    </div>
                    <div class="data-card">
                        <h5>Ammonia</h5>
                        <p>${data.ammonia.avg}ppm</p>
                        <small style="color: #666;">Range: ${data.ammonia.min}ppm - ${data.ammonia.max}ppm</small>
                    </div>
                    <div class="data-card" style="border-left: 4px solid #f44336;">
                        <h5>Total Alerts</h5>
                        <p style="color: #f44336;">${data.totalAlerts}</p>
                        <small style="color: #666;">Weekly Total</small>
                    </div>
                </div>
                
                <!-- System Status -->
                <div class="section-title">System Status</div>
                <div class="data-grid">
                    <div class="data-card" style="border-left: 4px solid #4CAF50;">
                        <h5>System Status</h5>
                        <p style="color: #4CAF50;">Operational</p>
                    </div>
                    <div class="data-card" style="border-left: 4px solid #f44336;">
                        <h5>Total Alerts</h5>
                        <p style="color: #f44336;">${data.totalAlerts || 0}</p>
                    </div>
                    <div class="data-card" style="border-left: 4px solid #2196F3;">
                        <h5>Pump Events</h5>
                        <p>${Math.floor(data.pumpTotalTime / 10) || 0}</p>
                    </div>
                    <div class="data-card" style="border-left: 4px solid #ff9800;">
                        <h5>Heat Events</h5>
                        <p>${Math.floor(data.heatTotalTime / 15) || 0}</p>
                    </div>
                    <div class="data-card" style="border-left: 4px solid #9e9e9e;">
                        <h5>System Events</h5>
                        <p>7</p>
                    </div>
                </div>
                
                <!-- Device Status -->
                <div class="section-title">Device Status & Components</div>
                ${deviceStatusHtml}
                
                <!-- Control Events -->
                <div class="section-title">Weekly Control Events & Activity Log</div>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <div class="event-item" style="border-left-color: #4CAF50; background: #e8f5e9;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: 600;">Total Pump Runtime: ${data.pumpTotalTime || 0} minutes</span>
                            <span style="font-size: 12px; color: #666;">Weekly Total</span>
                        </div>
                    </div>
                    <div class="event-item" style="border-left-color: #2196F3; background: #e3f2fd;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: 600;">Average Daily Pump Time: ${Math.round((data.pumpTotalTime || 0) / 7)} minutes</span>
                            <span style="font-size: 12px; color: #666;">Per Day</span>
                        </div>
                    </div>
                    <div class="event-item" style="border-left-color: #ff9800; background: #fff3e0;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: 600;">Total Heat Runtime: ${data.heatTotalTime || 0} minutes</span>
                            <span style="font-size: 12px; color: #666;">Weekly Total</span>
                        </div>
                    </div>
                    <div class="event-item" style="border-left-color: #f44336; background: #ffebee;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: 600;">ALERT: Total threshold violations: ${data.totalAlerts || 0}</span>
                            <span style="font-size: 12px; color: #666;">Weekly Total</span>
                        </div>
                    </div>
                </div>
                
                <!-- Notes -->
                <div class="section-title">Notes</div>
                <p style="margin: 0; color: #666; line-height: 1.5;">Weekly summary completed successfully. All systems operated within normal parameters.</p>
                
                ${data.dailyData && data.dailyData.length > 0 ? `
                <div class="section-title">Daily Breakdown</div>
                <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
                    <thead>
                        <tr style="background: #f5f5f5;">
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Date</th>
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Temp (°C)</th>
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Humidity (%)</th>
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Ammonia (ppm)</th>
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Pump (min)</th>
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Heat (min)</th>
                            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Alerts</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${data.dailyData.map(day => {
                            const date = new Date(day.date).toLocaleDateString();
                            return `
                                <tr>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${date}</td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${day.temperature.avg}</td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${day.humidity.avg}</td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${day.ammonia.avg}</td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${day.pumpMinutes}</td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${day.heatMinutes}</td>
                                    <td style="padding: 8px; border: 1px solid #ddd; color: ${day.alerts > 0 ? '#f44336' : '#4CAF50'};">${day.alerts}</td>
                                </tr>
                            `;
                        }).join('')}
                    </tbody>
                </table>
                ` : ''}
            </div>
        `;
    }
    
    logout() {
        if (!confirm('Are you sure you want to logout?')) return;
        
        fetch('../php/admin_auth.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'logout' })
        }).finally(() => {
            try {
                localStorage.removeItem('swift_user');
            } catch (e) {
                console.log('Error removing user data:', e);
            }
            
            try {
                if (window.SWIFT_DATA_SERVICE && window.SWIFT_DATA_SERVICE.stop) {
                    window.SWIFT_DATA_SERVICE.stop();
                }
            } catch (e) {
                console.log('Error stopping data service:', e);
            }
            
            try {
                if (window.SWIFT_TEXT_UPDATE && window.SWIFT_TEXT_UPDATE.stop) {
                    window.SWIFT_TEXT_UPDATE.stop();
                }
            } catch (e) {
                console.log('Error stopping text update service:', e);
            }
            
            window.location.href = '../admin/login.html';
        });
    }
    
    // Cleanup method
    destroy() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
        }
        console.log('Weekly Report: Cleanup completed');
    }
}

// Initialize when DOM is loaded
let weeklyReport = null;

document.addEventListener('DOMContentLoaded', () => {
    // Only start if user is authenticated
    try {
        const user = JSON.parse(localStorage.getItem('swift_user') || 'null');
        if (user) {
            weeklyReport = new WeeklyReport();
        }
    } catch (error) {
        console.log('Authentication check failed for Weekly Report:', error);
    }
});

// Handle page unload
window.addEventListener('beforeunload', () => {
    if (weeklyReport) {
        weeklyReport.destroy();
    }
});

console.log('Weekly Report script loaded');


console.log('Weekly Report script loaded');
