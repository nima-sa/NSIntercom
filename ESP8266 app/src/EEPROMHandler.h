#ifndef EEH
#define EEH

#include <EEPROM.h>
#include <Arduino.h>

class EEPROMHandler
{

public:
    static void begin(int size)
    {
        EEPROM.begin(size);
    }

    static void store_commit(int addr, void *p)
    {
        EEPROM.put(addr, p);
        EEPROM.commit();
    }

    static void store(int addr, void *p)
    {
        EEPROM.put(addr, p);
    }

    static void commit(int addr, void *p)
    {
        EEPROM.commit();
    }

    static void get(int addr, void *p)
    {
        EEPROM.get(addr, p);
    }
};

#endif