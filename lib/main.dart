import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.red,
        child: Center(
          child: Text(
            'Error: ${details.exception}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  };
  runApp(const TexBuddyApp());
}

class TexBuddyApp extends StatelessWidget {
  const TexBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tex Cost Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
