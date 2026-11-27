import 'package:flutter/material.dart';

void main() {
  runApp(const NotasApp());
}

class NotasApp extends StatelessWidget {
  const NotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas personales',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF3F0FF)),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1D1929),
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(body: Center(child: Text('Mis notas'))),
    );
  }
}
