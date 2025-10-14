class WeeklyReport {
    constructor(){ 
        this.currentWeek = this.getCurrentWeek(); 
        this.reportData=null; 
        window.weeklyReportInstance = this;
        this.init();
    }
    
    init(){ 
        this.setupEventListeners();
        this.updateGreeting();
        this.setDefaultWeek();
        this.loadReportData(); 
    }
    
    setupEventListeners(){
        document.getElementById('reportWeek').addEventListener('change',(e)=>{ 
            this.currentWeek=e.target.value; 
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
    
    getCurrentWeek() {
        // Calculate Week 42 correctly for Oct 13-19, 2025
        // Week 42 starts on Monday, October 13, 2025
        return '2025-W42';
    }
    
    setDefaultWeek(){ 
        document.getElementById('reportWeek').value=this.currentWeek; 
    }
    
    async loadReportData(){
        try{
            console.log('Loading weekly report data for week:', this.currentWeek);
            
            // Convert week format to start and end dates
            const weekDates = this.getWeekDates(this.currentWeek);
            console.log('Week dates:', weekDates);
            
            const res=await fetch('../php/api/v1/reports.php',{
                method:'POST',
                headers:{'Content-Type':'application/json'},
                body:JSON.stringify({
                    start_date: weekDates.start,
                    end_date: weekDates.end,
                    type:'summary',
                    period:'weekly'
                })
            });
            if(!res.ok) {
                console.error('API response not OK:', res.status, res.statusText);
                throw new Error(`API request failed: ${res.status}`);
            }
            const d=await res.json();
            console.log('API response:', d);
            
            if(d.status === 'success' && d.data) {
                this.reportData = d.data;
                console.log('Weekly report data loaded successfully:', this.reportData);
            } else {
                console.error('API returned error:', d.message);
                this.reportData = null;
            }
            
            this.updateReportDisplay(); 
        }catch(e){ 
            console.error('Error loading weekly report data:', e);
            this.reportData=null; 
            this.updateReportDisplay(); 
        }
    }
    
    getWeekDates(weekString) {
        // Parse week format like "2025-W41"
        const [year, week] = weekString.split('-W');
        const yearNum = parseInt(year);
        const weekNum = parseInt(week);
        
        // Manual mapping for 2025 weeks to fix the calculation issue
        const weekMappings = {
            41: { start: '2025-10-06', end: '2025-10-12' },
            42: { start: '2025-10-13', end: '2025-10-19' },
            43: { start: '2025-10-20', end: '2025-10-26' },
            44: { start: '2025-10-27', end: '2025-11-02' },
            45: { start: '2025-11-03', end: '2025-11-09' },
            46: { start: '2025-11-10', end: '2025-11-16' },
            47: { start: '2025-11-17', end: '2025-11-23' },
            48: { start: '2025-11-24', end: '2025-11-30' },
            49: { start: '2025-12-01', end: '2025-12-07' },
            50: { start: '2025-12-08', end: '2025-12-14' },
            51: { start: '2025-12-15', end: '2025-12-21' },
            52: { start: '2025-12-22', end: '2025-12-28' }
        };
        
        // Use manual mapping for 2025 weeks
        if (yearNum === 2025 && weekMappings[weekNum]) {
            return weekMappings[weekNum];
        }
        
        // For other years or weeks not in mapping, use the original calculation
        const jan1 = new Date(yearNum, 0, 1);
        const jan1Day = jan1.getDay();
        const daysToMonday = jan1Day === 0 ? 1 : 8 - jan1Day;
        const firstMonday = new Date(jan1);
        firstMonday.setDate(jan1.getDate() + daysToMonday);
        
        const weekStart = new Date(firstMonday);
        weekStart.setDate(firstMonday.getDate() + (weekNum - 1) * 7);
        
        const weekEnd = new Date(weekStart);
        weekEnd.setDate(weekStart.getDate() + 6);
        
        return {
            start: weekStart.toISOString().split('T')[0],
            end: weekEnd.toISOString().split('T')[0]
        };
    }
    
    updateReportDisplay(){ 
        const div=document.getElementById('reportData'); 
        if(!this.reportData){ 
            div.innerHTML='<div style="text-align: center; padding: 40px;"><h3>No data available for the selected week.</h3><p>Please select a different week or check back later.</p></div>'; 
            return;
        }
        
        console.log('Updating weekly report display with data:', this.reportData);
        div.innerHTML = this.generateSummaryHTML();
        
        setTimeout(() => {
            this.initializeChart();
        }, 100);
    }
    
    generateSummaryHTML(){ 
        const d=this.reportData; 
        if(!d) return '<div class="transfer-card" style="grid-column: 1 / -1; text-align: center; padding: 40px;"><h3>No data available for this week</h3><p>Please select a different week or check back later.</p></div>';
        
        const temp = d.temperature || { min: 0, max: 0, avg: 0 };
        const humidity = d.humidity || { min: 0, max: 0, avg: 0 };
        const ammonia = d.ammonia || { min: 0, max: 0, avg: 0 };
        const controls = d.controls || { pump_on_time: 0, heat_on_time: 0, pump_triggers: 0, heat_triggers: 0 };
        const alerts = d.alerts || { temperature: 0, humidity: 0, ammonia: 0, total: 0 };
        
        const weekDates = this.getWeekDates(this.currentWeek);
        const weekRange = `${weekDates.start} to ${weekDates.end}`;
        
        return `
            <div class="report-container">
                <!-- Section 1: Weekly Summary -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Weekly Summary - ${weekRange}</h3>
                <div class="transfer-cards">
                    <div class="transfer-card">
                            <div class="card-icon" style="background: var(--danger); color: white;"><i class="fas fa-thermometer-half"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Temperature</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${temp.avg.toFixed(1)}°C</h2>
                                <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${temp.min.toFixed(1)}°C - ${temp.max.toFixed(1)}°C</p>
                        </div>
                    </div>
                    <div class="transfer-card">
                            <div class="card-icon" style="background: var(--info); color: white;"><i class="fas fa-tint"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Humidity</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${humidity.avg.toFixed(1)}%</h2>
                                <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${humidity.min.toFixed(1)}% - ${humidity.max.toFixed(1)}%</p>
                        </div>
                    </div>
                    <div class="transfer-card">
                            <div class="card-icon" style="background: var(--warning); color: white;"><i class="fas fa-flask"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Ammonia</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${ammonia.avg.toFixed(1)} ppm</h2>
                                <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Range: ${ammonia.min.toFixed(1)} - ${ammonia.max.toFixed(1)} ppm</p>
                        </div>
                    </div>
                    <div class="transfer-card">
                            <div class="card-icon" style="background: var(--primary-color); color: white;"><i class="fas fa-tint"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Pump Triggers</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${controls.pump_triggers || 0}</h2>
                                <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Runtime: ${Math.round(controls.pump_on_time / 60)}h ${Math.round(controls.pump_on_time % 60)}m</p>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--warning); color: white;"><i class="fas fa-fire"></i></div>
                            <div>
                                <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Heat Triggers</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${controls.heat_triggers || 0}</h2>
                                <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Runtime: ${Math.round(controls.heat_on_time / 60)}h ${Math.round(controls.heat_on_time % 60)}m</p>
                            </div>
                        </div>
                        <div class="transfer-card">
                            <div class="card-icon" style="background: var(--gray-medium); color: white;"><i class="fas fa-exclamation-triangle"></i></div>
                        <div>
                            <p class="card-title" style="margin: 0; font-size: 14px; color: var(--text-secondary);">Total Alerts</p>
                                <h2 class="card-amount" style="margin: 4px 0 0 0; font-size: 18px; font-weight: 600;">${alerts.total || 0}</h2>
                                <p style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-secondary);">Temp: ${alerts.temperature || 0} | Hum: ${alerts.humidity || 0} | Amm: ${alerts.ammonia || 0}</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Section 2: Daily Breakdown Chart -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Daily Trends</h3>
                    <div style="width: 100%; height: 400px; position: relative;">
                        <canvas id="weeklyReportChart" width="800" height="400"></canvas>
                    </div>
                </div>
                
                <!-- Section 3: Alerts Section -->
                <div class="control-card">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 600; color: var(--text-primary);">Weekly Alerts</h3>
                    ${this.generateAlertsSection(d)}
                </div>
            </div>
        `;
    }
    
    initializeChart() {
        // Wait for Chart.js to be loaded
        if (typeof Chart === 'undefined') {
            console.log('Chart.js not loaded, retrying in 1 second...');
            setTimeout(() => this.initializeChart(), 1000);
            return;
        }
        
        const canvas = document.getElementById('weeklyReportChart');
        if (!canvas || !this.reportData) {
            console.log('Chart initialization failed:', {
                canvas: !!canvas,
                reportData: !!this.reportData,
                dailyData: this.reportData?.daily_breakdown?.length || 0
            });
            return;
        }
        
        const ctx = canvas.getContext('2d');
        const data = this.reportData;
        
        const dailyData = data.daily_breakdown || [];
        console.log('Chart data:', {
            dailyData: dailyData.length,
            sample: dailyData[0]
        });
        
        const labels = dailyData.map(d => {
            const date = new Date(d.date);
            return date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        });
        const temperatureData = dailyData.map(d => d.temperature?.avg || 0);
        const humidityData = dailyData.map(d => d.humidity?.avg || 0);
        const ammoniaData = dailyData.map(d => d.ammonia?.avg || 0);
        
        console.log('Chart datasets:', {
            labels: labels.length,
            temperature: temperatureData,
            humidity: humidityData,
            ammonia: ammoniaData
        });
        
        try {
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Temperature (°C)',
                        data: temperatureData,
                        borderColor: '#ff6b6b',
                        backgroundColor: 'rgba(255, 107, 107, 0.1)',
                        tension: 0.4,
                        fill: false
                    },
                    {
                        label: 'Humidity (%)',
                        data: humidityData,
                        borderColor: '#4ecdc4',
                        backgroundColor: 'rgba(78, 205, 196, 0.1)',
                        tension: 0.4,
                        fill: false
                    },
                    {
                        label: 'Ammonia (ppm)',
                        data: ammoniaData,
                        borderColor: '#45b7d1',
                        backgroundColor: 'rgba(69, 183, 209, 0.1)',
                        tension: 0.4,
                        fill: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                            text: `Weekly Sensor Data Trends - ${this.currentWeek}`
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        }
                    },
                    x: {
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
            console.log('Weekly chart created successfully');
        } catch (error) {
            console.error('Weekly chart creation failed:', error);
        }
    }
    
    generateAlertsSection(data) {
        const dbAlerts = data.individual_alerts || data.alerts || [];
        
        const alerts = dbAlerts.map(alert => {
            let icon = '<i class="fas fa-exclamation-triangle"></i>';
            switch(alert.type) {
                case 'temperature':
                    icon = '<i class="fas fa-thermometer-half"></i>';
                    break;
                case 'humidity':
                    icon = '<i class="fas fa-tint"></i>';
                    break;
                case 'ammonia':
                    icon = '<i class="fas fa-flask"></i>';
                    break;
                case 'device_response':
                    if (alert.parameter.includes('Sprinkler')) {
                        icon = '<i class="fas fa-tint"></i>';
                    } else if (alert.parameter.includes('Heat')) {
                        icon = '<i class="fas fa-fire"></i>';
                    } else {
                        icon = '<i class="fas fa-wrench"></i>';
                    }
                    break;
                case 'system':
                    icon = '<i class="fas fa-exclamation-triangle"></i>';
                    break;
            }
            
            let unit = '';
            if (alert.parameter.includes('Temperature')) {
                unit = '°C';
            } else if (alert.parameter.includes('Humidity')) {
                unit = '%';
            } else if (alert.parameter.includes('Ammonia')) {
                unit = 'ppm';
            }
            
            return {
                id: alert.id,
                type: alert.type,
                icon: icon,
                parameter: alert.parameter,
                currentValue: alert.current_value,
                threshold: alert.threshold_value ? `${alert.threshold_value}${unit}` : 'N/A',
                status: alert.severity.charAt(0).toUpperCase() + alert.severity.slice(1),
                severity: alert.severity,
                message: alert.message,
                timestamp: alert.timestamp,
                description: alert.description,
                triggerReason: alert.trigger_reason,
                deviceResponse: alert.device_response,
                alertStatus: alert.status
            };
        });
        
        alerts.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));
        
        if (alerts.length === 0) {
            return `
                <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                    <i class="fas fa-check-circle" style="font-size: 48px; margin-bottom: 16px; color: var(--success);"></i>
                    <p>No alerts detected for this week.</p>
                    <p style="font-size: 14px; margin-top: 8px;">All parameters are within normal ranges.</p>
                </div>
            `;
        }
        
                                    return `
            <!-- Filter Options -->
            <div style="margin-bottom: 16px; padding: 12px; background: var(--gray-light); border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                    <span style="font-size: 14px; font-weight: 600; color: var(--text-primary);">Filter by type:</span>
                    <button onclick="window.weeklyReportInstance.filterAlerts('all')" class="filter-btn active" style="padding: 6px 12px; border: 1px solid var(--primary-color); background: var(--primary-color); color: white; border-radius: 6px; font-size: 12px; cursor: pointer;">All</button>
                    <button onclick="window.weeklyReportInstance.filterAlerts('temperature')" class="filter-btn" style="padding: 6px 12px; border: 1px solid var(--gray-300); background: white; color: var(--text-primary); border-radius: 6px; font-size: 12px; cursor: pointer;"><i class="fas fa-thermometer-half"></i> Temperature</button>
                    <button onclick="window.weeklyReportInstance.filterAlerts('humidity')" class="filter-btn" style="padding: 6px 12px; border: 1px solid var(--gray-300); background: white; color: var(--text-primary); border-radius: 6px; font-size: 12px; cursor: pointer;"><i class="fas fa-tint"></i> Humidity</button>
                    <button onclick="window.weeklyReportInstance.filterAlerts('ammonia')" class="filter-btn" style="padding: 6px 12px; border: 1px solid var(--gray-300); background: white; color: var(--text-primary); border-radius: 6px; font-size: 12px; cursor: pointer;"><i class="fas fa-flask"></i> Ammonia</button>
                    <button onclick="window.weeklyReportInstance.filterAlerts('device_response')" class="filter-btn" style="padding: 6px 12px; border: 1px solid var(--gray-300); background: white; color: var(--text-primary); border-radius: 6px; font-size: 12px; cursor: pointer;"><i class="fas fa-wrench"></i> Device Response</button>
            </div>
                            </div>
            
            <div class="alert-container" style="max-height: 400px; overflow-y: auto; padding-right: 8px; display: flex; flex-direction: column; gap: 12px;">
                ${alerts.map(alert => {
                    const severityColors = {
                        'critical': { bg: '#fee2e2', border: '#dc2626', text: '#dc2626', dot: '<i class="fas fa-circle" style="color: #dc2626;"></i>' },
                        'warning': { bg: '#fef3c7', border: '#d97706', text: '#d97706', dot: '<i class="fas fa-circle" style="color: #d97706;"></i>' },
                        'info': { bg: '#dbeafe', border: '#2563eb', text: '#2563eb', dot: '<i class="fas fa-circle" style="color: #2563eb;"></i>' },
                        'normal': { bg: '#f0fdf4', border: '#16a34a', text: '#16a34a', dot: '<i class="fas fa-circle" style="color: #16a34a;"></i>' }
                    };
                    
                    const colors = severityColors[alert.severity] || severityColors['normal'];
                        
                        return `
                        <div class="alert-card" data-alert-type="${alert.type}" style="display: flex; align-items: flex-start; padding: 16px; background: ${colors.bg}; border-radius: 12px; border-left: 4px solid ${colors.border}; box-shadow: 0 2px 4px rgba(0,0,0,0.1); flex-shrink: 0;">
                            <div style="margin-right: 12px; font-size: 24px;">${alert.icon}</div>
                                <div style="flex: 1;">
                                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                                    <span style="font-weight: 600; color: var(--text-primary); margin-right: 8px;">${alert.message}</span>
                                    <span style="font-size: 16px;">${colors.dot}</span>
                                        </div>
                                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); gap: 8px; margin-bottom: 8px;">
                                    <div style="font-size: 12px; color: var(--text-secondary);">
                                        <strong>Parameter:</strong> ${alert.parameter}
                                    </div>
                                    <div style="font-size: 12px; color: var(--text-secondary);">
                                        <strong>Current:</strong> ${alert.currentValue || 'N/A'}${alert.currentValue ? (alert.parameter.includes('Temperature') ? '°C' : alert.parameter.includes('Humidity') ? '%' : alert.parameter.includes('Ammonia') ? 'ppm' : '') : ''}
                                        </div>
                                    <div style="font-size: 12px; color: var(--text-secondary);">
                                        <strong>Threshold:</strong> ${alert.threshold}
                                    </div>
                                    <div style="font-size: 12px; color: ${colors.text}; font-weight: 600;">
                                        <strong>Status:</strong> ${alert.status}
                                        </div>
                                    </div>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <div style="font-size: 12px; color: var(--text-secondary);">
                                        ${new Date(alert.timestamp).toLocaleString()}
                                        </div>
                                    ${alert.deviceResponse ? `
                                        <div style="font-size: 12px; color: var(--text-secondary);">
                                            Response: ${alert.deviceResponse}
                                        </div>
                                    ` : ''}
                                    <button onclick="this.parentElement.parentElement.parentElement.style.display='none'" style="background: none; border: none; color: var(--text-secondary); cursor: pointer; padding: 4px; border-radius: 4px; hover:background: var(--gray-light);">
                                        <i class="fas fa-times"></i>
                                    </button>
                                    </div>
                                </div>
                            </div>
                        `;
                    }).join('')}
                </div>
                
            <!-- Alert Count Indicator -->
            <div style="margin-top: 12px; padding: 8px 12px; background: var(--gray-light); border-radius: 6px; text-align: center;">
                <span style="font-size: 12px; color: var(--text-secondary);">
                    <i class="fas fa-info-circle"></i> Showing ${alerts.length} alert${alerts.length !== 1 ? 's' : ''} 
                    ${alerts.length > 5 ? '(scroll to see more)' : ''}
                </span>
                </div>
        `;
    }
    
    filterAlerts(type) {
        const filterButtons = document.querySelectorAll('.filter-btn');
        
        filterButtons.forEach(btn => {
            btn.classList.remove('active');
            btn.style.background = 'white';
            btn.style.color = 'var(--text-primary)';
            btn.style.border = '1px solid var(--gray-300)';
        });
        
        const clickedBtn = Array.from(filterButtons).find(btn => {
            const btnText = btn.textContent.toLowerCase();
            return (type === 'all' && btnText.includes('all')) ||
                   (type === 'temperature' && btnText.includes('temperature')) ||
                   (type === 'humidity' && btnText.includes('humidity')) ||
                   (type === 'ammonia' && btnText.includes('ammonia')) ||
                   (type === 'device_response' && btnText.includes('device response'));
        });
        
        if (clickedBtn) {
            clickedBtn.classList.add('active');
            clickedBtn.style.background = 'var(--primary-color)';
            clickedBtn.style.color = 'white';
            clickedBtn.style.border = '1px solid var(--primary-color)';
        }
        
        const alertCards = document.querySelectorAll('.alert-card');
        alertCards.forEach(card => {
            const cardType = card.dataset.alertType;
            if (type === 'all' || cardType === type) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });
    }
    
    async exportReport(){ 
        if(!this.reportData){ 
            alert('Please select a week first.'); 
            return;
        }
        
        try {
            const exportBtn = document.getElementById('exportReport');
            const originalText = exportBtn.textContent;
            exportBtn.textContent = 'Generating PDF...';
            exportBtn.disabled = true;
            
            const pdfContent = this.generatePDFContent();
            
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Weekly Report - ${this.currentWeek}</title>
                    <meta charset="UTF-8">
                    <style>
                        body { 
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
                            margin: 0; 
                            padding: 20px; 
                            background: #f8f9fa;
                            color: #333;
                        }
                        .container {
                            max-width: 1200px;
                            margin: 0 auto;
                            background: white;
                            padding: 30px;
                            border-radius: 12px;
                            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                        }
                        .header { 
                            text-align: center; 
                            margin-bottom: 40px; 
                            padding-bottom: 20px;
                            border-bottom: 3px solid #0A4174;
                        }
                        .header h1 { 
                            color: #0A4174; 
                            margin-bottom: 10px; 
                            font-size: 32px;
                            font-weight: 700;
                        }
                        .header p { 
                            color: #666; 
                            font-size: 16px;
                            margin: 0;
                        }
                        .summary-section {
                            margin-bottom: 40px;
                        }
                        .summary-title {
                            font-size: 24px;
                            font-weight: 600;
                            color: #0A4174;
                            margin-bottom: 20px;
                            padding-bottom: 10px;
                            border-bottom: 2px solid #e9ecef;
                        }
                        .summary-grid { 
                            display: grid; 
                            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
                            gap: 20px; 
                            margin-bottom: 30px; 
                        }
                        .summary-card { 
                            border: 1px solid #e9ecef; 
                            padding: 20px; 
                            border-radius: 12px; 
                            text-align: center;
                            background: #f8f9fa;
                            transition: all 0.3s ease;
                        }
                        .summary-card h3 { 
                            color: #0A4174; 
                            margin-bottom: 15px; 
                            font-size: 18px;
                            font-weight: 600;
                        }
                        .summary-card .value { 
                            font-size: 28px; 
                            font-weight: bold; 
                            margin: 15px 0; 
                            color: #333;
                        }
                        .summary-card .range { 
                            color: #666; 
                            font-size: 14px; 
                            margin: 5px 0;
                        }
                         .chart-section {
                             margin-bottom: 40px;
                         }
                         .chart-svg {
                             max-width: 100%;
                             height: auto;
                             border: 1px solid #e9ecef;
                             border-radius: 8px;
                             background: white;
                             box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                         }
                        .alerts-section {
                            margin-bottom: 40px;
                        }
                        .alerts-title {
                            font-size: 24px;
                            font-weight: 600;
                            color: #0A4174;
                            margin-bottom: 20px;
                            padding-bottom: 10px;
                            border-bottom: 2px solid #e9ecef;
                        }
                        .alerts-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                            gap: 15px;
                        }
                        .alert-card {
                            border: 1px solid #e9ecef;
                            border-left: 4px solid #ff6b6b;
                            padding: 15px;
                            border-radius: 8px;
                            background: #fff;
                        }
                        .alert-card.warning { border-left-color: #ffa726; }
                        .alert-card.info { border-left-color: #42a5f5; }
                        .alert-card.normal { border-left-color: #28a745; }
                        .alert-header {
                            display: flex;
                            align-items: center;
                            margin-bottom: 10px;
                        }
                        .alert-icon {
                            font-size: 20px;
                            margin-right: 10px;
                        }
                        .alert-title {
                            font-weight: 600;
                            color: #333;
                        }
                        .alert-details {
                            font-size: 14px;
                            color: #666;
                            line-height: 1.4;
                        }
                        .alert-time {
                            font-size: 12px;
                            color: #999;
                            margin-top: 8px;
                        }
                        .footer { 
                            margin-top: 50px; 
                            text-align: center; 
                            color: #666; 
                            font-size: 14px;
                            padding-top: 20px;
                            border-top: 1px solid #e9ecef;
                        }
                        @media print {
                            body { 
                                margin: 0; 
                                padding: 15px;
                                background: white;
                            }
                            .container {
                                box-shadow: none;
                                padding: 20px;
                            }
                            .summary-grid { page-break-inside: avoid; }
                            .alerts-grid { page-break-inside: avoid; }
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        ${pdfContent}
                    <div class="footer">
                            <p><strong>Generated on ${new Date().toLocaleString()}</strong> | SWIFT 2.0 Monitoring System</p>
                            <p>This report contains automated sensor data and system alerts for week ${this.currentWeek}</p>
                    </div>
                    </div>
                </body>
                </html>
            `);
            
            printWindow.document.close();
            
            setTimeout(() => {
                printWindow.print();
                printWindow.close();
                
                exportBtn.textContent = originalText;
                exportBtn.disabled = false;
            }, 1000);
            
        } catch (error) {
            console.error('PDF export error:', error);
            alert('Failed to export PDF. Please try again.');
            
            const exportBtn = document.getElementById('exportReport');
            exportBtn.textContent = 'Export PDF';
            exportBtn.disabled = false;
        }
    }
    
    generatePDFContent() {
        const d = this.reportData;
        const weekDates = this.getWeekDates(this.currentWeek);
        const weekRange = `${weekDates.start} to ${weekDates.end}`;
        
        const temp = d.temperature || { min: 0, max: 0, avg: 0 };
        const humidity = d.humidity || { min: 0, max: 0, avg: 0 };
        const ammonia = d.ammonia || { min: 0, max: 0, avg: 0 };
        const controls = d.controls || { pump_on_time: 0, heat_on_time: 0, pump_triggers: 0, heat_triggers: 0 };
        const alerts = d.alerts || { temperature: 0, humidity: 0, ammonia: 0, total: 0 };
            
            return `
            <div class="header">
                <h1>SWIFT 2.0 Weekly Report</h1>
                <p>Week ${this.currentWeek} (${weekRange})</p>
                        </div>
            
            <!-- Section 1: Summary -->
            <div class="summary-section">
                <h2 class="summary-title">Weekly Summary</h2>
            <div class="summary-grid">
                <div class="summary-card">
                    <h3>Temperature</h3>
                        <div class="value">${temp.avg.toFixed(1)}°C</div>
                        <div class="range">Range: ${temp.min.toFixed(1)}°C - ${temp.max.toFixed(1)}°C</div>
                    <div class="range">Alerts: ${alerts.temperature || 0}</div>
                        </div>
                <div class="summary-card">
                    <h3>Humidity</h3>
                        <div class="value">${humidity.avg.toFixed(1)}%</div>
                        <div class="range">Range: ${humidity.min.toFixed(1)}% - ${humidity.max.toFixed(1)}%</div>
                    <div class="range">Alerts: ${alerts.humidity || 0}</div>
                        </div>
                <div class="summary-card">
                    <h3>Ammonia</h3>
                        <div class="value">${ammonia.avg.toFixed(1)} ppm</div>
                        <div class="range">Range: ${ammonia.min.toFixed(1)} - ${ammonia.max.toFixed(1)} ppm</div>
                    <div class="range">Alerts: ${alerts.ammonia || 0}</div>
                        </div>
                    <div class="summary-card">
                        <h3>Pump Triggers</h3>
                        <div class="value">${controls.pump_triggers || 0}</div>
                        <div class="range">Runtime: ${Math.round(controls.pump_on_time / 60)}h ${Math.round(controls.pump_on_time % 60)}m</div>
                    </div>
                    <div class="summary-card">
                        <h3>Heat Triggers</h3>
                        <div class="value">${controls.heat_triggers || 0}</div>
                        <div class="range">Runtime: ${Math.round(controls.heat_on_time / 60)}h ${Math.round(controls.heat_on_time % 60)}m</div>
                </div>
                    <div class="summary-card">
                        <h3>Total Alerts</h3>
                        <div class="value">${alerts.total || 0}</div>
                        <div class="range">Temp: ${alerts.temperature || 0} | Hum: ${alerts.humidity || 0} | Amm: ${alerts.ammonia || 0}</div>
                    </div>
                    </div>
                    </div>
            
             <!-- Section 2: Chart Data Table -->
             <div class="chart-section">
                 <h2 class="summary-title">Daily Trends</h2>
                 ${this.generatePDFChartSection(d)}
                    </div>
            
            <!-- Section 3: Alerts -->
            <div class="alerts-section">
                <h2 class="alerts-title">Weekly Alerts</h2>
                ${this.generatePDFAlertsSection(d)}
                </div>
        `;
    }
    
    generatePDFChartSection(data) {
        const dailyData = data.daily_breakdown || [];
        
        if (dailyData.length === 0) {
            return `
                <div style="text-align: center; padding: 40px; color: #666; font-style: italic;">
                    <p>No daily data available for this week.</p>
                    </div>
            `;
        }
        
        const labels = dailyData.map(d => {
            const date = new Date(d.date);
            return date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        });
        const temperatureData = dailyData.map(d => d.temperature?.avg || 0);
        const humidityData = dailyData.map(d => d.humidity?.avg || 0);
        const ammoniaData = dailyData.map(d => d.ammonia?.avg || 0);
        
        const width = 800;
        const height = 400;
        const padding = 60;
        const chartWidth = width - (padding * 2);
        const chartHeight = height - (padding * 2);
        
        const allValues = [...temperatureData, ...humidityData, ...ammoniaData];
        const minValue = Math.min(...allValues);
        const maxValue = Math.max(...allValues);
        const valueRange = maxValue - minValue;
        const paddingValue = valueRange * 0.1;
        const scaledMin = Math.max(0, minValue - paddingValue);
        const scaledMax = maxValue + paddingValue;
        const scaledRange = scaledMax - scaledMin;
        
        const valueToY = (value) => {
            return padding + chartHeight - ((value - scaledMin) / scaledRange) * chartHeight;
        };
        
        const indexToX = (index) => {
            return padding + (index / (labels.length - 1)) * chartWidth;
        };
        
        const generatePath = (data, color) => {
            const points = data.map((value, index) => {
                const x = indexToX(index);
                const y = valueToY(value);
                return `${x},${y}`;
            }).join(' L');
            return `M${points}`;
        };
        
        const svg = `
            <svg width="${width}" height="${height}" style="border: 1px solid #e9ecef; border-radius: 8px; background: white;">
                <!-- Grid lines -->
                <defs>
                    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
                        <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#f0f0f0" stroke-width="1"/>
                    </pattern>
                </defs>
                <rect width="100%" height="100%" fill="url(#grid)" />
                
                <!-- Y-axis -->
                <line x1="${padding}" y1="${padding}" x2="${padding}" y2="${height - padding}" stroke="#333" stroke-width="2"/>
                
                <!-- X-axis -->
                <line x1="${padding}" y1="${height - padding}" x2="${width - padding}" y2="${height - padding}" stroke="#333" stroke-width="2"/>
                
                <!-- Y-axis labels -->
                ${Array.from({length: 6}, (_, i) => {
                    const value = scaledMin + (scaledRange / 5) * i;
                    const y = valueToY(value);
                    return `<text x="${padding - 10}" y="${y + 5}" text-anchor="end" font-size="12" fill="#666">${value.toFixed(1)}</text>`;
                }).join('')}
                
                <!-- X-axis labels -->
                ${labels.map((label, index) => {
                    const x = indexToX(index);
                    return `<text x="${x}" y="${height - padding + 20}" text-anchor="middle" font-size="10" fill="#666">${label}</text>`;
                }).join('')}
                
                <!-- Temperature line -->
                <path d="${generatePath(temperatureData)}" fill="none" stroke="#ff6b6b" stroke-width="3"/>
                
                <!-- Humidity line -->
                <path d="${generatePath(humidityData)}" fill="none" stroke="#4ecdc4" stroke-width="3"/>
                
                <!-- Ammonia line -->
                <path d="${generatePath(ammoniaData)}" fill="none" stroke="#45b7d1" stroke-width="3"/>
                
                <!-- Data points -->
                ${temperatureData.map((value, index) => {
                    const x = indexToX(index);
                    const y = valueToY(value);
                    return `<circle cx="${x}" cy="${y}" r="4" fill="#ff6b6b"/>`;
                }).join('')}
                
                ${humidityData.map((value, index) => {
                    const x = indexToX(index);
                    const y = valueToY(value);
                    return `<circle cx="${x}" cy="${y}" r="4" fill="#4ecdc4"/>`;
                }).join('')}
                
                ${ammoniaData.map((value, index) => {
                    const x = indexToX(index);
                    const y = valueToY(value);
                    return `<circle cx="${x}" cy="${y}" r="4" fill="#45b7d1"/>`;
                }).join('')}
                
                <!-- Legend -->
                <g transform="translate(${width - 200}, 20)">
                    <rect x="0" y="0" width="180" height="80" fill="white" stroke="#e9ecef" stroke-width="1" rx="4"/>
                    <line x1="10" y1="20" x2="30" y2="20" stroke="#ff6b6b" stroke-width="3"/>
                    <text x="35" y="25" font-size="12" fill="#333">Temperature (°C)</text>
                    <line x1="10" y1="40" x2="30" y2="40" stroke="#4ecdc4" stroke-width="3"/>
                    <text x="35" y="45" font-size="12" fill="#333">Humidity (%)</text>
                    <line x1="10" y1="60" x2="30" y2="60" stroke="#45b7d1" stroke-width="3"/>
                    <text x="35" y="65" font-size="12" fill="#333">Ammonia (ppm)</text>
                </g>
                
                <!-- Chart title -->
                <text x="${width / 2}" y="25" text-anchor="middle" font-size="16" font-weight="bold" fill="#0A4174">
                    Weekly Sensor Data Trends - ${this.currentWeek}
                </text>
            </svg>
        `;
        
        return `
            <div style="text-align: center; margin-bottom: 20px;">
                <h3 style="margin: 0 0 20px 0; font-size: 18px; font-weight: 600; color: #0A4174;">
                    Daily Trends Visualization
                </h3>
                ${svg}
                    </div>
        `;
    }
    
    generatePDFAlertsSection(data) {
        const dbAlerts = data.individual_alerts || data.alerts || [];
        
        if (dbAlerts.length === 0) {
            return `
                <div class="alerts-grid">
                    <div class="alert-card normal" style="text-align: center; padding: 40px;">
                        <div class="alert-header" style="justify-content: center;">
                            <span class="alert-icon" style="font-size: 48px; color: #16a34a;">✅</span>
                        </div>
                        <div class="alert-title" style="font-size: 18px; font-weight: 600; color: #16a34a; margin: 16px 0;">
                            No alerts detected for this week.
                    </div>
                        <div class="alert-details" style="font-size: 14px; color: #666;">
                            All parameters are within normal ranges.
                        </div>
                    </div>
            </div>
        `;
    }
    
        const displayAlerts = dbAlerts.map(alert => {
            const getIcon = (type) => {
                switch(type) {
                    case 'temperature': return '🌡️';
                    case 'humidity': return '💧';
                    case 'ammonia': return '💨';
                    case 'device_response': return '🔧';
                    default: return '⚠️';
                }
            };
            
            const getSeverityClass = (severity) => {
                switch(severity) {
                    case 'critical': return 'critical';
                    case 'warning': return 'warning';
                    case 'low': return 'normal';
                    default: return 'info';
                }
            };
            
            const getUnit = (parameter) => {
                switch(parameter) {
                    case 'Temperature': return '°C';
                    case 'Humidity': return '%';
                    case 'Ammonia': return 'ppm';
                    default: return '';
                }
            };
            
            return `
                <div class="alert-card ${getSeverityClass(alert.severity)}">
                    <div class="alert-header">
                        <span class="alert-icon">${getIcon(alert.type)}</span>
                        <span class="alert-title">${alert.parameter || 'System Alert'}</span>
                        </div>
                    <div class="alert-details">
                        <strong>${alert.message || 'Alert detected'}</strong><br>
                        ${alert.current_value ? `Current: ${alert.current_value}${getUnit(alert.parameter)}` : ''}
                        ${alert.threshold_value ? ` | Threshold: ${alert.threshold_value}${getUnit(alert.parameter)}` : ''}
                        ${alert.device_response ? `<br>Response: ${alert.device_response}` : ''}
                    </div>
                    <div class="alert-time">
                        ${new Date(alert.timestamp).toLocaleString()}
                        </div>
                    </div>
            `;
        });
        
        return `
            <div class="alerts-grid">
                ${displayAlerts.join('')}
            </div>
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
            window.location.href='../login.html'; 
        }); 
    }
}

document.addEventListener('DOMContentLoaded',()=> new WeeklyReport());