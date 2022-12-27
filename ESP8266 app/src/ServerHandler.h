#ifndef sh
#define sh
#include <Arduino.h>
#include <ESP8266WebServer.h>
#include "SocketConf.h"
#include "config.h"

ESP8266WebServer c_server(80);

class ServerHandler
{
public:
    static void begin()
    {

        c_server.on("/", []
                    {
                        String home =
                            String("<html><body>") +
                            String("<form action=\"set\" method=\"post\">") +
                            String("<label for=\"host\">Host:</label><input name=\"host\" id=\"host\"><br>") +
                            String("<label for=\"port\">Port:</label><input name=\"port\" id=\"port\"><br>") +
                            String("<label for=\"usessl\">use ssl:</label><input name=\"usessl\" id=\"usessl\"><br>") +
                            String("<input type=\"submit\" value=\"Commit\">") +
                            String("</form></body></html>");

                        c_server.send(200, "text/html", home);
                    });
        c_server.on("/set", []
                    {
                        String host = c_server.arg("host");
                        String port = c_server.arg("port");
                        String usessl = c_server.arg("usessl");
                        usessl.toLowerCase();
                        SocketConf::save(SOCKET_MEM, host, port.toInt(), usessl == String("true"));
                        c_server.sendHeader("Location", String("/"), true);
                        c_server.send(302, "text/plain", "");
                    });
        c_server.begin();
    }
    static void handle()
    {
        c_server.handleClient();
    }
};

#endif