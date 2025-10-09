#include <WiFiS3.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <DHT.h>
#include <Adafruit_AMG88xx.h>

#define DHT_PIN 2
#define MQ137_PIN A0
#define RELAY_PUMP_PIN 3
#define RELAY_HEAT_PIN 4
#define SD_CS_PIN 10
#define LCD_SDA_PIN A4
#define LCD_SCL_PIN A5

DHT dht(DHT_PIN, DHT22);
Adafruit_AMG88xx amg;
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Time management variables
unsigned long lastTimeSync = 0;
unsigned long currentEpochTime = 0;
bool timeInitialized = false;
unsigned long timeSyncRetryCount = 0;
const unsigned long MAX_TIME_SYNC_RETRIES = 10;

const char* ssid = "PLDTHOMEFIBRa7b48";
const char* password = "PLDTWIFIrpmj3";

// Web app server configuration - CORRECTED PATH
const char* serverHost = "192.168.1.11";  // Your computer's IP address (XAMPP server)
const int serverPort = 80;
const char* serverPath = "/SWIFT/NEW_SWIFT/php/save_realtime_data.php";

const float TEMP_LOW_THRESHOLD = 20.0;
const float TEMP_HIGH_THRESHOLD = 40.0;
const float HUMIDITY_THRESHOLD = 70.0;
const float AMMONIA_THRESHOLD = 50.0;

bool pumpStatus = false;
bool heatStatus = false;
bool systemInitialized = false;
String currentMode = "AUTO";  // Start in AUTO mode instead of INIT

// Runtime component status (checked during operation)
bool dht22Active = false;
bool mq137Active = false;
bool amg8833Active = false;
bool sdCardActive = false;
bool ntpActive = false;  // Changed from rtcActive to ntpActive

// HTTP client for sending data to web app
WiFiClient wifiClient;
unsigned long lastDataSent = 0;
const unsigned long DATA_SEND_INTERVAL = 1000; // Send data every 1 second

// Web server for serving live data to dashboard
WiFiServer server(80);
unsigned long lastDataServed = 0;
const unsigned long DATA_SERVE_INTERVAL = 1000; // Serve data every 1 second

// Component status checking
unsigned long lastComponentCheck = 0;
const unsigned long COMPONENT_CHECK_INTERVAL = 5000; // Check components every 5 seconds

// Web app state synchronization
unsigned long lastStateSync = 0;
const unsigned long STATE_SYNC_INTERVAL = 10000; // Sync with web app every 10 seconds

// NTP time management
unsigned long lastNTPUpdate = 0;
const unsigned long NTP_UPDATE_INTERVAL = 300000; // Update NTP every 5 minutes

// Schedule checking
unsigned long lastScheduleCheck = 0;
const unsigned long SCHEDULE_CHECK_INTERVAL = 60000; // Check schedules every 1 minute

struct ComponentStatus {
  bool dht22 = false;
  bool mq137 = false;
  bool amg8833 = false;
  bool ntp = false;  // Changed from rtc to ntp
  bool sdCard = false;
  bool lcd = false;
  bool relay = false;
} components;

struct SensorData {
  float temperature = 0.0;
  float humidity = 0.0;
  float ammonia = 0.0;
  float thermalTemp = 0.0;
  String timestamp = "";
} sensorData;

// Offline data storage for when web app is unavailable
struct OfflineData {
  String timestamp;
  float temperature;
  float humidity;
  float ammonia;
  float thermalTemp;
  String pumpStatus;
  String heatStatus;
  String mode;
} offlineData[100]; // Store up to 100 records
int offlineDataCount = 0;
bool webAppOnline = false;

void setup() {
  Serial.begin(115200);
  Serial.println("=====SWIFT=====");
  Serial.println("INITIALIZING COMPONENTS...");
  Serial.println();
  
  // Initialize communication protocols
  Wire.begin();        // Initialize I2C communication
  SPI.begin();         // Initialize SPI communication
  
  pinMode(RELAY_PUMP_PIN, OUTPUT);
  pinMode(RELAY_HEAT_PIN, OUTPUT);
  digitalWrite(RELAY_PUMP_PIN, LOW);
  digitalWrite(RELAY_HEAT_PIN, LOW);
  
  initializeComponents();
  connectToWiFi();
  initializeSDCard();
  
  // Start web server for live data
  server.begin();
  Serial.println("Web server started on port 80");
  Serial.print("Dashboard can access live data at: http://");
  Serial.print(WiFi.localIP());
  Serial.println("/data");
  
  Serial.println();
  Serial.println("SYSTEM INITIALIZATION COMPLETE!");
  Serial.println("==================================================");
  Serial.println();
  Serial.println("TIMING CONFIGURATION:");
  Serial.println();
  Serial.println("Sensor data: Every 1 second");
  Serial.println("Component status: Every 5 seconds");
  Serial.println("Web app sync: Every 10 seconds");
  Serial.println("Web server: Every 1 second");
  Serial.println();
  Serial.println("==================================================");
  Serial.println();
  
  systemInitialized = true;
}

void loop() {
  if (!systemInitialized) {
    Serial.println("System not initialized. Please check components.");
    delay(5000);
    return;
  }
  
  // Check WiFi connection and reconnect if needed
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi disconnected! Attempting to reconnect...");
    connectToWiFi();
    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("WiFi reconnection failed. Retrying in 10 seconds...");
      delay(10000);
      return;
    } else {
      // WiFi reconnected, try time sync immediately
      if (!timeInitialized) {
        Serial.println("WiFi reconnected, attempting immediate time sync...");
        attemptTimeSync();
      }
    }
  }
  
  // Update NTP time every 5 minutes
  if (millis() - lastNTPUpdate >= NTP_UPDATE_INTERVAL) {
    updateNTPTime();
    lastNTPUpdate = millis();
  }
  
  // Retry time sync if not initialized (every 10 seconds for faster sync)
  if (!timeInitialized && millis() - lastTimeSync >= 10000) {
    Serial.println("Retrying precise time sync...");
    attemptTimeSync();
    lastTimeSync = millis();
  }
  
  // Check schedules every 1 minute
  if (millis() - lastScheduleCheck >= SCHEDULE_CHECK_INTERVAL) {
    checkScheduledTasks();
    lastScheduleCheck = millis();
  }
  
  // Sync with web app state every 10 seconds
  if (millis() - lastStateSync >= STATE_SYNC_INTERVAL) {
    syncWithWebAppState();
    lastStateSync = millis();
  }
  
  // Collect sensor data and send to web app every 1 second
  if (millis() - lastDataSent >= DATA_SEND_INTERVAL) {
    updateTimestamp();
    collectSensorData();
    processControlLogic();
    displaySerialMonitor();
    displayLCD();
    logToSDCard();
    sendDataToWebApp();
    lastDataSent = millis();
  }
  
  // Handle web server requests for live data
  handleWebServerRequests();
  
  processSerialCommands();
  delay(100); // Minimal delay for responsiveness
}

void initializeComponents() {
  Serial.println("CHECKING COMPONENT STATUS:");
  Serial.println();
  
  dht.begin();
  delay(2000);
  if (!isnan(dht.readTemperature())) {
    components.dht22 = true;
    Serial.println("DHT22 Temperature/Humidity Sensor: OK");
  } else {
    Serial.println("DHT22 Temperature/Humidity Sensor: FAILED");
  }
  
  int mqValue = analogRead(MQ137_PIN);
  if (mqValue > 0) {
    components.mq137 = true;
    Serial.println("MQ137 Ammonia Sensor: OK");
  } else {
    Serial.println("MQ137 Ammonia Sensor: FAILED");
  }
  
  if (amg.begin()) {
    components.amg8833 = true;
    Serial.println("AMG8833 Thermal Camera: OK");
  } else {
    Serial.println("AMG8833 Thermal Camera: FAILED");
  }
  
  // Initialize Time Client (HTTP-based) - Will retry in main loop if fails
  Serial.println("Time Client: Initializing...");
  components.ntp = false; // Will be set to true when sync succeeds
  
  // Attempt immediate time sync if WiFi is connected
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("WiFi connected during setup, attempting immediate time sync...");
    attemptTimeSync();
  }
  
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Swine Farm IoT");
  lcd.setCursor(0, 1);
  lcd.print("Water Sprinkler");
  components.lcd = true;
  Serial.println("LCD Display: OK");
  
  digitalWrite(RELAY_PUMP_PIN, HIGH);
  delay(100);
  digitalWrite(RELAY_PUMP_PIN, LOW);
  digitalWrite(RELAY_HEAT_PIN, HIGH);
  delay(100);
  digitalWrite(RELAY_HEAT_PIN, LOW);
  components.relay = true;
  Serial.println("Relay Module: OK");
  
  Serial.println();
  Serial.println("COMPONENT CHECK COMPLETE!");
  Serial.println("==================================================");
  Serial.println();
}

void connectToWiFi() {
  Serial.println("=== WIFI CONNECTION SETUP ===");
  Serial.println();
  Serial.print("SSID: ");
  Serial.println(ssid);
  Serial.print("Password: ");
  Serial.println(password);
  
  // Check if WiFi module is available
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("✗ WiFi module not found!");
    return;
  }
  
  // Check firmware version
  String fv = WiFi.firmwareVersion();
  Serial.print("WiFi Firmware Version: ");
  Serial.println(fv);
  Serial.println();
  Serial.println("==================================================");
  Serial.println();
  
  Serial.println("ATTEMPTING TO CONNECT TO THE WIFI...");
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  int maxAttempts = 30; // Increased timeout
  
  while (WiFi.status() != WL_CONNECTED && attempts < maxAttempts) {
    delay(1000);
    Serial.print(".");
    attempts++;
    
    // Print status every 5 attempts
    if (attempts % 5 == 0) {
      Serial.println();
      Serial.print("Attempt ");
      Serial.print(attempts);
      Serial.print("/");
      Serial.print(maxAttempts);
      Serial.print(" - Status: ");
      printWiFiStatus();
    }
  }
  
  Serial.println();
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("WIFI CONNECTED SUCCESSFULLY!");
    Serial.println();
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
    Serial.print("Subnet Mask: ");
    Serial.println(WiFi.subnetMask());
    Serial.print("Gateway: ");
    Serial.println(WiFi.gatewayIP());
    Serial.print("Signal Strength (RSSI): ");
    Serial.print(WiFi.RSSI());
    Serial.println(" dBm");
  } else {
    Serial.println("✗ WiFi Connection Failed!");
    printWiFiStatus();
    Serial.println("Troubleshooting tips:");
    Serial.println("1. Check if WiFi credentials are correct");
    Serial.println("2. Ensure WiFi network is 2.4GHz (not 5GHz)");
    Serial.println("3. Check if network allows new devices");
    Serial.println("4. Try restarting your router");
  }
}

void printWiFiStatus() {
  switch (WiFi.status()) {
    case WL_NO_MODULE:
      Serial.println("WiFi module not found");
      break;
    case WL_NO_SSID_AVAIL:
      Serial.println("SSID not available");
      break;
    case WL_SCAN_COMPLETED:
      Serial.println("Scan completed");
      break;
    case WL_CONNECTED:
      Serial.println("Connected");
      break;
    case WL_CONNECT_FAILED:
      Serial.println("Connection failed");
      break;
    case WL_CONNECTION_LOST:
      Serial.println("Connection lost");
      break;
    case WL_DISCONNECTED:
      Serial.println("Disconnected");
      break;
    default:
      Serial.print("Unknown status: ");
      Serial.println(WiFi.status());
      break;
  }
}

void initializeSDCard() {
  if (SD.begin(SD_CS_PIN)) {
    components.sdCard = true;
    Serial.println("✓ SD Card: OK");
    File dataFile = SD.open("swine_farm_log.txt", FILE_WRITE);
    if (dataFile) {
      dataFile.println("Timestamp,Temperature,Humidity,Ammonia,ThermalTemp,PumpStatus,HeatStatus,Mode");
      dataFile.close();
    }
  } else {
    Serial.println("✗ SD Card: FAILED");
  }
}

void updateTimestamp() {
  // Using HTTP-based time sync for accurate real-time timestamp
  if (components.ntp && timeInitialized) {
    // Calculate elapsed time since last sync
    unsigned long elapsedMs = millis() - lastTimeSync;
    unsigned long elapsedSeconds = elapsedMs / 1000;
    
    // Add elapsed time to epoch time
    unsigned long currentTime = currentEpochTime + elapsedSeconds;
    
    // Debug: Print epoch values
    static unsigned long lastDebugTime = 0;
    if (millis() - lastDebugTime >= 10000) { // Debug every 10 seconds
      Serial.println("DEBUG - Epoch time: " + String(currentEpochTime));
      Serial.println("DEBUG - Elapsed seconds: " + String(elapsedSeconds));
      Serial.println("DEBUG - Current time: " + String(currentTime));
      lastDebugTime = millis();
    }
    
    // Validate epoch time (should be reasonable)
    if (currentTime > 1000000000 && currentTime < 3000000000) { // Between 2001 and 2065
      // Convert epoch time to DD/MM/YYYY HH:MM:SS format
      sensorData.timestamp = formatEpochToDDMMYYYY(currentTime);
    } else {
      Serial.println("ERROR - Invalid epoch time: " + String(currentTime));
      sensorData.timestamp = "TIME_ERROR";
    }
  } else {
    // Fallback: Use TIME_ERROR if time sync fails
    sensorData.timestamp = "TIME_ERROR";
  }
}

void collectSensorData() {
  if (components.dht22) {
    sensorData.temperature = dht.readTemperature();
    sensorData.humidity = dht.readHumidity();
    if (isnan(sensorData.temperature) || isnan(sensorData.humidity)) {
      sensorData.temperature = 0.0;
      sensorData.humidity = 0.0;
    }
  }
  if (components.mq137 && mq137Active) {
    int rawValue = analogRead(MQ137_PIN);
    sensorData.ammonia = map(rawValue, 0, 1023, 0, 100);
  } else {
    // Sensor not configured or detected as offline
    sensorData.ammonia = 0.0;
  }
  if (components.amg8833) {
    float pixels[AMG88xx_PIXEL_ARRAY_SIZE];
    // Try to read pixels from thermal camera
    amg.readPixels(pixels);
    
    // Calculate average temperature
    float sum = 0;
    for (int i = 0; i < AMG88xx_PIXEL_ARRAY_SIZE; i++) {
      sum += pixels[i];
    }
    sensorData.thermalTemp = sum / AMG88xx_PIXEL_ARRAY_SIZE;
    
    // Debug: Print thermal temperature every 5 seconds
    static unsigned long lastThermalDebug = 0;
    if (millis() - lastThermalDebug >= 5000) {
      Serial.println();
      Serial.print("DEBUG - Thermal temp: "); Serial.print(sensorData.thermalTemp); Serial.println("°C");
      Serial.println("==================================================");
      lastThermalDebug = millis();
    }
  } else {
    // Thermal camera not configured
    sensorData.thermalTemp = 0.0;
  }
}

void processControlLogic() {
  // Safety logic: Only enforce extreme temperature limits in MANUAL mode
  // Allow manual control for moderate temperatures, but prevent dangerous overheating
  if (currentMode == "MANUAL") {
    // Only turn OFF heat if temperature is dangerously high (>35°C)
    if (sensorData.temperature > 35.0) {
      if (heatStatus) {
        heatStatus = false;
        Serial.println("⚠️ SAFETY: Heat turned OFF - dangerously high temperature (" + String(sensorData.temperature) + "°C)");
      }
    }
  }
  
  // Only apply automatic control logic if in AUTO mode
  if (currentMode == "AUTO") {
    bool tempTriggeredPump = false;
    bool ammoniaTriggeredPump = false;
    bool heatTriggered = false;
    
    // Automatic pump control based on temperature and ammonia
    if (sensorData.temperature > TEMP_HIGH_THRESHOLD) {
      pumpStatus = true;
      tempTriggeredPump = true;
    }
    if (sensorData.ammonia > AMMONIA_THRESHOLD) {
      pumpStatus = true;
      ammoniaTriggeredPump = true;
    }
    
    // Automatic heat control based on temperature
    if (sensorData.temperature < TEMP_LOW_THRESHOLD) {
      heatStatus = true;
      heatTriggered = true;
    }
    
    // Turn off pump if no triggers
    if (!tempTriggeredPump && !ammoniaTriggeredPump) {
      pumpStatus = false;
    }
    
    // Turn off heat if no trigger
    if (!heatTriggered) {
      heatStatus = false;
    }
    
    // Don't change currentMode here - keep it as "AUTO" for toggle logic
  }
  // In MANUAL mode, pump and heat status are controlled by user via dashboard
  // BUT extreme safety limits are still enforced above
  
  // Apply the current pump and heat status to relays
  digitalWrite(RELAY_PUMP_PIN, pumpStatus ? HIGH : LOW);
  digitalWrite(RELAY_HEAT_PIN, heatStatus ? HIGH : LOW);
  
  // Update LCD display when status changes
  displayLCD();
}

void displaySerialMonitor() {
  Serial.println("==================================================");
  Serial.print("Timestamp: ");
  Serial.println(sensorData.timestamp);
  Serial.print("Temperature: ");
  Serial.print(sensorData.temperature);
  Serial.println("°C");
  Serial.print("Humidity: ");
  Serial.print(sensorData.humidity);
  Serial.println("%");
  Serial.print("Ammonia: ");
  Serial.print(sensorData.ammonia);
  Serial.println(" PPM");
  Serial.print("Thermal Temp: ");
  Serial.print(sensorData.thermalTemp);
  Serial.println("°C");
  Serial.print("Mode: ");
  Serial.println(currentMode);
  Serial.print("Water Sprinkler Status: ");
  Serial.println(pumpStatus ? "ON" : "OFF");
  Serial.print("Heat Bulb Status: ");
  Serial.println(heatStatus ? "ON" : "OFF");
  Serial.println("==================================================");
}

void displayLCD() {
  if (!components.lcd) return;
  
  lcd.clear();
  
  // First line: Sensor data
  lcd.setCursor(0, 0);
  lcd.print("T:");
  lcd.print(sensorData.temperature, 1);
  lcd.print("|H:");
  lcd.print(sensorData.humidity, 0);
  lcd.print("|A:");
  lcd.print(sensorData.ammonia, 0);
  
  // Second line: Status message
  lcd.setCursor(0, 1);
  String statusMessage = getLCDStatusMessage();
  lcd.print(statusMessage);
}

String getLCDStatusMessage() {
  // Check if both pump and heat are on
  if (pumpStatus && heatStatus) {
    return "HEAT & SPRINKLER";
  }
  
  // Check if both pump and heat are off
  if (!pumpStatus && !heatStatus) {
    return "----ALL OFF----";
  }
  
  // Check pump status and triggers
  if (pumpStatus) {
    // Check if in MANUAL mode for manual control indication
    if (currentMode == "MANUAL") {
      return "SPRINKLER: MANUAL";
    }
    // Check what triggered the pump in AUTO mode
    else if (sensorData.temperature > TEMP_HIGH_THRESHOLD) {
      return "SPRINKLER: TEMP";
    } else if (sensorData.ammonia > AMMONIA_THRESHOLD) {
      return "SPRINKLER: NH3";
    } else {
      return "SPRINKLER: AUTO";
    }
  }
  
  // Check heat status
  if (heatStatus) {
    // Check if in MANUAL mode for manual control indication
    if (currentMode == "MANUAL") {
      return "HEAT ON: MANUAL";
    }
    // Check what triggered the heat in AUTO mode
    else if (sensorData.temperature < TEMP_LOW_THRESHOLD) {
      return "HEAT ON: TEMP";
    } else {
      return "HEAT ON: AUTO";
    }
  }
  
  // Default fallback
  return currentMode;
}

void logToSDCard() {
  if (!components.sdCard) return;
  File dataFile = SD.open("swine_farm_log.txt", FILE_WRITE);
  if (dataFile) {
    dataFile.print(sensorData.timestamp);
    dataFile.print(",");
    dataFile.print(sensorData.temperature);
    dataFile.print(",");
    dataFile.print(sensorData.humidity);
    dataFile.print(",");
    dataFile.print(sensorData.ammonia);
    dataFile.print(",");
    dataFile.print(sensorData.thermalTemp);
    dataFile.print(",");
    dataFile.print(pumpStatus ? "ON" : "OFF");
    dataFile.print(",");
    dataFile.print(heatStatus ? "ON" : "OFF");
    dataFile.print(",");
    dataFile.println(currentMode);
    dataFile.close();
  }
}

void manualPumpControl(bool state) {
  pumpStatus = state;
  digitalWrite(RELAY_PUMP_PIN, state ? HIGH : LOW);
  Serial.println("Manual water sprinkler control: " + String(state ? "ON" : "OFF"));
}

void manualHeatControl(bool state) {
  heatStatus = state;
  digitalWrite(RELAY_HEAT_PIN, state ? HIGH : LOW);
  Serial.println("Manual heat control: " + String(state ? "ON" : "OFF"));
}

void processSerialCommands() {
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');
    command.trim();
    if (command == "PUMP_ON") {
      manualPumpControl(true);
    } else if (command == "PUMP_OFF") {
      manualPumpControl(false);
    } else if (command == "HEAT_ON") {
      manualHeatControl(true);
    } else if (command == "HEAT_OFF") {
      manualHeatControl(false);
    } else if (command == "STATUS") {
      displaySerialMonitor();
    } else if (command == "RESET") {
      pumpStatus = false;
      heatStatus = false;
      digitalWrite(RELAY_PUMP_PIN, LOW);
      digitalWrite(RELAY_HEAT_PIN, LOW);
      Serial.println("System reset - all devices OFF");
    } else if (command == "WIFI_SCAN") {
      scanWiFiNetworks();
    } else if (command == "WIFI_STATUS") {
      printWiFiStatus();
      if (WiFi.status() == WL_CONNECTED) {
        Serial.print("Connected to: ");
        Serial.println(WiFi.SSID());
        Serial.print("IP Address: ");
        Serial.println(WiFi.localIP());
        Serial.print("Signal Strength: ");
        Serial.print(WiFi.RSSI());
        Serial.println(" dBm");
      }
    } else if (command == "WIFI_RECONNECT") {
      Serial.println("Forcing WiFi reconnection...");
      WiFi.disconnect();
      delay(1000);
      connectToWiFi();
    } else if (command.startsWith("SET_TIME:")) {
      // Manual time setting: SET_TIME:2024,1,15,14,30,0
      String timeStr = command.substring(9);
      int comma1 = timeStr.indexOf(',');
      int comma2 = timeStr.indexOf(',', comma1 + 1);
      int comma3 = timeStr.indexOf(',', comma2 + 1);
      int comma4 = timeStr.indexOf(',', comma3 + 1);
      int comma5 = timeStr.indexOf(',', comma4 + 1);
      
      if (comma1 != -1 && comma2 != -1 && comma3 != -1 && comma4 != -1 && comma5 != -1) {
        int year = timeStr.substring(0, comma1).toInt();
        int month = timeStr.substring(comma1 + 1, comma2).toInt();
        int day = timeStr.substring(comma2 + 1, comma3).toInt();
        int hour = timeStr.substring(comma3 + 1, comma4).toInt();
        int minute = timeStr.substring(comma4 + 1, comma5).toInt();
        int second = timeStr.substring(comma5 + 1).toInt();
        
        setManualTime(year, month, day, hour, minute, second);
        Serial.println("✓ Time set manually");
      } else {
        Serial.println("Invalid time format. Use: SET_TIME:2024,1,15,14,30,0");
      }
    } else if (command == "SYNC_TIME") {
      Serial.println("Forcing immediate time sync...");
      attemptTimeSync();
    } else {
      Serial.println("Unknown command: " + command);
      Serial.println("Available commands: PUMP_ON, PUMP_OFF, HEAT_ON, HEAT_OFF, STATUS, RESET, WIFI_SCAN, WIFI_STATUS, WIFI_RECONNECT, SET_TIME:YYYY,M,D,H,M,S, SYNC_TIME");
    }
  }
}

void scanWiFiNetworks() {
  Serial.println("Scanning for available WiFi networks...");
  int networksFound = WiFi.scanNetworks();
  
  if (networksFound == 0) {
    Serial.println("No networks found");
  } else {
    Serial.print("Found ");
    Serial.print(networksFound);
    Serial.println(" networks:");
    
    for (int i = 0; i < networksFound; i++) {
      Serial.print(i + 1);
      Serial.print(": ");
      Serial.print(WiFi.SSID(i));
      Serial.print(" (");
      Serial.print(WiFi.RSSI(i));
      Serial.print(" dBm) ");
      Serial.print("Encryption: ");
      Serial.println(WiFi.encryptionType(i));
    }
  }
}

bool checkComponentStatus() {
  Serial.println("=== COMPONENT STATUS CHECK (Every 5 seconds) ===");
  
  // Check DHT22 status
  bool dht22Working = components.dht22 && !isnan(dht.readTemperature()) && !isnan(dht.readHumidity());
  dht22Active = dht22Working;
  Serial.print("DHT22 Temp/Humidity: ");
  Serial.println(dht22Working ? "✓ ACTIVE" : "✗ OFFLINE");
  
  // Check MQ137 status (ammonia sensor)
  // Improved detection: check for sensor disconnection patterns
  bool mq137Working = false;
  int samples[10];
  int zeroCount = 0;
  int maxValue = 0;
  int minValue = 1023;
  int stableValue = 0;
  
  // Declare disconnection pattern variables outside the if block
  bool allZero = false;
  bool allSame = false;
  bool stuckAtMax = false;
  bool veryUnstable = false;
  
  if (components.mq137) {
    // Read multiple samples to detect if sensor is actually connected
    for (int i = 0; i < 10; i++) {
      samples[i] = analogRead(MQ137_PIN);
      if (samples[i] == 0) zeroCount++;
      if (samples[i] > maxValue) maxValue = samples[i];
      if (samples[i] < minValue) minValue = samples[i];
      delay(10);
    }
    
    // Check for disconnection patterns:
    // 1. All readings are 0 (sensor completely disconnected)
    // 2. All readings are identical (sensor stuck at one value)
    // 3. Readings are at maximum (1023) - sensor disconnected but pin floating high
    // 4. Readings are very unstable (huge variations) - poor connection
    
    allZero = (zeroCount == 10);
    allSame = (maxValue == minValue);
    stuckAtMax = (maxValue >= 1020); // Near maximum ADC value
    veryUnstable = ((maxValue - minValue) > 800); // Huge variation indicates poor connection
    
    // Sensor is working if it shows reasonable variation and not stuck at extremes
    if (!allZero && !allSame && !stuckAtMax && !veryUnstable) {
      mq137Working = true;
    } else {
      mq137Working = false;
    }
  }
  
  mq137Active = mq137Working;
  Serial.print("MQ137 Ammonia Sensor: ");
  if (mq137Working) {
    Serial.println("✓ ACTIVE");
  } else {
    Serial.println("✗ OFFLINE");
    if (components.mq137) {
      float ammoniaValue = map(samples[9], 0, 1023, 0, 100);
      Serial.print("  → Ammonia level: "); Serial.print(ammoniaValue); Serial.println(" ppm");
      Serial.print("  → Raw ADC reading: "); Serial.println(samples[9]);
      Serial.print("  → Min reading: "); Serial.print(minValue); Serial.print(", Max reading: "); Serial.println(maxValue);
      
      if (allZero) {
        Serial.println("  → Sensor detected as offline: All readings are 0 (completely disconnected)");
      } else if (allSame) {
        Serial.println("  → Sensor detected as offline: All readings identical (sensor stuck)");
      } else if (stuckAtMax) {
        Serial.println("  → Sensor detected as offline: Readings stuck at maximum (pin floating high)");
      } else if (veryUnstable) {
        Serial.println("  → Sensor detected as offline: Very unstable readings (poor connection)");
      }
    } else {
      Serial.println("  → Sensor not configured in components");
    }
  }
  
  // Check AMG8833 status (thermal camera)
  bool amg8833Working = false;
  
  // Always check thermal camera status regardless of initialization flag
  // This allows detection of disconnection even after startup
  if (components.amg8833) {
    // Ultra-strict detection for thermal camera:
    // Only consider it active if temperature is in a very narrow realistic range
    // This prevents false positives when sensor is disconnected but still returning values
    
    if (sensorData.thermalTemp <= 5.0) {
      amg8833Working = false; // Temperature <= 5°C means disconnected
    } else if (sensorData.thermalTemp >= 20 && sensorData.thermalTemp <= 40) {
      amg8833Working = true; // Very narrow realistic room temperature range
    } else {
      amg8833Working = false; // Everything else is considered offline
    }
  } else {
    // Thermal camera was never initialized
    amg8833Working = false;
  }
  amg8833Active = amg8833Working;
  Serial.print("AMG8833 Thermal Camera: ");
  if (amg8833Working) {
    Serial.println("✓ ACTIVE");
  } else {
    Serial.println("✗ OFFLINE");
    if (components.amg8833) {
      Serial.print("  → Thermal temperature: "); Serial.print(sensorData.thermalTemp); Serial.println("°C");
      if (sensorData.thermalTemp <= 5.0) {
        Serial.println("  → Sensor detected as offline because temperature <= 5°C (likely disconnected)");
      } else {
        Serial.println("  → Sensor detected as offline because temperature out of ultra-strict range (20-40°C)");
      }
    } else {
      Serial.println("  → Sensor not configured in components");
    }
  }
  
  // Check SD Card status
  bool sdCardWorking = components.sdCard && SD.exists("swine_farm_log.txt");
  sdCardActive = sdCardWorking;
  Serial.print("SD Card Module: ");
  Serial.println(sdCardWorking ? "✓ ACTIVE" : "✗ OFFLINE");
  
  // Check Time Client status
  bool timeWorking = components.ntp && timeInitialized;
  ntpActive = timeWorking;
  Serial.print("Time Client: ");
  Serial.println(timeWorking ? "✓ ACTIVE" : "✗ OFFLINE");
  
  // Summary
  int activeComponents = (dht22Active ? 1 : 0) + (mq137Active ? 1 : 0) + 
                        (amg8833Active ? 1 : 0) + (sdCardActive ? 1 : 0) + 
                        (ntpActive ? 1 : 0);
  Serial.print("Active Components: ");
  Serial.print(activeComponents);
  Serial.println("/5");
  Serial.println("==================================================");
  
  return true;
}

void sendDataToWebApp() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected, storing data offline");
    storeDataOffline();
    webAppOnline = false;
    return;
  }
  
  // Prepare JSON data with timestamp
  String jsonData = "{";
  jsonData += "\"timestamp\":\"" + sensorData.timestamp + "\",";
  jsonData += "\"temp\":" + String(sensorData.temperature, 1) + ",";
  jsonData += "\"hum\":" + String(sensorData.humidity, 1) + ",";
  jsonData += "\"ammonia\":" + String(sensorData.ammonia, 1) + ",";
  jsonData += "\"thermal\":" + String(sensorData.thermalTemp, 1) + ",";
  jsonData += "\"pump_temp\":\"" + String(pumpStatus ? "ON" : "OFF") + "\",";
  jsonData += "\"pump_trigger\":\"" + String(pumpStatus ? "AUTO" : "NONE") + "\",";
  jsonData += "\"heat\":\"" + String(heatStatus ? "ON" : "OFF") + "\",";
  jsonData += "\"mode\":\"" + currentMode + "\",";
  jsonData += "\"components\":{";
  jsonData += "\"temp_humidity_sensor\":\"" + String(dht22Active ? "active" : "offline") + "\",";
  jsonData += "\"ammonia_sensor\":\"" + String(mq137Active ? "active" : "offline") + "\",";
  jsonData += "\"thermal_camera\":\"" + String(amg8833Active ? "active" : "offline") + "\",";
  jsonData += "\"sd_card_module\":\"" + String(sdCardActive ? "active" : "offline") + "\",";
  jsonData += "\"ntp_client\":\"" + String(ntpActive ? "active" : "offline") + "\"";
  jsonData += "}";
  jsonData += "}";
  
  Serial.println("=== SENDING SENSOR DATA TO WEB APP (every 1 second) ===");
  Serial.println();
  Serial.println("DATA: " + jsonData);
  Serial.println();
  
  // Connect to server
  if (wifiClient.connect(serverHost, serverPort)) {
    Serial.println("Connected to web app server");
    webAppOnline = true;
    
    // Send HTTP POST request
    wifiClient.println("POST " + String(serverPath) + " HTTP/1.1");
    wifiClient.println("Host: " + String(serverHost));
    wifiClient.println("Content-Type: application/json");
    wifiClient.println("Content-Length: " + String(jsonData.length()));
    wifiClient.println("Connection: close");
    wifiClient.println();
    wifiClient.println(jsonData);
    
    // Wait for response
    unsigned long timeout = millis();
    while (wifiClient.connected() && millis() - timeout < 5000) {
      if (wifiClient.available()) {
        String response = wifiClient.readStringUntil('\n');
        Serial.println("Response:");
        Serial.println(response);
        break;
      }
    }
    
    wifiClient.stop();
    Serial.println();
    Serial.println("DATA SENT SUCCESSFULLY TO THE WEB APP");
    Serial.println("==================================================");
    
    // If we have offline data, try to sync it
    if (offlineDataCount > 0) {
      syncOfflineData();
    }
  } else {
    Serial.println("✗ Failed to connect to web app server");
    storeDataOffline();
    webAppOnline = false;
  }
}

// Store data offline when web app is unavailable
void storeDataOffline() {
  if (offlineDataCount >= 100) {
    Serial.println("Offline storage full! Cannot store more data.");
    return;
  }
  
  offlineData[offlineDataCount].timestamp = sensorData.timestamp;
  offlineData[offlineDataCount].temperature = sensorData.temperature;
  offlineData[offlineDataCount].humidity = sensorData.humidity;
  offlineData[offlineDataCount].ammonia = sensorData.ammonia;
  offlineData[offlineDataCount].thermalTemp = sensorData.thermalTemp;
  offlineData[offlineDataCount].pumpStatus = pumpStatus ? "ON" : "OFF";
  offlineData[offlineDataCount].heatStatus = heatStatus ? "ON" : "OFF";
  offlineData[offlineDataCount].mode = currentMode;
  
  offlineDataCount++;
  Serial.println("Data stored offline. Count: " + String(offlineDataCount));
}

// Sync offline data when web app comes back online
void syncOfflineData() {
  if (offlineDataCount == 0) return;
  
  Serial.println("Syncing " + String(offlineDataCount) + " offline records...");
  
  for (int i = 0; i < offlineDataCount; i++) {
    // Prepare JSON data for offline record
    String jsonData = "{";
    jsonData += "\"timestamp\":\"" + offlineData[i].timestamp + "\",";
    jsonData += "\"temp\":" + String(offlineData[i].temperature, 1) + ",";
    jsonData += "\"hum\":" + String(offlineData[i].humidity, 1) + ",";
    jsonData += "\"ammonia\":" + String(offlineData[i].ammonia, 1) + ",";
    jsonData += "\"thermal\":" + String(offlineData[i].thermalTemp, 1) + ",";
    jsonData += "\"pump_temp\":\"" + offlineData[i].pumpStatus + "\",";
    jsonData += "\"pump_trigger\":\"OFFLINE_SYNC\",";
    jsonData += "\"heat\":\"" + offlineData[i].heatStatus + "\",";
    jsonData += "\"mode\":\"" + offlineData[i].mode + "\"";
    jsonData += "}";
    
    // Send offline data to web app
    WiFiClient syncClient;
    if (syncClient.connect(serverHost, serverPort)) {
      syncClient.println("POST " + String(serverPath) + " HTTP/1.1");
      syncClient.println("Host: " + String(serverHost));
      syncClient.println("Content-Type: application/json");
      syncClient.println("Content-Length: " + String(jsonData.length()));
      syncClient.println("Connection: close");
      syncClient.println();
      syncClient.println(jsonData);
      
      // Wait for response
      unsigned long timeout = millis();
      while (syncClient.connected() && millis() - timeout < 3000) {
        if (syncClient.available()) {
          syncClient.readStringUntil('\n');
          break;
        }
      }
      syncClient.stop();
      
      Serial.println("Synced offline record " + String(i + 1) + "/" + String(offlineDataCount));
      delay(100); // Small delay between requests
    } else {
      Serial.println("Failed to sync offline record " + String(i + 1));
      break; // Stop syncing if connection fails
    }
  }
  
  // Clear offline data after successful sync
  offlineDataCount = 0;
  Serial.println("✓ All offline data synced successfully!");
}

void syncWithWebAppState() {
  if (WiFi.status() != WL_CONNECTED) {
    return; // Skip sync if WiFi is not connected
  }
  
  Serial.println("=== Syncing with Web App State (Every 10 seconds) ===");
  
  // Create HTTP client for web app communication
  WiFiClient syncClient;
  
  if (syncClient.connect(serverHost, serverPort)) {
    // Request current state from web app
    String request = "GET /SWIFT/NEW_SWIFT/php/get_latest_sensor_data.php HTTP/1.1\r\n";
    request += "Host: " + String(serverHost) + "\r\n";
    request += "Connection: close\r\n\r\n";
    
    syncClient.print(request);
    
    // Wait for response
    unsigned long timeout = millis();
    while (syncClient.connected() && millis() - timeout < 5000) {
      if (syncClient.available()) {
        String response = syncClient.readStringUntil('\n');
        
        // Look for JSON data in response
        if (response.indexOf("{") != -1) {
          String jsonData = response;
          while (syncClient.available()) {
            jsonData += syncClient.readStringUntil('\n');
          }
          
          // Parse JSON response (simplified parsing)
          if (jsonData.indexOf("\"mode\":\"AUTO\"") != -1 && currentMode != "AUTO") {
            currentMode = "AUTO";
            Serial.println("✓ Mode synced to AUTO from web app");
            displayLCD();
          } else if (jsonData.indexOf("\"mode\":\"MANUAL\"") != -1 && currentMode != "MANUAL") {
            currentMode = "MANUAL";
            Serial.println("✓ Mode synced to MANUAL from web app");
            displayLCD();
          }
          
          // Sync pump status
          if (jsonData.indexOf("\"pump_temp\":\"ON\"") != -1 && !pumpStatus) {
            pumpStatus = true;
            digitalWrite(RELAY_PUMP_PIN, HIGH);
            Serial.println("✓ Pump synced to ON from web app");
          } else if (jsonData.indexOf("\"pump_temp\":\"OFF\"") != -1 && pumpStatus) {
            pumpStatus = false;
            digitalWrite(RELAY_PUMP_PIN, LOW);
            Serial.println("✓ Pump synced to OFF from web app");
          }
          
          // Sync heat status
          if (jsonData.indexOf("\"heat\":\"ON\"") != -1 && !heatStatus) {
            heatStatus = true;
            digitalWrite(RELAY_HEAT_PIN, HIGH);
            Serial.println("✓ Heat synced to ON from web app");
          } else if (jsonData.indexOf("\"heat\":\"OFF\"") != -1 && heatStatus) {
            heatStatus = false;
            digitalWrite(RELAY_HEAT_PIN, LOW);
            Serial.println("✓ Heat synced to OFF from web app");
          }
          
          break;
        }
      }
    }
    
    syncClient.stop();
    Serial.println("✓ Web app state sync completed");
  } else {
    Serial.println("✗ Failed to connect to web app for state sync");
  }
}

void handleWebServerRequests() {
  WiFiClient client = server.available();
  
  if (client) {
    Serial.println("New client connected for live data");
    String request = "";
    
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        request += c;
        
        if (c == '\n') {
          if (request.indexOf("GET /data") != -1) {
            // Serve live sensor data as JSON
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: application/json");
            client.println("Access-Control-Allow-Origin: *");
            client.println("Connection: close");
            client.println();
            
            // Create JSON response with current sensor data
            client.print("{");
            client.print("\"temp\":");
            client.print(sensorData.temperature);
            client.print(",\"hum\":");
            client.print(sensorData.humidity);
            client.print(",\"ammonia\":");
            client.print(sensorData.ammonia);
            client.print(",\"pump_temp\":\"");
            client.print(pumpStatus ? "ON" : "OFF");
            client.print("\",\"pump_trigger\":\"AUTO\"");
            client.print(",\"heat\":\"");
            client.print(heatStatus ? "ON" : "OFF");
            client.print("\",\"mode\":\"");
            client.print(currentMode);
            client.print("\",\"timestamp\":\"");
            client.print(sensorData.timestamp);
            client.print("\",\"thermal\":");
            client.print(sensorData.thermalTemp);
            client.print(",");
            client.print("\"components\":{");
            client.print("\"temp_humidity_sensor\":\"" + String(dht22Active ? "active" : "offline") + "\",");
            client.print("\"ammonia_sensor\":\"" + String(mq137Active ? "active" : "offline") + "\",");
            client.print("\"thermal_camera\":\"" + String(amg8833Active ? "active" : "offline") + "\",");
            client.print("\"sd_card_module\":\"" + String(sdCardActive ? "active" : "offline") + "\",");
            client.print("\"ntp_client\":\"" + String(ntpActive ? "active" : "offline") + "\"");
            client.print("}");
            client.println("}");
            
            Serial.println("✓ Live data served to dashboard");
            break;
          } else if (request.indexOf("GET /togglepump") != -1) {
            // Toggle pump control (only in MANUAL mode)
            if (currentMode == "MANUAL" || currentMode == "INIT") {
              pumpStatus = !pumpStatus;
              digitalWrite(RELAY_PUMP_PIN, pumpStatus ? HIGH : LOW);
              
              // Update LCD display
              displayLCD();
              
              client.println("HTTP/1.1 200 OK");
              client.println("Content-Type: application/json");
              client.println("Access-Control-Allow-Origin: *");
              client.println("Connection: close");
              client.println();
            client.print("{\"status\":\"success\",\"pump\":\"");
            client.print(pumpStatus ? "ON" : "OFF");
            client.println("\"}");
            
            Serial.println("✓ Water sprinkler toggled manually: " + String(pumpStatus ? "ON" : "OFF"));
            } else {
              client.println("HTTP/1.1 403 Forbidden");
              client.println("Content-Type: application/json");
              client.println("Access-Control-Allow-Origin: *");
              client.println("Connection: close");
              client.println();
              client.println("{\"status\":\"error\",\"message\":\"Water sprinkler control only available in MANUAL mode\"}");
              
              Serial.println("✗ Water sprinkler control blocked - not in MANUAL mode");
            }
            break;
          } else if (request.indexOf("GET /toggleheat") != -1) {
            // Toggle heat control (only in MANUAL mode)
            if (currentMode == "MANUAL" || currentMode == "INIT") {
              heatStatus = !heatStatus;
              digitalWrite(RELAY_HEAT_PIN, heatStatus ? HIGH : LOW);
              
              // Update LCD display
              displayLCD();
              
              client.println("HTTP/1.1 200 OK");
              client.println("Content-Type: application/json");
              client.println("Access-Control-Allow-Origin: *");
              client.println("Connection: close");
              client.println();
              client.print("{\"status\":\"success\",\"heat\":\"");
              client.print(heatStatus ? "ON" : "OFF");
              client.println("\"}");
              
              Serial.println("✓ Heat toggled manually: " + String(heatStatus ? "ON" : "OFF"));
            } else {
              client.println("HTTP/1.1 403 Forbidden");
              client.println("Content-Type: application/json");
              client.println("Access-Control-Allow-Origin: *");
              client.println("Connection: close");
              client.println();
              client.println("{\"status\":\"error\",\"message\":\"Heat control only available in MANUAL mode\"}");
              
              Serial.println("✗ Heat control blocked - not in MANUAL mode");
            }
            break;
          } else if (request.indexOf("GET /togglemode") != -1) {
            // Toggle mode between MANUAL and AUTO
            if (currentMode == "MANUAL" || currentMode == "INIT") {
              currentMode = "AUTO";
            } else {
              currentMode = "MANUAL";
            }
            
            // Update LCD display
            displayLCD();
            
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: application/json");
            client.println("Access-Control-Allow-Origin: *");
            client.println("Connection: close");
            client.println();
            client.print("{\"status\":\"success\",\"mode\":\"");
            client.print(currentMode);
            client.println("\"}");
            
            Serial.println("✓ Mode toggled: " + currentMode);
            break;
          } else if (request.indexOf("GET /status") != -1) {
            // Return current device status and settings
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: application/json");
            client.println("Access-Control-Allow-Origin: *");
            client.println("Connection: close");
            client.println();
            
            client.print("{");
            client.print("\"status\":\"success\",");
            client.print("\"device_ip\":\"" + WiFi.localIP().toString() + "\",");
            client.print("\"mode\":\"" + currentMode + "\",");
            client.print("\"pump_status\":" + String(pumpStatus ? "true" : "false") + ",");
            client.print("\"heat_status\":" + String(heatStatus ? "true" : "false") + ",");
            client.print("\"system_initialized\":" + String(systemInitialized ? "true" : "false") + ",");
            client.print("\"wifi_connected\":" + String(WiFi.status() == WL_CONNECTED ? "true" : "false") + ",");
            client.print("\"components\":{");
            client.print("\"temp_humidity_sensor\":\"" + String(dht22Active ? "active" : "offline") + "\",");
            client.print("\"ammonia_sensor\":\"" + String(mq137Active ? "active" : "offline") + "\",");
            client.print("\"thermal_camera\":\"" + String(amg8833Active ? "active" : "offline") + "\",");
            client.print("\"sd_card_module\":\"" + String(sdCardActive ? "active" : "offline") + "\",");
            client.print("\"ntp_client\":\"" + String(ntpActive ? "active" : "offline") + "\"");
            client.print("},");
            client.print("\"thresholds\":{");
            client.print("\"temp_low\":" + String(TEMP_LOW_THRESHOLD) + ",");
            client.print("\"temp_high\":" + String(TEMP_HIGH_THRESHOLD) + ",");
            client.print("\"humidity_threshold\":" + String(HUMIDITY_THRESHOLD) + ",");
            client.print("\"ammonia_threshold\":" + String(AMMONIA_THRESHOLD));
            client.print("}");
            client.print("}");
            
            Serial.println("✓ Status requested - sent device state");
            break;
          } else if (request.indexOf("GET /setmode") != -1) {
            // Set mode directly (e.g., /setmode?mode=AUTO or /setmode?mode=MANUAL)
            int modeIndex = request.indexOf("mode=");
            if (modeIndex != -1) {
              String newMode = request.substring(modeIndex + 5);
              newMode.trim();
              
              if (newMode == "AUTO" || newMode == "MANUAL") {
                currentMode = newMode;
                displayLCD();
                
                client.println("HTTP/1.1 200 OK");
                client.println("Content-Type: application/json");
                client.println("Access-Control-Allow-Origin: *");
                client.println("Connection: close");
                client.println();
                client.print("{\"status\":\"success\",\"mode\":\"");
                client.print(currentMode);
                client.println("\"}");
                
                Serial.println("✓ Mode set to: " + currentMode);
              } else {
                client.println("HTTP/1.1 400 Bad Request");
                client.println("Content-Type: application/json");
                client.println("Connection: close");
                client.println();
                client.println("{\"status\":\"error\",\"message\":\"Invalid mode. Use AUTO or MANUAL\"}");
              }
            } else {
              client.println("HTTP/1.1 400 Bad Request");
              client.println("Content-Type: application/json");
              client.println("Connection: close");
              client.println();
              client.println("{\"status\":\"error\",\"message\":\"Missing mode parameter\"}");
            }
            break;
          } else if (request.indexOf("GET /setpump") != -1) {
            // Set pump status directly (only in MANUAL mode)
            if (currentMode == "MANUAL" || currentMode == "INIT") {
              int statusIndex = request.indexOf("status=");
              if (statusIndex != -1) {
                String newStatus = request.substring(statusIndex + 7);
                newStatus.trim();
                
                if (newStatus == "ON") {
                  pumpStatus = true;
                  digitalWrite(RELAY_PUMP_PIN, HIGH);
                  Serial.println("✓ Pump turned ON via web command");
                } else if (newStatus == "OFF") {
                  pumpStatus = false;
                  digitalWrite(RELAY_PUMP_PIN, LOW);
                  Serial.println("✓ Pump turned OFF via web command");
                } else {
                  client.println("HTTP/1.1 400 Bad Request");
                  client.println("Content-Type: application/json");
                  client.println("Connection: close");
                  client.println();
                  client.println("{\"status\":\"error\",\"message\":\"Invalid status. Use ON or OFF\"}");
                  break;
                }
                
                displayLCD();
                
                client.println("HTTP/1.1 200 OK");
                client.println("Content-Type: application/json");
                client.println("Access-Control-Allow-Origin: *");
                client.println("Connection: close");
                client.println();
                client.print("{\"status\":\"success\",\"pump\":\"");
                client.print(pumpStatus ? "ON" : "OFF");
                client.println("\"}");
              } else {
                client.println("HTTP/1.1 400 Bad Request");
                client.println("Content-Type: application/json");
                client.println("Connection: close");
                client.println();
                client.println("{\"status\":\"error\",\"message\":\"Missing status parameter\"}");
              }
            } else {
              client.println("HTTP/1.1 403 Forbidden");
              client.println("Content-Type: application/json");
              client.println("Access-Control-Allow-Origin: *");
              client.println("Connection: close");
              client.println();
              client.println("{\"status\":\"error\",\"message\":\"Pump control only available in MANUAL mode\"}");
              Serial.println("✗ Pump control blocked - not in MANUAL mode");
            }
            break;
          } else if (request.indexOf("GET /setheat") != -1) {
            // Set heat status directly (only in MANUAL mode)
            if (currentMode == "MANUAL" || currentMode == "INIT") {
              int statusIndex = request.indexOf("status=");
              if (statusIndex != -1) {
                String newStatus = request.substring(statusIndex + 7);
                newStatus.trim();
                
                if (newStatus == "ON") {
                  heatStatus = true;
                  digitalWrite(RELAY_HEAT_PIN, HIGH);
                  Serial.println("✓ Heat turned ON via web command");
                } else if (newStatus == "OFF") {
                  heatStatus = false;
                  digitalWrite(RELAY_HEAT_PIN, LOW);
                  Serial.println("✓ Heat turned OFF via web command");
                } else {
                  client.println("HTTP/1.1 400 Bad Request");
                  client.println("Content-Type: application/json");
                  client.println("Connection: close");
                  client.println();
                  client.println("{\"status\":\"error\",\"message\":\"Invalid status. Use ON or OFF\"}");
                  break;
                }
                
                displayLCD();
                
                client.println("HTTP/1.1 200 OK");
                client.println("Content-Type: application/json");
                client.println("Access-Control-Allow-Origin: *");
                client.println("Connection: close");
                client.println();
                client.print("{\"status\":\"success\",\"heat\":\"");
                client.print(heatStatus ? "ON" : "OFF");
                client.println("\"}");
              } else {
                client.println("HTTP/1.1 400 Bad Request");
                client.println("Content-Type: application/json");
                client.println("Connection: close");
                client.println();
                client.println("{\"status\":\"error\",\"message\":\"Missing status parameter\"}");
              }
            } else {
              client.println("HTTP/1.1 403 Forbidden");
              client.println("Content-Type: application/json");
              client.println("Access-Control-Allow-Origin: *");
              client.println("Connection: close");
              client.println();
              client.println("{\"status\":\"error\",\"message\":\"Heat control only available in MANUAL mode\"}");
              Serial.println("✗ Heat control blocked - not in MANUAL mode");
            }
            break;
          } else {
            // Serve basic info page
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: text/html");
            client.println("Connection: close");
            client.println();
            client.println("<html><body>");
            client.println("<h1>SWIFT IoT Device</h1>");
            client.println("<h2>Current Status</h2>");
            client.println("<p>Temperature: " + String(sensorData.temperature) + "°C</p>");
            client.println("<p>Humidity: " + String(sensorData.humidity) + "%</p>");
            client.println("<p>Ammonia: " + String(sensorData.ammonia) + " ppm</p>");
            client.println("<p>Water Sprinkler: " + String(pumpStatus ? "ON" : "OFF") + "</p>");
            client.println("<p>Heat: " + String(heatStatus ? "ON" : "OFF") + "</p>");
            client.println("<p>Mode: " + currentMode + "</p>");
            client.println("<h2>API Endpoints</h2>");
            client.println("<p><a href='/data'>/data</a> - Live sensor data (JSON)</p>");
            client.println("<p><a href='/status'>/status</a> - Device status and settings (JSON)</p>");
            client.println("<p><a href='/togglepump'>/togglepump</a> - Toggle water sprinkler ON/OFF</p>");
            client.println("<p><a href='/toggleheat'>/toggleheat</a> - Toggle heat ON/OFF</p>");
            client.println("<p><a href='/togglemode'>/togglemode</a> - Toggle AUTO/MANUAL mode</p>");
            client.println("<h2>Direct Control</h2>");
            client.println("<p><a href='/setpump?status=ON'>/setpump?status=ON</a> - Turn water sprinkler ON</p>");
            client.println("<p><a href='/setpump?status=OFF'>/setpump?status=OFF</a> - Turn water sprinkler OFF</p>");
            client.println("<p><a href='/setheat?status=ON'>/setheat?status=ON</a> - Turn heat ON</p>");
            client.println("<p><a href='/setheat?status=OFF'>/setheat?status=OFF</a> - Turn heat OFF</p>");
            client.println("<p><a href='/setmode?mode=AUTO'>/setmode?mode=AUTO</a> - Set AUTO mode</p>");
            client.println("<p><a href='/setmode?mode=MANUAL'>/setmode?mode=MANUAL</a> - Set MANUAL mode</p>");
            client.println("</body></html>");
            break;
          }
        }
      }
    }
    
    client.stop();
    Serial.println("Client disconnected");
  }
}

// Attempt time sync with retry logic
void attemptTimeSync() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected, skipping time sync");
    return;
  }
  
  Serial.println("Attempting time sync (attempt " + String(timeSyncRetryCount + 1) + "/" + String(MAX_TIME_SYNC_RETRIES) + ")");
  
  // Try WorldTimeAPI first
  if (syncTimeFromServer()) {
    components.ntp = true;
    timeInitialized = true;
    timeSyncRetryCount = 0; // Reset retry count on success
    Serial.println("✓ Time Client: OK");
    Serial.print("Current time: ");
    Serial.println(getFormattedTime());
    return;
  }
  
  // Fallback: Try local server
  Serial.println("WorldTimeAPI failed, trying local server...");
  if (syncTimeFromLocalServer()) {
    components.ntp = true;
    timeInitialized = true;
    timeSyncRetryCount = 0; // Reset retry count on success
    Serial.println("✓ Time Client: OK (Local Server)");
    Serial.print("Current time: ");
    Serial.println(getFormattedTime());
    return;
  }
  
  // All methods failed
  timeSyncRetryCount++;
  Serial.println("✗ Time sync failed (attempt " + String(timeSyncRetryCount) + "/" + String(MAX_TIME_SYNC_RETRIES) + ")");
  
  if (timeSyncRetryCount >= MAX_TIME_SYNC_RETRIES) {
    Serial.println("Max retries reached. Use manual time setting: SET_TIME:2024,1,15,14,30,0");
  }
}

// Time sync function
void updateNTPTime() {
  if (WiFi.status() == WL_CONNECTED) {
    if (timeInitialized) {
      // Update existing time sync
      if (syncTimeFromServer()) {
        Serial.println("✓ Time updated: " + getFormattedTime());
      } else {
        Serial.println("✗ Time update failed");
      }
    } else {
      // Try to initialize time sync
      attemptTimeSync();
    }
  } else {
    Serial.println("✗ Cannot update time - WiFi disconnected");
    components.ntp = false;
    timeInitialized = false;
  }
}

// Schedule checking function
void checkScheduledTasks() {
  if (!components.ntp || WiFi.status() != WL_CONNECTED) {
    Serial.println("Skipping schedule check - Time sync or WiFi not available");
    return;
  }
  
  // Get current time
  unsigned long currentTime = currentEpochTime + (millis() - lastTimeSync) / 1000;
  struct tm *ptm = gmtime((time_t *)&currentTime);
  
  int currentHour = ptm->tm_hour;
  int currentMinute = ptm->tm_min;
  int currentDayOfWeek = ptm->tm_wday; // 0=Sunday, 1=Monday, etc.
  
  // Convert to day names
  String dayNames[] = {"sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"};
  String currentDayName = dayNames[currentDayOfWeek];
  
  // Format current time for comparison
  String currentTimeStr = String(currentHour) + ":" + String(currentMinute);
  if (currentMinute < 10) {
    currentTimeStr = String(currentHour) + ":0" + String(currentMinute);
  }
  
  // Format current date
  char dateBuffer[11];
  sprintf(dateBuffer, "%04d-%02d-%02d", 
          ptm->tm_year + 1900, ptm->tm_mon + 1, ptm->tm_mday);
  String currentDate = String(dateBuffer);
  
  Serial.println("Checking schedules for " + currentTimeStr + " on " + currentDayName);
  
  // Check schedules via server API
  checkServerSchedules(currentTimeStr, currentDate, currentDayName);
}

// Check server schedules
void checkServerSchedules(String currentTime, String currentDate, String currentDay) {
  WiFiClient client;
  if (client.connect(serverHost, serverPort)) {
    String postData = "{\"current_time\":\"" + currentTime + "\",\"current_date\":\"" + currentDate + "\",\"current_day\":\"" + currentDay + "\"}";
    
    client.println("POST /SWIFT/NEW_SWIFT/php/api/v1/device_commands.php HTTP/1.1");
    client.println("Host: " + String(serverHost));
    client.println("Content-Type: application/json");
    client.println("Content-Length: " + String(postData.length()));
    client.println("Connection: close");
    client.println();
    client.print(postData);
    
    // Read response
    String response = "";
    while (client.connected()) {
      if (client.available()) {
        response += client.readString();
      }
    }
    client.stop();
    
    // Parse JSON response (simplified parsing)
    if (response.indexOf("\"pump_on\":true") != -1) {
      digitalWrite(RELAY_PUMP_PIN, HIGH);
      pumpStatus = true;
      Serial.println("✓ Pump activated by schedule");
    }
    
    if (response.indexOf("\"heat_on\":true") != -1) {
      digitalWrite(RELAY_HEAT_PIN, HIGH);
      heatStatus = true;
      Serial.println("✓ Heat activated by schedule");
    }
    
    if (response.indexOf("\"pump_off\":true") != -1) {
      digitalWrite(RELAY_PUMP_PIN, LOW);
      pumpStatus = false;
      Serial.println("✓ Pump deactivated by schedule");
    }
    
    if (response.indexOf("\"heat_off\":true") != -1) {
      digitalWrite(RELAY_HEAT_PIN, LOW);
      heatStatus = false;
      Serial.println("✓ Heat deactivated by schedule");
    }
  } else {
    Serial.println("Failed to connect to server for schedule check");
  }
}

// HTTP-based time sync function - More reliable and precise
bool syncTimeFromServer() {
  WiFiClient client;
  
  Serial.println("Attempting precise time sync from NTP server...");
  
  // Try multiple reliable time servers
  const char* timeServers[] = {
    "time.nist.gov",
    "time.google.com", 
    "pool.ntp.org",
    "time.windows.com"
  };
  
  for (int i = 0; i < 4; i++) {
    Serial.println("Trying server: " + String(timeServers[i]));
    
    if (client.connect(timeServers[i], 13)) { // NTP port 13
      Serial.println("Connected to " + String(timeServers[i]));
      
      // Read NTP time response
      String response = "";
      unsigned long timeout = millis() + 5000; // 5 second timeout
      
      while (client.connected() && millis() < timeout) {
        if (client.available()) {
          response += client.readString();
          if (response.length() > 100) break; // NTP response is short
        }
      }
      client.stop();
      
      Serial.println("NTP Response: " + response);
      
      // Parse NTP time format (e.g., "58873 24-01-15 14:30:25 00 0 0 123.4 UTC(NIST) *")
      if (response.length() > 20) {
        // Extract date and time from NTP response
        int dateStart = response.indexOf("24-");
        if (dateStart != -1) {
          String dateTime = response.substring(dateStart, dateStart + 17); // "24-01-15 14:30:25"
          
          Serial.println("Extracted datetime: " + dateTime);
          
          // Parse: "24-01-15 14:30:25"
          int year = 2000 + dateTime.substring(0, 2).toInt();
          int month = dateTime.substring(3, 5).toInt();
          int day = dateTime.substring(6, 8).toInt();
          int hour = dateTime.substring(9, 11).toInt();
          int minute = dateTime.substring(12, 14).toInt();
          int second = dateTime.substring(15, 17).toInt();
          
          Serial.println("Parsed: " + String(year) + "-" + String(month) + "-" + String(day) + " " + 
                        String(hour) + ":" + String(minute) + ":" + String(second));
          
          // Validate parsed values
          if (year >= 2024 && year <= 2030 && month >= 1 && month <= 12 && day >= 1 && day <= 31) {
            // Convert to epoch time
            struct tm timeinfo;
            timeinfo.tm_year = year - 1900;
            timeinfo.tm_mon = month - 1;
            timeinfo.tm_mday = day;
            timeinfo.tm_hour = hour;
            timeinfo.tm_min = minute;
            timeinfo.tm_sec = second;
            
            currentEpochTime = mktime(&timeinfo);
            
            // Validate epoch time result
            if (currentEpochTime != -1 && currentEpochTime > 1600000000 && currentEpochTime < 3000000000) { // Between 2020 and 2065
              lastTimeSync = millis();
              timeInitialized = true;
              
              Serial.println("✓ Precise time synced! Epoch: " + String(currentEpochTime));
              Serial.println("✓ Current time: " + getFormattedTime());
              return true;
            } else {
              Serial.println("✗ Invalid epoch time: " + String(currentEpochTime));
            }
          } else {
            Serial.println("✗ Invalid date values");
          }
        }
      }
    } else {
      Serial.println("✗ Failed to connect to " + String(timeServers[i]));
    }
    
    delay(1000); // Wait between attempts
  }
  
  Serial.println("✗ All NTP servers failed, trying WorldTimeAPI...");
  
  // Fallback to WorldTimeAPI
  if (client.connect("worldtimeapi.org", 80)) {
    Serial.println("Connected to WorldTimeAPI");
    
    client.println("GET /api/timezone/Asia/Manila HTTP/1.1");
    client.println("Host: worldtimeapi.org");
    client.println("Connection: close");
    client.println();
    
    String response = "";
    unsigned long timeout = millis() + 10000; // 10 second timeout
    
    while (client.connected() && millis() < timeout) {
      if (client.available()) {
        response += client.readString();
        if (response.length() > 2000) break; // Prevent memory overflow
      }
    }
    client.stop();
    
    Serial.println("WorldTimeAPI response length: " + String(response.length()));
    
    // Parse JSON response for datetime
    int datetimeIndex = response.indexOf("\"datetime\":\"");
    if (datetimeIndex != -1) {
      int startIndex = datetimeIndex + 12;
      int endIndex = response.indexOf("\"", startIndex);
      String datetime = response.substring(startIndex, endIndex);
      
      Serial.println("Found datetime: " + datetime);
      
      // Parse datetime: 2024-01-15T14:30:25.123456+08:00
      if (datetime.length() >= 19) {
        int year = datetime.substring(0, 4).toInt();
        int month = datetime.substring(5, 7).toInt();
        int day = datetime.substring(8, 10).toInt();
        int hour = datetime.substring(11, 13).toInt();
        int minute = datetime.substring(14, 16).toInt();
        int second = datetime.substring(17, 19).toInt();
        
        Serial.println("Parsed time: " + String(year) + "-" + String(month) + "-" + String(day) + " " + 
                      String(hour) + ":" + String(minute) + ":" + String(second));
        
        // Validate parsed values
        if (year >= 2024 && year <= 2030 && month >= 1 && month <= 12 && day >= 1 && day <= 31) {
          // Convert to epoch time
          struct tm timeinfo;
          timeinfo.tm_year = year - 1900;
          timeinfo.tm_mon = month - 1;
          timeinfo.tm_mday = day;
          timeinfo.tm_hour = hour;
          timeinfo.tm_min = minute;
          timeinfo.tm_sec = second;
          
          currentEpochTime = mktime(&timeinfo);
          
          // Validate epoch time result
          if (currentEpochTime != -1 && currentEpochTime > 1600000000 && currentEpochTime < 3000000000) { // Between 2020 and 2065
            lastTimeSync = millis();
            timeInitialized = true;
            
            Serial.println("✓ Time synced from WorldTimeAPI! Epoch: " + String(currentEpochTime));
            Serial.println("✓ Current time: " + getFormattedTime());
            return true;
          } else {
            Serial.println("✗ Invalid epoch time: " + String(currentEpochTime));
          }
        } else {
          Serial.println("✗ Invalid date values");
        }
      } else {
        Serial.println("✗ Datetime string too short: " + datetime);
      }
    } else {
      Serial.println("✗ Datetime not found in response");
    }
  } else {
    Serial.println("✗ Failed to connect to WorldTimeAPI");
  }
  
  Serial.println("✗ All time sync methods failed");
  return false;
}

// Get formatted time string
String getFormattedTime() {
  if (timeInitialized) {
    unsigned long currentTime = currentEpochTime + (millis() - lastTimeSync) / 1000;
    
    // Validate epoch time
    if (currentTime > 1000000000 && currentTime < 3000000000) {
      return formatEpochToDDMMYYYY(currentTime);
    } else {
      return "TIME_ERROR";
    }
  }
  return "TIME_ERROR";
}

// Custom epoch to DD/MM/YYYY HH:MM:SS conversion (reliable for Arduino UNO R4 WiFi)
String formatEpochToDDMMYYYY(unsigned long epoch) {
  // Apply Philippines timezone offset (UTC+8)
  const int TIMEZONE_OFFSET_HOURS = 8;
  epoch += (TIMEZONE_OFFSET_HOURS * 3600); // Add 8 hours in seconds
  
  // Constants for time calculation
  const unsigned long SECONDS_PER_MINUTE = 60;
  const unsigned long SECONDS_PER_HOUR = 3600;
  const unsigned long SECONDS_PER_DAY = 86400;
  const unsigned long SECONDS_PER_YEAR = 31536000; // 365 days
  const unsigned long SECONDS_PER_LEAP_YEAR = 31622400; // 366 days
  
  // Calculate year
  unsigned long remainingSeconds = epoch;
  int year = 1970; // Unix epoch starts at 1970
  
  while (remainingSeconds >= SECONDS_PER_YEAR) {
    // Check if current year is a leap year
    bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    unsigned long yearSeconds = isLeapYear ? SECONDS_PER_LEAP_YEAR : SECONDS_PER_YEAR;
    
    if (remainingSeconds >= yearSeconds) {
      remainingSeconds -= yearSeconds;
      year++;
    } else {
      break;
    }
  }
  
  // Calculate month and day
  int month = 1;
  int day = 1;
  
  // Days in each month
  int daysInMonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
  
  // Check if current year is a leap year
  bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  if (isLeapYear) {
    daysInMonth[1] = 29; // February has 29 days in leap year
  }
  
  // Calculate month
  while (month <= 12 && remainingSeconds >= (daysInMonth[month-1] * SECONDS_PER_DAY)) {
    remainingSeconds -= daysInMonth[month-1] * SECONDS_PER_DAY;
    month++;
  }
  
  // Calculate day
  day += remainingSeconds / SECONDS_PER_DAY;
  remainingSeconds %= SECONDS_PER_DAY;
  
  // Calculate time
  int hour24 = remainingSeconds / SECONDS_PER_HOUR;
  remainingSeconds %= SECONDS_PER_HOUR;
  int minute = remainingSeconds / SECONDS_PER_MINUTE;
  int second = remainingSeconds % SECONDS_PER_MINUTE;
  
  // Convert to 12-hour format with AM/PM
  int hour12 = hour24;
  String ampm = "AM";
  
  if (hour24 == 0) {
    hour12 = 12; // 12 AM
  } else if (hour24 == 12) {
    hour12 = 12; // 12 PM
    ampm = "PM";
  } else if (hour24 > 12) {
    hour12 = hour24 - 12; // 1 PM to 11 PM
    ampm = "PM";
  }
  
  // Format as DD/MM/YYYY HH:MM:SS AM/PM
  char timestampBuffer[25];
  sprintf(timestampBuffer, "%02d/%02d/%04d %02d:%02d:%02d %s",
          day, month, year, hour12, minute, second, ampm.c_str());
  
  return String(timestampBuffer);
}

// Fallback: Sync time from local server - More precise
bool syncTimeFromLocalServer() {
  WiFiClient client;
  
  Serial.println("Attempting precise time sync from local server...");
  
  if (client.connect(serverHost, serverPort)) {
    Serial.println("Connected to local server");
    
    client.println("GET /SWIFT/NEW_SWIFT/php/api/time.php HTTP/1.1");
    client.println("Host: " + String(serverHost));
    client.println("Connection: close");
    client.println();
    
    String response = "";
    unsigned long timeout = millis() + 5000; // 5 second timeout
    
    while (client.connected() && millis() < timeout) {
      if (client.available()) {
        response += client.readString();
        if (response.length() > 1000) break;
      }
    }
    client.stop();
    
    Serial.println("Local server response length: " + String(response.length()));
    
    // Look for epoch time in response
    int epochIndex = response.indexOf("\"epoch\":");
    if (epochIndex != -1) {
      int startIndex = epochIndex + 8;
      int endIndex = response.indexOf(",", startIndex);
      if (endIndex == -1) endIndex = response.indexOf("}", startIndex);
      
      String epochStr = response.substring(startIndex, endIndex);
      epochStr.trim();
      
      Serial.println("Found epoch: " + epochStr);
      
      unsigned long epochValue = epochStr.toInt();
      
      // Validate epoch time
      if (epochValue > 1600000000 && epochValue < 3000000000) { // Between 2020 and 2065
        currentEpochTime = epochValue;
        lastTimeSync = millis();
        timeInitialized = true;
        
        Serial.println("✓ Precise time synced from local server! Epoch: " + String(currentEpochTime));
        Serial.println("✓ Current time: " + getFormattedTime());
        return true;
      } else {
        Serial.println("✗ Invalid epoch value from local server: " + String(epochValue));
      }
    } else {
      Serial.println("✗ Epoch not found in local server response");
    }
  } else {
    Serial.println("✗ Failed to connect to local server");
  }
  
  Serial.println("✗ Local server time sync failed");
  return false;
}

// Manual time setting (last resort)
void setManualTime(int year, int month, int day, int hour, int minute, int second) {
  struct tm timeinfo;
  timeinfo.tm_year = year - 1900;
  timeinfo.tm_mon = month - 1;
  timeinfo.tm_mday = day;
  timeinfo.tm_hour = hour;
  timeinfo.tm_min = minute;
  timeinfo.tm_sec = second;
  
  currentEpochTime = mktime(&timeinfo);
  lastTimeSync = millis();
  timeInitialized = true;
  components.ntp = true;
  
  Serial.println("Manual time set: " + String(year) + "-" + String(month) + "-" + String(day) + " " + 
                String(hour) + ":" + String(minute) + ":" + String(second));
}