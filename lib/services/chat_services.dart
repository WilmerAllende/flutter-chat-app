import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/models.dart';

class ChatServiceNotifier extends ChangeNotifier {
  late Usuario usuariosPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final uri = Uri.parse("${Environment.apiUrl}/mensajes/$usuarioID");

      final token = await AuthService.getToken();

      final resp = await http.get(uri,
          headers: {"Content-Type": "application/json", "x-token": token!});
      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;

      
  }
}
