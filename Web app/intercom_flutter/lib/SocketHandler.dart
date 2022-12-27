import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;

// const _url = 'http://192.168.100.3:8000';
const _url = 'http://85.185.1.160:1486';
// const _url = 'https://www.hspvision.com';

class SocketHandler {
  socketio.Socket socket;

  final String devID;
  String appID;
  final Function(bool, bool) onAppConnect;
  final Function(bool) onDevConnect;
  final Function(Map) devEvent;
  final Function(Map) devResponse;
  final Function(Map) devStatusUpdate;

  SocketHandler({
    @required this.devID,
    @required this.appID,
    @required this.onAppConnect,
    @required this.onDevConnect,
    @required this.devEvent,
    @required this.devResponse,
    @required this.devStatusUpdate,
  }) {
    if (devID == '') return;
    socket = socketio.io(
      _url,
      socketio.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.connect();
    socket.onConnect((_) {
      onAppConnect(true, true);
      socket.emit('register_app', {'devID': devID});
    });
    socket.onDisconnect((_) {
      onDevConnect(false);
      onAppConnect(false, true);
    });

    socket.on('dev_app', (data) {
      if (data['devID'].toString() == devID) devEvent(data);
    });

    socket.on('app_dev_id_not_valid', (data) {
      if (data['devID'].toString() == devID) {
        socket.disconnect();
        onAppConnect(false, false);
      }
    });

    socket.on('dev_status_update_response', (data) {
      if (data['devID'].toString() == devID) {
        devStatusUpdate(data);
      }
    });

    socket.on('app_reg_successful', (data) {
      if (data['devID'].toString() == devID) onDevConnect(data['isDevOnline']);
    });

    socket.on('dev_app_dev_online_status', (data) {
      if (data['devID'].toString() == devID) onDevConnect(data['isDevOnline']);
    });

    socket.on('dev_response', (data) {
      if (data['devID'].toString() == devID) {
        devResponse(data);
      }
    });
  }

  void sendRaw(
    String msg, {
    String widgetID,
    String msgID,
  }) {
    socket.emit('app_dev', {
      'devID': devID,
      'appID': appID,
      'message': msg,
      'messageID': msgID,
      'widgetID': widgetID,
    });
  }

  void sendForWidget(String msg, String widgetID) {
    final id = Random.secure().nextInt(1000000).toString();
    sendRaw(msg, widgetID: widgetID, msgID: id);
  }

  void refresh() {
    socket.emit('app_status_update_request', {'devID': devID});
  }

  void findDeviceIfNotOnline() {
    socket.emit('dev_reconnect_request', {'devID': devID});
  }

  void disconnect() {
    socket.disconnect();
  }

  void setAppID(String i) {
    appID = i;
  }

  Map<String, dynamic> json2map(dynamic j) {
    try {
      return j.cast<String, dynamic>();
    } catch (e) {
      return {};
    }
  }
}
