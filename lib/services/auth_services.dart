import 'dart:convert';

import 'package:chat_app/global/environment.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/models.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma statica
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: "token");
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: "token");
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {"email": email, "password": password};

    final uri = Uri.parse("${Environment.apiUrl}/login");

    var resp = await http.post(uri,
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    // print('Response body: ${resp.body}');
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {"nombre": nombre, "email": email, "password": password};

    final uri = Uri.parse("${Environment.apiUrl}/login/new");

    var resp = await http.post(uri,
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});


    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody["msg"];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: "token");

    if (token == null) {
      return false;
    }

    final uri = Uri.parse("${Environment.apiUrl}/login/renew");

    final resp = await http.get(uri,
        headers: {"Content-Type": "application/json", "x-token": token!});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: "token", value: token);
  }

  Future logout() async {
    await _storage.delete(key: "token");
  }
}
