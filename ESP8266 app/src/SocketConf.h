#ifndef SPIFFConf_H
#define SPIFFConf_H

#include <Arduino.h>
#include <EEPROM.h>

class SocketConf
{
public:
    static String host;
    static int port;
    static bool usessl;

    static int getSize()
    {
        return 1 + host.length() + sizeof(port) + sizeof(usessl);
    }
    
    static void save(int st, String host, int port, bool usessl)
    {
        char l = (char)host.length();
        EEPROM.put(st, l);
        for (int i = 0; i < min((int)l, 1024 - st - 1); i++)
        {
            char c = host[i];
            EEPROM.put(st + 1 + i, c);
        }
        EEPROM.put(st + 1 + l, port);
        EEPROM.put(st + 1 + l + sizeof(port), usessl);
        EEPROM.commit();
    }

    static void load(int st)
    {

        char l = 0;
        EEPROM.get(st, l);
        // Serial.println((int)l);

        if (l == 0)
            return;
        host = "";
        for (int i = 0; i < min((int)l, 1024 - st - 1); i++)
        {
            char c = 0;
            EEPROM.get(st + 1 + i, c);
            host += c;
        }
        int port = 0;
        EEPROM.get(st + 1 + l, port);
        EEPROM.get(st + 1 + l + sizeof(port), usessl);

        // Serial.println(host);
        // Serial.println(port);
        // Serial.println(usessl);
    }

    static void erase(int st)
    {
        char l = 0;
        char zero = 0;

        EEPROM.get(st, l);
        for (int i = 0; i < min((int)l, 1024 - st - 1); i++)
            EEPROM.put(st + 1, zero);

        EEPROM.put(st, zero);
        EEPROM.put(st + 1 + l, zero);
        EEPROM.put(st + 1 + l + sizeof(port), zero);
        EEPROM.commit();
    }
};

String SocketConf::host = "";
int SocketConf::port = 0;
bool SocketConf::usessl = 0;

#endif //ESP32_CONFIG_H
