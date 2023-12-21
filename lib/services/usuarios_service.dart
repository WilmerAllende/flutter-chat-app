import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/services.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/usuarios");

      final token = await AuthService.getToken();

      final resp = await http.get(uri,
          headers: {"Content-Type": "application/json", "x-token": token!});
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
