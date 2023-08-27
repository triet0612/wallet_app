import 'package:flutter/material.dart';
import 'package:wallet_app/screen/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple[900],
        cardTheme: CardTheme(
          margin: const EdgeInsets.all(16),
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.indigo.shade900,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.purple.shade900),
        fontFamily: 'serif',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32),
          titleLarge: TextStyle(fontSize: 24),
          bodyMedium: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
