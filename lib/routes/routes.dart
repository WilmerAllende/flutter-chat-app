import 'package:chat_app/pages/pages.dart';
import 'package:flutter/material.dart';

final  Map<String, WidgetBuilder>  appRoutes = {
  "usuarios" : ( _ ) => const UsuariosPage() ,
  "chat" : ( _ ) => const ChatPage() ,
  "login" : ( _ ) => const LoginPage() ,
  "register" : ( _ ) => const RegisterPage() ,
  "loading" : ( _ ) => const LoadingPage() ,
};
