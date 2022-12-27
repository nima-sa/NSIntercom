#include "configs.h"

// #include <Arduino.h>
#include <ESP8266WiFi.h>
// #include <WiFi.h>
#include <WiFiManager.h>

#ifdef USE_OTA
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#endif

#include "SocketHandler.h"
#include "SocketConf.h"
#include "ServerHandler.h"

#define buttons_pin A0
#define doorRelay 5
#define buzzer_pin 12
#define led_pin 13
#define picRelay 14

#define BUTTON1_THRESH_H 1024
#define BUTTON1_THRESH_L 1000

#define BUTTON2_THRESH_H 510
#define BUTTON2_THRESH_L 480

#define BUTTON3_THRESH_H 220
#define BUTTON3_THRESH_L 180

#define button1_code 0
#define button2_code 1
#define button3_code 2

#define DEBUG_SOCKET 0
#define DEBUG_BUTTONS 1
#define DEBUG_BUTTONS_CODE 2
#define DEBUG_BUTTONS_FUNC 3

// #define DEBUG DEBUG_BUTTONS

// char ssid[] = _SSID;
// char pswd[] = _PASSWORD;

bool shouldOpen = false;
bool hasBuzzer = true;
long long unsigned int doorOpenInterval = defaultDoorOpenInterval;

unsigned long long openDoorCurrentTimeHolder = 0;
unsigned long long buttonReadCurrentTimeHolder = 0;

// ESP8266WebServer httpServer(80);
// ESP8266OTA otaUpdater;

void openDoorProcess();
void buzzFeedback(int = 1, int = 50, int = 50);

void onConnect(bool server, bool devIDValid)
{
}
String onStatusUpdateRequest() { return "{}"; }

SocketHandler chip(DEV_ID, onConnect, onStatusUpdateRequest, TIME_ZONE);

template <typename T>
void pprint(T inp)
{
    Serial.print(inp);
    Serial.println(" [" + chip.getTime() + "]");
}

String onOpen(DynamicJsonDocument doc)
{
    String appID = String(doc["appID"].as<const char *>());
    if (appID == appID1 || appID == appID2 || appID == appID3)
    {
        int doorInterval = doc["message"];
        doorInterval = doorInterval >= 0 ? doorInterval : 10;
        doorOpenInterval = (long long unsigned int)max((long long int)(doorInterval * 1000) - 1500, (long long int)0);
        openDoorCurrentTimeHolder = millis();
        pprint("Got open order by: " + appID + ". int: " + String(doorInterval));
        shouldOpen = true;
        return "Opening the door";
    }
    else
    {
        return "Auth error for opening the door";
    }
}

String onCancel(DynamicJsonDocument doc)
{
    String appID = String(doc["appID"].as<const char *>());
    if (appID == appID1 || appID == appID2 || appID == appID3)
    {
        pprint("Got cancel order by: " + appID);
        shouldOpen = false;
        return "Canceled opening the door";
    }
    else
    {
        return "Auth error for canceling opening the door";
    }
}

void v_buzz(bool i)
{
    if (!i)
        digitalWrite(buzzer_pin, i);
    else if (i && hasBuzzer)
        digitalWrite(buzzer_pin, i);
}

void buzzFeedback(int c, int _d1, int _d2)
{
    for (int i = 0; i < c; i++)
    {
        v_buzz(HIGH);
        delay(_d1);
        v_buzz(LOW);
        if (c > 1 && i < c - 1)
            delay(_d2);
    }
}

void feedback(int _d1 = 100, int _d2 = 100, int c = 1)
{
    for (int i = 0; i < c; i++)
    {
        digitalWrite(led_pin, HIGH);
        delay(_d1);
        digitalWrite(led_pin, LOW);

        if (c > 1 && i < c - 1)
            delay(_d2);
    }
}

void checkWiFiConnection()
{
    if (WiFi.status() != WL_CONNECTED)
        pprint("Reconecting to wifi");
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        digitalWrite(led_pin, HIGH);
        delay(10);
        digitalWrite(led_pin, LOW);
        delay(490);
    }
}
void resetAllSettings()
{
    feedback(500, 100, 4);
    Serial.println("Resetting to factory settings");
    WiFi.begin("", "");
    delay(500);
    WiFi.disconnect(true);
    SocketConf::erase(SOCKET_MEM);
    char resetCounter = 0;
    EEPROM.put(RESET_COUNTER_MEM, resetCounter);
    EEPROM.commit();
    ESP.eraseConfig();
}
void setup()
{
    Serial.begin(115200);

    pinMode(buzzer_pin, OUTPUT);
    pinMode(led_pin, OUTPUT);
    pinMode(doorRelay, OUTPUT);
    pinMode(picRelay, OUTPUT);
    pinMode(buttons_pin, INPUT);

    EEPROM.begin(EEPROM_SIZE);

    char resetCounter = 0;
    EEPROM.get(RESET_COUNTER_MEM, resetCounter);

    if (resetCounter > 2)
    {
        resetAllSettings();
        ESP.restart();
    }
    resetCounter++;
    EEPROM.put(RESET_COUNTER_MEM, resetCounter);
    EEPROM.commit();
    feedback(1000);
    // digitalWrite(led_pin, HIGH);
    // for (int i = 0; i < 5; i++)
    // {
    //     Serial.print("-");
    //     delay(500);
    // }
    // digitalWrite(led_pin, LOW);

    resetCounter = 0;
    EEPROM.put(RESET_COUNTER_MEM, resetCounter);
    EEPROM.commit();


    Serial.print("Connecting to ");
    Serial.println(WiFi.SSID());

    WiFiManager wm;
    wm.setDebugOutput(false);
    wm.autoConnect("Intercom " + String(SERIAL_NUM), "NIMAsa77");


    // WiFi.begin(ssid, pswd);
    checkWiFiConnection();
    digitalWrite(led_pin, LOW);

    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());

#ifdef USE_OTA
    MDNS.begin(SERIAL_NUM);
    ArduinoOTA.setHostname(SERIAL_NUM);
    ArduinoOTA.setPort(6462);

    // ArduinoOTA.setPassword("nimaadmin");

    // Password can be set with it's md5 value as well

    // MD5(admin) = 21232f297a57a5a743894a0e4a801fc3
    // ArduinoOTA.setPasswordHash("21232f297a57a5a743894a0e4a801fc3");

    ArduinoOTA.onStart([]()
                       {
                           String type;
                           if (ArduinoOTA.getCommand() == U_FLASH)
                           {
                               type = "sketch";
                           }
                           else
                           { // U_FS
                               type = "filesystem";
                           }

                           // NOTE: if updating FS this would be the place to unmount FS using FS.end()
                           Serial.println("Start updating " + type);
                       });

    ArduinoOTA.onEnd([]()
                     { Serial.println("\nEnd"); });
    ArduinoOTA.onProgress([](unsigned int progress, unsigned int total)
                          { Serial.printf("Progress: %u%%\r", (progress / (total / 100))); });
    ArduinoOTA.onError([](ota_error_t error)
                       {
                           Serial.printf("Error[%u]: ", error);
                           if (error == OTA_AUTH_ERROR)
                           {
                               Serial.println("Auth Failed");
                           }
                           else if (error == OTA_BEGIN_ERROR)
                           {
                               Serial.println("Begin Failed");
                           }
                           else if (error == OTA_CONNECT_ERROR)
                           {
                               Serial.println("Connect Failed");
                           }
                           else if (error == OTA_RECEIVE_ERROR)
                           {
                               Serial.println("Receive Failed");
                           }
                           else if (error == OTA_END_ERROR)
                           {
                               Serial.println("End Failed");
                           }
                       });
    ArduinoOTA.begin();
#endif

    chip.addWidgetListener("open_btn", onOpen);
    chip.addWidgetListener("cancel_btn", onCancel);

    SocketConf::load(SOCKET_MEM);
    String host = SocketConf::host;
    char port = SocketConf::port;
    bool usessl = SocketConf::usessl;

    if (host != "" && port != 0)
    {
        pprint("Connecting to " + host + ":" + (int)port);
        chip.begin(host, port, usessl);
    }
    else
        chip.begin();

    ServerHandler::begin();
}

int readButtons()
{
    if (millis() - buttonReadCurrentTimeHolder >= 100)
    {
        buttonReadCurrentTimeHolder = millis();
        int i = analogRead(buttons_pin);
        if (i > 10)
        {
            // chip.sendMessage(String(i));
        }
        if (BUTTON1_THRESH_L <= i && i <= BUTTON1_THRESH_H)
            return button1_code;
        else if (BUTTON2_THRESH_L <= i && i <= BUTTON2_THRESH_H)
            return button2_code;
        else if (BUTTON3_THRESH_L <= i && i <= BUTTON3_THRESH_H)
            return button3_code;
    }
    return -1;
}

void checkButtons()
{
    int b = readButtons();
    if (b == button1_code)
    {
        pprint("cancel button pressed");
        shouldOpen = false;
        feedback();
        buzzFeedback(2);
        chip.sendMessage("Canceled door opening by chip");
    }
    else if (b == button2_code)
    {
        hasBuzzer = !hasBuzzer;
        pprint(String("buzzer ") + (hasBuzzer ? "activated" : "silenced"));
        if (hasBuzzer)
            v_buzz(HIGH);
        feedback();
        v_buzz(LOW);
    }
    else if (b == button3_code)
    {
        pprint("open now btn");

        // if (shouldOpen)
        // {
        //     pprint("openning now");
        //     feedback();
        //     shouldOpen = false;
        //     openDoorProcess();
        // }
    }
    if (b > -1)
    {
        pprint("Code: " + String(b));
        delay(500);
    }
}

void openDoorProcess()
{
    digitalWrite(led_pin, HIGH);
    digitalWrite(picRelay, HIGH);
    delay(500);

    digitalWrite(picRelay, LOW);
    if (shouldOpen)
    {
        v_buzz(HIGH);
        delay(500);
        shouldOpen = false;
        pprint("door opened");
        digitalWrite(doorRelay, HIGH);
        delay(500);
        digitalWrite(doorRelay, LOW);
    }
    v_buzz(LOW);
    digitalWrite(led_pin, LOW);
}

#ifdef DEBUG
void debug(int);
#endif

void loop()
{
#ifdef DEBUG
    debug(DEBUG);
#else
#ifdef USE_OTA
    ArduinoOTA.handle();
#endif
    checkWiFiConnection();
    checkButtons();
    ServerHandler::handle();
    chip.loop();
    if (shouldOpen)
    {
        if (millis() - openDoorCurrentTimeHolder >= doorOpenInterval)
        {
            openDoorProcess();
            chip.sendMessage("Door opened");
        }
        else
        {
            v_buzz(HIGH);

            digitalWrite(led_pin, HIGH);
            delay(100);
            digitalWrite(led_pin, LOW);
            delay(100);
            digitalWrite(led_pin, HIGH);
            delay(100);
            digitalWrite(led_pin, LOW);
            delay(100);
            digitalWrite(led_pin, HIGH);
            delay(100);
            digitalWrite(led_pin, LOW);

            v_buzz(LOW);

            delay(100);
            digitalWrite(led_pin, HIGH);
            delay(100);
            digitalWrite(led_pin, LOW);
            delay(100);
            digitalWrite(led_pin, HIGH);
            delay(100);
            digitalWrite(led_pin, LOW);
            delay(100);
        }
    }
#endif
}
#ifdef DEBUG
void debug(int i)
{
    if (i == DEBUG_BUTTONS)
    {
        Serial.println(analogRead(buttons_pin));
        delay(500);
    }
    else if (i == DEBUG_SOCKET)
    {
        chip.loop();
        while (Serial.available())
            chip.sendMessage(Serial.readString());
    }
    else if (i == DEBUG_BUTTONS_CODE)
    {
        Serial.println(readButtons() + 1);
        delay(500);
    }
    else if (i == DEBUG_BUTTONS_FUNC)
    {
        checkButtons();
    }
}
#endif