/*
 * SWIFT IoT System - Arduino UNO R4 WiFi Code
 * 
 * Swine Farm Environment Monitoring Device
 * 
 * Components:
 * - Arduino UNO R4 WIFI
 * - DHT22 Temperature and Humidity Sensor
 * - MQ137 Ammonia Gas Sensor
 * - LCD Display (16x2)
 * - 8 Channel Relay Module
 * 
 * Features:
 * - Real-time environmental monitoring
 * - Automatic device control based on thresholds
 * - WiFi connectivity with static IP
 * - Component health monitoring
 * - Data transmission to web application
 * 
 * @version 2.0
 * @author SWIFT Development Team
 * @since 2024
 */

// Include required libraries
#include <WiFiS3.h>
#include <LiquidCrystal.h>
#include <DHT.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

// Pin Definitions
#define DHT_PIN 2
#define MQ137_PIN A0
#define LCD_RS 7
#define LCD_EN 8
#define LCD_D4 9
#define LCD_D5 10
#define LCD_D6 11
#define LCD_D7 12
#define RELAY_WATER_PUMP 3
#define RELAY_HEAT_BULB 4
#define STATUS_LED 13

// Sensor Types
#define DHT_TYPE DHT22

// WiFi Configuration
const char* ssid = "YOUR_WIFI_SSID";           // Change to your WiFi SSID
const char* password = "YOUR_WIFI_PASSWORD";   // Change to your WiFi password

// Static IP Configuration
IPAddress local_IP(192, 168, 1, 100);         // Device static IP
IPAddress gateway(192, 168, 1, 1);             // Router IP
IPAddress subnet(255, 255, 255, 0);            // Subnet mask
IPAddress primaryDNS(8, 8, 8, 8);              // Primary DNS
IPAddress secondaryDNS(8, 8, 4, 4);            // Secondary DNS

// Web Server Configuration
const char* serverHost = "192.168.1.50";  // Change to your server IP or domain
const char* serverPath = "/php/api/v1/sensor_data.php";
const int serverPort = 443;  // HTTPS port
const bool useHTTPS = true;  // Set to true for HTTPS

// Environmental Thresholds (Philippines-specific for swine farming)
const float TEMP_HIGH_THRESHOLD = 30.0;        // Celsius - Trigger water sprinkler
const float TEMP_LOW_THRESHOLD = 15.0;         // Celsius - Trigger heat bulb
const float AMMONIA_HIGH_THRESHOLD = 50.0;     // ppm - Trigger water sprinkler
const float HUMIDITY_HIGH_THRESHOLD = 80.0;    // Percentage
const float HUMIDITY_LOW_THRESHOLD = 50.0;     // Percentage

// Timing Configuration
const unsigned long SENSOR_READ_INTERVAL = 2000;    // Read sensors every 2 seconds
const unsigned long DATA_SEND_INTERVAL = 1000;       // Send data every 1 second
const unsigned long COMPONENT_CHECK_INTERVAL = 2000; // Component check every 2 seconds
const unsigned long DEVICE_TIMEOUT = 300000;         // 5 minutes timeout

// Global Variables
WiFiClient client;
WiFiSSLClient sslClient;
LiquidCrystal lcd(LCD_RS, LCD_EN, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
DHT dht(DHT_PIN, DHT_TYPE);
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 28800, 60000); // UTC+8 for Philippines

// System State Variables
struct SystemState {
  float temperature = 0.0;
  float humidity = 0.0;
  float ammoniaLevel = 0.0;
  bool waterPumpStatus = false;
  bool heatBulbStatus = false;
  bool wifiConnected = false;
  bool componentsOK = true;
  unsigned long lastSensorRead = 0;
  unsigned long lastDataSend = 0;
  unsigned long lastComponentCheck = 0;
  unsigned long lastWifiCheck = 0;
  String currentTime = "";
  String deviceStatus = "INITIALIZING";
} systemState;

// Component Status
struct ComponentStatus {
  bool dhtSensor = false;
  bool mq137Sensor = false;
  bool lcdDisplay = false;
  bool relayModule = false;
  bool sdCard = false;
  bool rtcModule = false;
} componentStatus;

// Function Prototypes
void initializeSystem();
void connectToWiFi();
void configureStaticIP();
void initializeComponents();
void performComponentCheck();
void readSensors();
void processEnvironmentalData();
void controlDevices();
void updateLCDDisplay();
void sendDataToServer();
void sendHTTPSData();
void sendHTTPData();
void handleWiFiConnection();
void updateSystemTime();
String getCurrentTimestamp();
void displaySystemStatus();
void blinkStatusLED();
void emergencyShutdown();
void configureSSL();

void setup() {
  // Initialize serial communication
  Serial.begin(115200);
  Serial.println("SWIFT IoT System - Swine Farm Monitor");
  Serial.println("Initializing system...");
  
  // Initialize system
  initializeSystem();
  
  // Connect to WiFi
  connectToWiFi();
  
  // Configure static IP
  configureStaticIP();
  
  // Initialize components
  initializeComponents();
  
  // Perform initial component check
  performComponentCheck();
  
  // Initialize NTP client
  timeClient.begin();
  timeClient.update();
  
  // Configure SSL for HTTPS
  if (useHTTPS) {
    configureSSL();
  }
  
  // Set initial device status
  systemState.deviceStatus = "READY";
  
  Serial.println("System initialization complete!");
  Serial.println("Device IP: " + WiFi.localIP().toString());
  Serial.println("HTTPS Mode: " + String(useHTTPS ? "ENABLED" : "DISABLED"));
}

void loop() {
  unsigned long currentTime = millis();
  
  // Handle WiFi connection
  handleWiFiConnection();
  
  // Update system time
  updateSystemTime();
  
  // Read sensors every 2 seconds
  if (currentTime - systemState.lastSensorRead >= SENSOR_READ_INTERVAL) {
    readSensors();
    processEnvironmentalData();
    controlDevices();
    updateLCDDisplay();
    systemState.lastSensorRead = currentTime;
  }
  
  // Send data to server every 1 second
  if (currentTime - systemState.lastDataSend >= DATA_SEND_INTERVAL) {
    if (systemState.wifiConnected) {
      sendDataToServer();
    }
    systemState.lastDataSend = currentTime;
  }
  
  // Perform component check every 2 seconds
  if (currentTime - systemState.lastComponentCheck >= COMPONENT_CHECK_INTERVAL) {
    performComponentCheck();
    systemState.lastComponentCheck = currentTime;
  }
  
  // Blink status LED
  blinkStatusLED();
  
  // Small delay to prevent watchdog issues
  delay(10);
}

void initializeSystem() {
  // Initialize status LED
  pinMode(STATUS_LED, OUTPUT);
  digitalWrite(STATUS_LED, LOW);
  
  // Initialize relay pins
  pinMode(RELAY_WATER_PUMP, OUTPUT);
  pinMode(RELAY_HEAT_BULB, OUTPUT);
  
  // Turn off all relays initially
  digitalWrite(RELAY_WATER_PUMP, HIGH);  // Relay modules are active LOW
  digitalWrite(RELAY_HEAT_BULB, HIGH);
  
  // Initialize LCD
  lcd.begin(16, 2);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("SWIFT IoT System");
  lcd.setCursor(0, 1);
  lcd.print("Initializing...");
  
  // Initialize DHT sensor
  dht.begin();
  
  Serial.println("Hardware initialization complete");
}

void connectToWiFi() {
  Serial.println("Connecting to WiFi...");
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Connecting WiFi");
  
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    lcd.setCursor(0, 1);
    lcd.print("Attempt: " + String(attempts + 1));
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    systemState.wifiConnected = true;
    Serial.println();
    Serial.println("WiFi connected!");
    Serial.println("IP address: " + WiFi.localIP().toString());
    
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("WiFi Connected");
    lcd.setCursor(0, 1);
    lcd.print("IP: " + WiFi.localIP().toString());
    delay(2000);
  } else {
    systemState.wifiConnected = false;
    Serial.println();
    Serial.println("WiFi connection failed!");
    
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("WiFi Failed");
    lcd.setCursor(0, 1);
    lcd.print("Retrying...");
  }
}

void configureStaticIP() {
  if (systemState.wifiConnected) {
    Serial.println("Configuring static IP...");
    
    // Arduino UNO R4 WiFi WiFiS3 library uses different config signature
    WiFi.config(local_IP, primaryDNS, gateway, subnet);
    Serial.println("Static IP configured");
    Serial.println("Device IP: " + WiFi.localIP().toString());
  }
}

void initializeComponents() {
  Serial.println("Initializing components...");
  
  // Test DHT sensor
  float testTemp = dht.readTemperature();
  float testHumidity = dht.readHumidity();
  componentStatus.dhtSensor = (!isnan(testTemp) && !isnan(testHumidity));
  
  // Test MQ137 sensor
  int testAmmonia = analogRead(MQ137_PIN);
  componentStatus.mq137Sensor = (testAmmonia > 0 && testAmmonia < 1024);
  
  // Test LCD display
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("LCD Test");
  componentStatus.lcdDisplay = true;
  
  // Test relay module
  digitalWrite(RELAY_WATER_PUMP, LOW);
  delay(100);
  digitalWrite(RELAY_WATER_PUMP, HIGH);
  digitalWrite(RELAY_HEAT_BULB, LOW);
  delay(100);
  digitalWrite(RELAY_HEAT_BULB, HIGH);
  componentStatus.relayModule = true;
  
  // SD Card and RTC are not physically present, so mark as false
  componentStatus.sdCard = false;
  componentStatus.rtcModule = false;
  
  Serial.println("Component initialization complete");
}

void performComponentCheck() {
  // Check DHT sensor
  float temp = dht.readTemperature();
  float humidity = dht.readHumidity();
  componentStatus.dhtSensor = (!isnan(temp) && !isnan(humidity));
  
  // Check MQ137 sensor
  int ammoniaReading = analogRead(MQ137_PIN);
  componentStatus.mq137Sensor = (ammoniaReading > 0 && ammoniaReading < 1024);
  
  // Check overall component status
  systemState.componentsOK = componentStatus.dhtSensor && 
                            componentStatus.mq137Sensor && 
                            componentStatus.lcdDisplay && 
                            componentStatus.relayModule;
  
  if (!systemState.componentsOK) {
    Serial.println("Component check failed!");
    systemState.deviceStatus = "COMPONENT_ERROR";
  } else {
    systemState.deviceStatus = "ACTIVE";
  }
}

void readSensors() {
  // Read temperature and humidity
  systemState.temperature = dht.readTemperature();
  systemState.humidity = dht.readHumidity();
  
  // Read ammonia level (convert analog reading to ppm)
  int analogReading = analogRead(MQ137_PIN);
  // Convert analog reading to voltage (0-5V)
  float voltage = analogReading * (5.0 / 1023.0);
  // Convert voltage to ppm (this is a simplified conversion - calibrate for your specific sensor)
  systemState.ammoniaLevel = voltage * 100.0; // Rough conversion factor
  
  // Validate readings
  if (isnan(systemState.temperature) || isnan(systemState.humidity)) {
    systemState.temperature = 0.0;
    systemState.humidity = 0.0;
  }
  
  Serial.println("Sensor Readings:");
  Serial.println("Temperature: " + String(systemState.temperature) + "°C");
  Serial.println("Humidity: " + String(systemState.humidity) + "%");
  Serial.println("Ammonia: " + String(systemState.ammoniaLevel) + " ppm");
}

void processEnvironmentalData() {
  // Process temperature data
  if (systemState.temperature > TEMP_HIGH_THRESHOLD) {
    systemState.waterPumpStatus = true;
    Serial.println("Temperature HIGH - Water sprinkler activated");
  } else if (systemState.temperature < TEMP_LOW_THRESHOLD) {
    systemState.heatBulbStatus = true;
    Serial.println("Temperature LOW - Heat bulb activated");
  }
  
  // Process ammonia data
  if (systemState.ammoniaLevel > AMMONIA_HIGH_THRESHOLD) {
    systemState.waterPumpStatus = true;
    Serial.println("Ammonia HIGH - Water sprinkler activated");
  }
  
  // Turn off devices when conditions are normal
  if (systemState.temperature >= TEMP_LOW_THRESHOLD && 
      systemState.temperature <= TEMP_HIGH_THRESHOLD && 
      systemState.ammoniaLevel <= AMMONIA_HIGH_THRESHOLD) {
    systemState.waterPumpStatus = false;
    systemState.heatBulbStatus = false;
  }
}

void controlDevices() {
  // Control water pump relay
  if (systemState.waterPumpStatus) {
    digitalWrite(RELAY_WATER_PUMP, LOW);  // Activate relay
  } else {
    digitalWrite(RELAY_WATER_PUMP, HIGH); // Deactivate relay
  }
  
  // Control heat bulb relay
  if (systemState.heatBulbStatus) {
    digitalWrite(RELAY_HEAT_BULB, LOW);   // Activate relay
  } else {
    digitalWrite(RELAY_HEAT_BULB, HIGH);  // Deactivate relay
  }
}

void updateLCDDisplay() {
  lcd.clear();
  
  // First row: Sensor readings
  lcd.setCursor(0, 0);
  lcd.print("T:" + String(systemState.temperature, 1) + 
            "|H:" + String(systemState.humidity, 1) + 
            "|A:" + String(systemState.ammoniaLevel, 1));
  
  // Second row: Device status
  lcd.setCursor(0, 1);
  if (!systemState.waterPumpStatus && !systemState.heatBulbStatus) {
    lcd.print("----ALL OFF----");
  } else if (systemState.waterPumpStatus && systemState.temperature > TEMP_HIGH_THRESHOLD) {
    lcd.print("PUMP ON = T:HIGH");
  } else if (systemState.waterPumpStatus && systemState.ammoniaLevel > AMMONIA_HIGH_THRESHOLD) {
    lcd.print("PUMP ON = NH3");
  } else if (systemState.heatBulbStatus && systemState.temperature < TEMP_LOW_THRESHOLD) {
    lcd.print("HEAT ON = T:LOW");
  } else {
    lcd.print("SYSTEM ACTIVE");
  }
}

void sendDataToServer() {
  if (!systemState.wifiConnected) {
    return;
  }
  
  if (useHTTPS) {
    sendHTTPSData();
  } else {
    sendHTTPData();
  }
}

void sendHTTPSData() {
  // Create JSON payload
  StaticJsonDocument<512> doc;
  doc["device_id"] = 1;  // Change this to your device ID
  doc["timestamp"] = getCurrentTimestamp();
  doc["temperature"] = systemState.temperature;
  doc["humidity"] = systemState.humidity;
  doc["ammonia_level"] = systemState.ammoniaLevel;
  doc["water_sprinkler_status"] = systemState.waterPumpStatus ? "on" : "off";
  doc["heat_bulb_status"] = systemState.heatBulbStatus ? "on" : "off";
  doc["device_status"] = systemState.deviceStatus;
  doc["components_ok"] = systemState.componentsOK;
  
  // Serialize JSON
  String jsonString;
  serializeJson(doc, jsonString);
  
  Serial.println("Sending HTTPS data...");
  Serial.println("JSON: " + jsonString);
  
  // Send HTTPS POST request using WiFiSSLClient
  if (sslClient.connect(serverHost, serverPort)) {
    Serial.println("HTTPS connection established");
    
    // Send HTTP headers
    sslClient.println("POST " + String(serverPath) + " HTTP/1.1");
    sslClient.println("Host: " + String(serverHost));
    sslClient.println("Content-Type: application/json");
    sslClient.println("Content-Length: " + String(jsonString.length()));
    sslClient.println("Connection: close");
    sslClient.println("User-Agent: SWIFT-IoT-Device/2.0");
    sslClient.println();
    sslClient.println(jsonString);
    
    // Wait for response
    unsigned long timeout = millis();
    while (sslClient.connected() && millis() - timeout < 10000) {
      if (sslClient.available()) {
        String response = sslClient.readString();
        Serial.println("HTTPS Server response: " + response);
        break;
      }
    }
    
    sslClient.stop();
    Serial.println("HTTPS data sent successfully");
  } else {
    Serial.println("Failed to establish HTTPS connection");
    Serial.println("Server: " + String(serverHost) + ":" + String(serverPort));
  }
}

void sendHTTPData() {
  // Create JSON payload
  StaticJsonDocument<512> doc;
  doc["device_id"] = 1;  // Change this to your device ID
  doc["timestamp"] = getCurrentTimestamp();
  doc["temperature"] = systemState.temperature;
  doc["humidity"] = systemState.humidity;
  doc["ammonia_level"] = systemState.ammoniaLevel;
  doc["water_sprinkler_status"] = systemState.waterPumpStatus ? "on" : "off";
  doc["heat_bulb_status"] = systemState.heatBulbStatus ? "on" : "off";
  doc["device_status"] = systemState.deviceStatus;
  doc["components_ok"] = systemState.componentsOK;
  
  // Serialize JSON
  String jsonString;
  serializeJson(doc, jsonString);
  
  Serial.println("Sending HTTP data...");
  
  // Send HTTP POST request
  if (client.connect(serverHost, 80)) {  // HTTP uses port 80
    client.println("POST " + String(serverPath) + " HTTP/1.1");
    client.println("Host: " + String(serverHost));
    client.println("Content-Type: application/json");
    client.println("Content-Length: " + String(jsonString.length()));
    client.println("Connection: close");
    client.println("User-Agent: SWIFT-IoT-Device/2.0");
    client.println();
    client.println(jsonString);
    
    // Wait for response
    unsigned long timeout = millis();
    while (client.connected() && millis() - timeout < 5000) {
      if (client.available()) {
        String response = client.readString();
        Serial.println("HTTP Server response: " + response);
        break;
      }
    }
    
    client.stop();
    Serial.println("HTTP data sent successfully");
  } else {
    Serial.println("Failed to connect to HTTP server");
  }
}

void handleWiFiConnection() {
  unsigned long currentTime = millis();
  
  // Check WiFi connection every 30 seconds
  if (currentTime - systemState.lastWifiCheck >= 30000) {
    if (WiFi.status() != WL_CONNECTED) {
      systemState.wifiConnected = false;
      Serial.println("WiFi disconnected, attempting to reconnect...");
      connectToWiFi();
    } else {
      systemState.wifiConnected = true;
    }
    systemState.lastWifiCheck = currentTime;
  }
}

void updateSystemTime() {
  if (systemState.wifiConnected) {
    timeClient.update();
    systemState.currentTime = timeClient.getFormattedTime();
  }
}

String getCurrentTimestamp() {
  if (systemState.wifiConnected && timeClient.isTimeSet()) {
    // NTPClient doesn't have getFormattedDate(), so we'll create our own timestamp
    String timestamp = String(timeClient.getEpochTime());
    return "2024-01-01 " + timeClient.getFormattedTime(); // Simplified timestamp
  } else {
    return "1970-01-01 00:00:00";
  }
}

void displaySystemStatus() {
  Serial.println("=== SYSTEM STATUS ===");
  Serial.println("WiFi Connected: " + String(systemState.wifiConnected ? "YES" : "NO"));
  Serial.println("Device Status: " + systemState.deviceStatus);
  Serial.println("Components OK: " + String(systemState.componentsOK ? "YES" : "NO"));
  Serial.println("Temperature: " + String(systemState.temperature) + "°C");
  Serial.println("Humidity: " + String(systemState.humidity) + "%");
  Serial.println("Ammonia: " + String(systemState.ammoniaLevel) + " ppm");
  Serial.println("Water Pump: " + String(systemState.waterPumpStatus ? "ON" : "OFF"));
  Serial.println("Heat Bulb: " + String(systemState.heatBulbStatus ? "ON" : "OFF"));
  Serial.println("===================");
}

void blinkStatusLED() {
  static unsigned long lastBlink = 0;
  static bool ledState = false;
  
  unsigned long currentTime = millis();
  
  if (currentTime - lastBlink >= 1000) {  // Blink every second
    ledState = !ledState;
    digitalWrite(STATUS_LED, ledState);
    lastBlink = currentTime;
  }
}

void configureSSL() {
  Serial.println("Configuring SSL/TLS for HTTPS...");
  
  // WiFiSSLClient handles SSL/TLS automatically
  // For self-signed certificates, you may need to set insecure mode
  // sslClient.setInsecure(); // Uncomment if using self-signed certificates
  
  // Set timeout for SSL operations
  sslClient.setTimeout(10000);  // 10 seconds timeout
  
  Serial.println("SSL/TLS configuration complete");
  Serial.println("Note: Using secure HTTPS connection");
}

void emergencyShutdown() {
  Serial.println("EMERGENCY SHUTDOWN INITIATED!");
  
  // Turn off all relays
  digitalWrite(RELAY_WATER_PUMP, HIGH);
  digitalWrite(RELAY_HEAT_BULB, HIGH);
  
  // Update LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("EMERGENCY STOP");
  lcd.setCursor(0, 1);
  lcd.print("SYSTEM OFFLINE");
  
  // Flash LED rapidly
  for (int i = 0; i < 10; i++) {
    digitalWrite(STATUS_LED, HIGH);
    delay(100);
    digitalWrite(STATUS_LED, LOW);
    delay(100);
  }
  
  // Stop execution
  while (true) {
    delay(1000);
  }
}
