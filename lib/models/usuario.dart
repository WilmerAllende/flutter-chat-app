
import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    final String email;
    final String nombre;
    final bool online;
    final String uid;

    Usuario({
        required this.email,
        required this.nombre,
        required this.online,
        required this.uid,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        nombre: json["nombre"],
        online: json["online"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "nombre": nombre,
        "online": online,
        "uid": uid,
    };
}
