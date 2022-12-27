#ifndef SPIFFConf_H
#define SPIFFConf_H

#include <Arduino.h>
#include <FS.h>

#define error(e) Serial.println(e)

using namespace std;

class SPIFHandler
{
    public:

    static void begin() {SPIFFS.begin();}
    static String restore(String);
    static bool writeChanges(String&, String);
    static bool remove(String);
};


bool SPIFHandler::remove(String fileName) {
    return SPIFFS.remove(fileName);
}


String SPIFHandler::restore(String fileName)
{
    File configFile = SPIFFS.open(fileName, "r");
    if (!configFile)
    {
        error("Failed to open " + fileName + " file");
        return "";
    }

    size_t size = configFile.size();
    if (size > 1024)
    {
        error(fileName + " size is too large");
        return "";
    }
    String document = "";

    while (configFile.available())
        // read line by line from the file
        document += configFile.readString();
        // document += configFile.readStringUntil('n') + '\n';

    configFile.close();
    return document;
}

bool SPIFHandler::writeChanges(String &_document, String fileName)
{
    // document = _document;
    File configFile = SPIFFS.open(fileName, "w");
    if (!configFile)
    {
        error("Failed to open config file for writing");
        return false;
    }
    if (!configFile.print(_document))
        error("Error writing to config");
    configFile.close();
    return true;
}

#endif //ESP32_CONFIG_H
