#ifndef sh_h
#define sh_h

#define ARDUINOJSON_USE_DOUBLE 1

#include <Arduino.h>
#include <SocketIoClient.h>
#include <ArduinoJson.h>
#include <Time_lib/TimeLib.h>

#define S_PRINT(...) Serial.println(__VA_ARGS__);
// #define S_PRINT(...)
#define S_PRINT_ERROR(...) Serial.println(__VA_ARGS__);

// #define HOST "www.hspvision.com"
#define HOST "85.185.1.160"
// #define HOST "192.168.100.3"
#define PORT 1486
// #define PORT 443
#define socket_path "/socket.io/?transport=websocket"
#define USE_SSL false

template <size_t desiredCapacity>
StaticJsonDocument<desiredCapacity> parseJaon(const char *p, size_t l)
{
    StaticJsonDocument<desiredCapacity> doc;
    DeserializationError error = deserializeJson(doc, p, l);

    if (error)
    {
        Serial.print(F("deserializeJson() failed: "));
        Serial.println(error.f_str());
        return doc;
    }
    return doc;
}
class SocketHandler
{
    bool disconnectPrinted = false;
    String SID;
    bool should_reconnect = true;
    SocketIoClient webSocket;
    std::map<String, std::function<String(DynamicJsonDocument)>> events;

    String devID;
    std::function<void(bool, bool)> onConnect;
    std::function<String()> onStatusUpdateRequest;
    String tz;
    void connect(const char *payload, size_t length)
    {
        S_PRINT("Chip connected");
        String packet = "{\"devID\":\"" + String(devID) + "\",\"tz\":\"" + tz + "\"}";
        webSocket.emit("register_dev", packet.c_str());
        disconnectPrinted = false;
    }

    void disconnect(const char *payload, size_t length)
    {
        if (!disconnectPrinted)
        {
            S_PRINT("Chip disconnected!");
            disconnectPrinted = true;
        }
        this->onConnect(false, true);
    }

    void app_dev(const char *payload, size_t length)
    {
        StaticJsonDocument<192> doc;
        DeserializationError error = deserializeJson(doc, payload, length);

        if (error)
        {
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            return;
        }

        String devID = doc["devID"];

        if (devID != this->devID)
            return;

        String msgID = doc["msgID"];
        String widgetID = doc["widgetID"];
        String appID = doc["appID"];

        for (auto kv : events)
            if (kv.first == widgetID && kv.second != NULL)
            {
                String result = kv.second(doc);
                String response = "{\"message\":\"" + result + "\",\"messageID\":\"" + msgID + "\",\"devID\":\"" + devID + "\",\"appID\":\"" + appID + "\"}";
                webSocket.emit("dev_app_response", response.c_str());
            }
    }
    void sever_dev(const char *payload, size_t length)
    {
    }
    void dev_reg_successful(const char *payload, size_t length)
    {
        StaticJsonDocument<100> doc;
        DeserializationError error = deserializeJson(doc, payload, length);

        if (error)
        {
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            return;
        }

        int _hour = doc["hour"];
        int _minute = doc["minute"];
        setTime(_hour, _minute, 0, 0, 0, 0);

        S_PRINT("Chip registered successfuly")
        this->onConnect(true, true);
    }
    void dev_dev_id_not_valid(const char *payload, size_t length)
    {
        S_PRINT_ERROR("DEVICE ID NOT VALID!");
        webSocket.disconnect();
        should_reconnect = false;
        onConnect(false, false);
    }

    void dev_reconnect_request(const char *payload, size_t length)
    {
        StaticJsonDocument<100> doc = parseJaon<100>(payload, length);

        String devID = String(doc["devID"].as<const char *>());
        if (devID == this->devID)
        {
            webSocket.disconnect();
            Serial.println("reconnectRequest");
        }
    }

public:
    SocketHandler(String devID, std::function<void(bool, bool)> onConnect, std::function<String()> onStatusUpdateRequest, String tz = "")
        : devID(devID), onConnect(onConnect), onStatusUpdateRequest(onStatusUpdateRequest), tz(tz)
    {

        webSocket.on("connect",
                     ([this](const char *p, size_t l)
                      { this->connect(p, l); }));

        webSocket.on("disconnect",
                     ([this](const char *p, size_t l)
                      { this->disconnect(p, l); }));

        webSocket.on("app_dev",
                     ([this](const char *p, size_t l)
                      { this->app_dev(p, l); }));

        webSocket.on("app_status_update_request",
                     ([this](const char *p, size_t l)
                      {
                          String result = this->onStatusUpdateRequest();
                          String response = "{\"devID\":\"" + this->devID + "\",\"message\":\"" + result + "\"}";
                          this->webSocket.emit("dev_status_update_response", response.c_str());
                      }));

        webSocket.on("sever_dev",
                     ([this](const char *p, size_t l)
                      { this->sever_dev(p, l); }));

        webSocket.on("dev_reg_successful",
                     ([this](const char *p, size_t l)
                      { this->dev_reg_successful(p, l); }));

        webSocket.on("dev_dev_id_not_valid",
                     ([this](const char *p, size_t l)
                      { this->dev_dev_id_not_valid(p, l); }));

        webSocket.on("dev_reconnect_request",
                     ([this](const char *p, size_t l)
                      { this->dev_reconnect_request(p, l); }));
    }

    void begin(String host = HOST, int port = PORT, bool useSSL = USE_SSL)
    {
        Serial.println("Connecting to " + host + ":" + port);
        if (useSSL)
            webSocket.beginSSL(host.c_str(), port, socket_path, (const uint8_t *)0);
        else
            webSocket.begin(host.c_str(), port, socket_path);
    }

    void loop()
    {
        if (should_reconnect)
            webSocket.loop();
    }

    void sendRaw(String data)
    {
        webSocket.emit("dev_app", data.c_str());
    }

    void addWidgetListener(String widgetID, std::function<String(DynamicJsonDocument)> f)
    {
        events[widgetID] = f;
    }

    void removeWidgetListener(String widgetID)
    {
        events[widgetID] = NULL;
    }

    void sendForWidget(String message, String widgetID)
    {
        String sth = "{\"message\":\"" + message + "\",\"devID\":\"" + devID + "\",\"widgetID\":\"" + widgetID + "\"}";
        webSocket.emit("dev_app", sth.c_str());
    }

    void sendMessage(String message)
    {
        sendForWidget(message, "");
    }
    String getTime()
    {
        int Hour = hour();
        int Min = minute();
        String Hour_s = Hour < 10 ? ("0" + String(Hour)) : String(Hour);
        String Min_s = Min < 10 ? ("0" + String(Min)) : String(Min);
        return Hour_s + ":" + Min_s;
    }
};

#endif