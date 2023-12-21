import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService(), ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "loading",
        routes: appRoutes,
      ),
    );
  }
}
