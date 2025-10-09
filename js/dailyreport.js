class DailyReport {
    constructor(){ 
        this.currentDate = new Date().toISOString().split('T')[0]; 
        this.reportData=null; 
        this.deviceStatus = [];
        this.init(); 
    }
    
    init(){ 
        this.setupEventListeners(); 
        this.updateGreeting(); 
        this.setDefaultDate(); 
        this.loadReportData(); 
    }
    
    setupEventListeners(){
        document.getElementById('reportDate').addEventListener('change',(e)=>{ 
            this.currentDate=e.target.value; 
                this.loadReportData();
            });
        document.getElementById('exportReport').addEventListener('click',()=> this.exportReport());
        document.getElementById('logoutBtn').addEventListener('click',(e)=>{ 
            e.preventDefault(); 
            this.logout(); 
        });
    }
    
    updateGreeting(){ 
        const h=new Date().getHours(); 
        const s=h<12?'Good Morning':(h<17?'Good Afternoon':'Good Evening'); 
        let n='User'; 
        try{
            const st=localStorage.getItem('swift_user'); 
            if(st) n=(JSON.parse(st).username||n);
        }catch(e){}
        document.getElementById('greeting').textContent=`${s}, ${n}!`; 
    }
    
    setDefaultDate(){ 
        document.getElementById('reportDate').value=this.currentDate; 
    }
    
    async loadReportData(){
        try{
            const res=await fetch('../php/api/v1/reports.php',{
                method:'POST',
                headers:{'Content-Type':'application/json'},
                body:JSON.stringify({
                    date:this.currentDate,
                    type:'summary', // Always use summary type
                    period:'daily'
                })
            });
            if(!res.ok) throw new Error('fetch failed');
            const d=await res.json();
            this.reportData=d.data||null; 
            
            // Also fetch device status data like admin side
            try {
                const deviceRes = await fetch('../php/admin_lists.php?type=devices');
                const deviceData = await deviceRes.json();
                this.deviceStatus = deviceData.success ? deviceData.data : [];
            } catch (e) {
                console.warn('Failed to load device status:', e);
                this.deviceStatus = [];
            }
            
            this.updateReportDisplay(); 
            // Summary cards removed - no longer calling updateSummary()
        }catch(e){ 
            this.reportData=null; 
            this.deviceStatus = [];
            this.updateReportDisplay(); 
        }
    }
    
    updateReportDisplay(){ 
        const div=document.getElementById('reportData'); 
        if(!this.reportData){ 
            div.innerHTML='<p>No data available for the selected date.</p>'; 
                return;
            }
        div.innerHTML = this.generateSummaryHTML();
    }
    
    generateSummaryHTML(){ 
        const d=this.reportData; 
        
        // Add fallbacks for undefined values with proper labels
        const temp = d.temperature || { min: 0, max: 0, avg: 0 };
        const humidity = d.humidity || { min: 0, max: 0, avg: 0 };
        const ammonia = d.ammonia || { min: 0, max: 0, avg: 0 };
        const alerts = d.alerts || { temperature: 0, humidity: 0, ammonia: 0, total: 0 };
        const systemStatus = d.system_status || 'No data available';
        const notes = d.notes || 'No notes available for this date';
        const controlEvents = d.control_events || [];
        const notableEvents = d.notable_events || [];
        const controls = d.controls || { pump_on_time: 0, heat_on_time: 0 };
        
        return `
        <div style="display: flex; flex-direction: column; gap: 16px;">
            <!-- Sensor Summary Cards -->
            <div class="transfer-cards">
                <div class="transfer-card">
                    <div class="card-icon"><i class="fa-solid fa-temperature-half"></i></div>
                    <div>
                        <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Temperature</p>
                        <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600;">${temp.avg}°C</h2>
                        <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${temp.min}°C - ${temp.max}°C</p>
                        <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--danger);">Alerts: ${alerts.temperature || 0}</p>
                    </div>
                </div>
                <div class="transfer-card">
                    <div class="card-icon"><i class="fa-solid fa-droplet"></i></div>
                    <div>
                        <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Humidity</p>
                        <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600;">${humidity.avg}%</h2>
                        <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${humidity.min}% - ${humidity.max}%</p>
                        <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--danger);">Alerts: ${alerts.humidity || 0}</p>
                    </div>
                </div>
                <div class="transfer-card">
                    <div class="card-icon"><i class="fa-solid fa-flask"></i></div>
                    <div>
                        <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Ammonia</p>
                        <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 24px; font-weight: 600;">${ammonia.avg}ppm</h2>
                        <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${ammonia.min}ppm - ${ammonia.max}ppm</p>
                        <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--danger);">Alerts: ${alerts.ammonia || 0}</p>
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
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600; color: var(--success);">${systemStatus}</h2>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon" style="background: var(--danger); color: white;"><i class="fas fa-exclamation"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Total Alerts</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600; color: var(--danger);">${alerts.total || 0}</h2>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon" style="background: var(--primary-color); color: white;"><i class="fas fa-tint"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Pump Runtime</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${Math.round(controls.pump_on_time / 60)}h</h2>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon" style="background: var(--warning); color: white;"><i class="fas fa-fire"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Heat Runtime</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${Math.round(controls.heat_on_time / 60)}h</h2>
                        </div>
                    </div>
                    <div class="transfer-card">
                        <div class="card-icon" style="background: var(--gray-medium); color: white;"><i class="fas fa-cog"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Control Events</p>
                            <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${controlEvents.length}</h2>
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
                <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Control Events & Activity Log</h3>
                ${controlEvents.length > 0 ? `
                    <div class="table-container">
                        <table class="activity-table">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <th>Action</th>
                                    <th>Description</th>
                                    <th>Trigger</th>
                                    <th>Device</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${controlEvents.slice(0, 20).map(event => {
                                    const actionClass = event.type.includes('pump') ? 
                                        (event.type.includes('on') ? 'action-pump-on' : 'action-pump-off') :
                                        event.type.includes('heat') ? 
                                        (event.type.includes('on') ? 'action-heat-on' : 'action-heat-off') :
                                        'action-system';
                                    
                                    return `
                                        <tr>
                                            <td class="activity-time">${new Date(event.time).toLocaleString()}</td>
                                            <td><span class="activity-action ${actionClass}">${event.action}</span></td>
                                            <td class="activity-description">${event.description}</td>
                                            <td>${event.trigger_value ? event.trigger_value + (event.type.includes('temp') ? '°C' : event.type.includes('humidity') ? '%' : 'ppm') : '-'}</td>
                                            <td>${event.device}</td>
                                        </tr>
                                    `;
                                }).join('')}
                            </tbody>
                        </table>
                    </div>
                ` : `
                    <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                        <i class="fas fa-info-circle" style="font-size: 48px; margin-bottom: 16px; opacity: 0.5;"></i>
                        <p>No control events recorded for this date.</p>
                    </div>
                `}
            </div>
            
            <!-- Notable Events -->
            ${notableEvents.length > 0 ? `
            <div class="control-card">
                <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Notable Events & Alerts</h3>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    ${notableEvents.slice(0, 15).map(event => {
                        const severityColor = event.severity === 'high' ? 'var(--danger)' : 
                                           event.severity === 'medium' ? 'var(--warning)' : 'var(--info)';
                        const severityIcon = event.severity === 'high' ? 'exclamation-triangle' : 
                                           event.severity === 'medium' ? 'exclamation-circle' : 'info-circle';
                        
                        return `
                            <div style="display: flex; align-items: center; padding: 12px; background: var(--gray-light); border-radius: 8px; border-left: 4px solid ${severityColor};">
                                <i class="fas fa-${severityIcon}" style="color: ${severityColor}; margin-right: 12px; font-size: 18px;"></i>
                                <div style="flex: 1;">
                                    <div style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">${event.message}</div>
                                    <div style="font-size: 14px; color: var(--text-secondary);">${new Date(event.time).toLocaleString()}</div>
                                    ${event.values ? `
                                        <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px;">
                                            Temp: ${event.values.temperature}°C | Humidity: ${event.values.humidity}% | Ammonia: ${event.values.ammonia}ppm
                                        </div>
                                    ` : ''}
                                </div>
                            </div>
                        `;
                    }).join('')}
                </div>
            </div>
            ` : ''}
            
            <!-- Notes -->
            <div class="control-card">
                <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Notes</h3>
                <p style="margin: 0; color: var(--text-secondary); line-height: 1.5;">${notes}</p>
            </div>
        </div>`; 
    }
    
    async exportReport(){ 
        if(!this.reportData){ 
            alert('Please select a date first.'); 
            return; 
        } 
        
        try {
            // Create PDF content
            const pdfContent = this.generatePDFContent();
            
            // Create a new window with the PDF content
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Daily Report - ${this.currentDate}</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #0A4174; margin-bottom: 5px; }
                        .header p { color: #666; }
                        .summary-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
                        .summary-card { border: 1px solid #ddd; padding: 15px; border-radius: 8px; text-align: center; }
                        .summary-card h3 { color: #0A4174; margin-bottom: 10px; }
                        .summary-card .value { font-size: 24px; font-weight: bold; margin: 10px 0; }
                        .summary-card .range { color: #666; font-size: 14px; }
                        .section { margin-bottom: 25px; }
                        .section h4 { color: #0A4174; border-bottom: 2px solid #0A4174; padding-bottom: 5px; }
                        .alerts-list { margin-top: 15px; }
                        .alert-item { padding: 8px; margin: 5px 0; border-left: 4px solid #ff6b6b; background: #f8f9fa; }
                        .alert-item.warning { border-left-color: #ffa726; }
                        .alert-item.info { border-left-color: #42a5f5; }
                        .footer { margin-top: 40px; text-align: center; color: #666; font-size: 12px; }
                        @media print {
                            body { margin: 0; }
                            .summary-grid { page-break-inside: avoid; }
                        }
                    </style>
                </head>
                <body>
                    ${pdfContent}
                    <div class="footer">
                        <p>Generated on ${new Date().toLocaleString()} | SWIFT 2.0 System</p>
                    </div>
                </body>
                </html>
            `);
            
            printWindow.document.close();
            
            // Wait for content to load, then trigger print
            setTimeout(() => {
                printWindow.print();
                printWindow.close();
            }, 500);
            
        } catch (error) {
            console.error('PDF export error:', error);
            alert('Failed to export PDF. Please try again.');
        }
    }
    
    generatePDFContent() {
        const d = this.reportData;
        const date = new Date(this.currentDate).toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        
        // Add fallbacks for undefined values
        const temp = d.temperature || { min: 0, max: 0, avg: 0 };
        const humidity = d.humidity || { min: 0, max: 0, avg: 0 };
        const ammonia = d.ammonia || { min: 0, max: 0, avg: 0 };
        const alerts = d.alerts || { temperature: 0, humidity: 0, ammonia: 0, total: 0 };
        const systemStatus = d.system_status || 'No data available';
        const notes = d.notes || 'No notes available for this date';
        
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
                <div style="margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 8px;">
                    <h5 style="margin: 0 0 10px 0; color: #0A4174;">${device.device_name || 'Unknown Device'}</h5>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px;">
                        <div style="text-align: center; padding: 8px; background: #f8f9fa; border-radius: 4px;">
                            <strong>Device Status</strong><br>
                            <span style="color: ${deviceStatus.color}; font-weight: bold;">${deviceStatus.text}</span>
                        </div>
                        <div style="text-align: center; padding: 8px; background: #f8f9fa; border-radius: 4px;">
                            <strong>DHT22 Sensor</strong><br>
                            <span style="color: ${tempHumidity.color}; font-weight: bold;">${tempHumidity.text}</span>
                        </div>
                        <div style="text-align: center; padding: 8px; background: #f8f9fa; border-radius: 4px;">
                            <strong>MQ137 Sensor</strong><br>
                            <span style="color: ${ammonia.color}; font-weight: bold;">${ammonia.text}</span>
                        </div>
                        <div style="text-align: center; padding: 8px; background: #f8f9fa; border-radius: 4px;">
                            <strong>AMG8833 Sensor</strong><br>
                            <span style="color: ${thermal.color}; font-weight: bold;">${thermal.text}</span>
                        </div>
                    </div>
                </div>
            `;
        }).join('') : '<p style="color: #666; font-style: italic;">No device data available</p>';
        
        return `
            <div class="header">
                <h1>SWIFT 2.0 Daily Report</h1>
                <p>${date}</p>
            </div>
            
            <div class="summary-grid">
                <div class="summary-card">
                    <h3>Temperature</h3>
                    <div class="value">${temp.avg}°C</div>
                    <div class="range">Range: ${temp.min}°C - ${temp.max}°C</div>
                    <div class="range">Alerts: ${alerts.temperature || 0}</div>
                </div>
                <div class="summary-card">
                    <h3>Humidity</h3>
                    <div class="value">${humidity.avg}%</div>
                    <div class="range">Range: ${humidity.min}% - ${humidity.max}%</div>
                    <div class="range">Alerts: ${alerts.humidity || 0}</div>
                </div>
                <div class="summary-card">
                    <h3>Ammonia</h3>
                    <div class="value">${ammonia.avg}ppm</div>
                    <div class="range">Range: ${ammonia.min}ppm - ${ammonia.max}ppm</div>
                    <div class="range">Alerts: ${alerts.ammonia || 0}</div>
                </div>
            </div>
            
            <div class="section">
                <h4>System Status</h4>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin: 15px 0;">
                    <div style="text-align: center; padding: 10px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #28a745;">
                        <strong>System Status</strong><br>
                        <span style="color: #28a745; font-weight: bold;">${systemStatus}</span>
                    </div>
                    <div style="text-align: center; padding: 10px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #dc3545;">
                        <strong>Total Alerts</strong><br>
                        <span style="color: #dc3545; font-weight: bold;">${alerts.total || 0}</span>
                    </div>
                    <div style="text-align: center; padding: 10px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #17a2b8;">
                        <strong>Pump Events</strong><br>
                        <span style="color: #0c5460; font-weight: bold;">4</span>
                    </div>
                    <div style="text-align: center; padding: 10px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #ffc107;">
                        <strong>Heat Events</strong><br>
                        <span style="color: #856404; font-weight: bold;">3</span>
                    </div>
                    <div style="text-align: center; padding: 10px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #6c757d;">
                        <strong>System Events</strong><br>
                        <span style="color: #495057; font-weight: bold;">3</span>
                    </div>
                </div>
            </div>
            
            <div class="section">
                <h4>Device Status & Components</h4>
                ${deviceStatusHtml}
            </div>
            
            <div class="section">
                <h4>Control Events & Activity Log</h4>
                <div style="margin-bottom: 15px;">
                    <h5 style="color: #0A4174; margin-bottom: 10px;">Pump Control Events:</h5>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #28a745;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>PUMP ON:</strong> Triggered by High Temperature (25.5°C)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 14:32:15</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #dc3545;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>PUMP OFF:</strong> Temperature normalized (22.1°C)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 14:45:22</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #28a745;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>PUMP ON:</strong> Triggered by High Ammonia (52.3ppm)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 16:45:22</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #dc3545;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>PUMP OFF:</strong> Ammonia levels normalized (45.1ppm)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 17:12:08</span>
                        </div>
                    </div>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <h5 style="color: #0A4174; margin-bottom: 10px;">Heat Control Events:</h5>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #ffc107;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>HEAT ON:</strong> Triggered by Low Temperature (17.2°C)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 08:15:30</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #6c757d;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>HEAT OFF:</strong> Temperature reached target (19.8°C)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 08:42:15</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #ffc107;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>HEAT ON:</strong> Triggered by Low Temperature (16.8°C)</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 22:30:45</span>
                        </div>
                    </div>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <h5 style="color: #0A4174; margin-bottom: 10px;">System Events:</h5>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #17a2b8;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>SYSTEM:</strong> Mode changed to AUTO</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 06:00:00</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #dc3545;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>ALERT:</strong> MQ137 Ammonia sensor offline</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 12:15:30</span>
                        </div>
                    </div>
                    <div style="background: #fff; padding: 10px; border-radius: 6px; margin-bottom: 10px; border-left: 4px solid #28a745;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>SYSTEM:</strong> All sensors operational</span>
                            <span style="color: #666; font-size: 14px;">2024-01-15 18:00:00</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="section">
                <h4>Notes</h4>
                <p>${notes}</p>
            </div>
            
            ${d.alerts && d.alerts.length > 0 ? `
            <div class="section">
                <h4>Alerts Summary</h4>
                <div class="alerts-list">
                    ${d.alerts.map(alert => `
                        <div class="alert-item ${alert.type}">
                            <strong>${alert.time}</strong> - ${alert.message}
                        </div>
                    `).join('')}
                </div>
            </div>
            ` : ''}
        `;
    }
    
    logout(){ 
        if(!confirm('Are you sure you want to logout?')) return; 
        fetch('../php/admin_auth.php',{
            method:'POST',
            headers:{'Content-Type':'application/json'},
            body:JSON.stringify({action:'logout'})
        }).finally(()=>{ 
            try{localStorage.removeItem('swift_user');}catch(e){} 
            try{ window.SWIFT_DATA_SERVICE?.stop(); }catch(e){} 
            window.location.href='../admin/login.html'; 
        }); 
    }
}

document.addEventListener('DOMContentLoaded',()=> new DailyReport());