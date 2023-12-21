import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../global/environment.dart';

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void connect() async {
    final token = await AuthService.getToken();
    // Dart client

    _socket = IO.io(
        Environment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            //.disableAutoConnect()  // disable auto-connection
            .enableAutoConnect()
            .enableForceNewConnection()
            .setExtraHeaders({'x-token': token}) // optional
            
            .build());

    _socket.onConnect((_) {
      print('connect a sockets');
      _serverStatus = ServerStatus.online;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    //socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    //socket.on('fromServer', (_) => print(_));

    /*
    socket.on('nuevo-mensaje', (data) {
      print(data.containsKey("mensaje222") ? data["mensaje222"] : "no hay");
      print('nuevo-mensaje: $data');
      //notifyListeners();
    });
    */
  }

  void disconnect() {
    _socket.disconnect();
  }
}
