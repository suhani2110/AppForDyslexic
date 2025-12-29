import 'package:flutter/material.dart';
import 'screens/home/home_page.dart';

void main() {
  runApp(const DyslexiaApp());
}

class DyslexiaApp extends StatelessWidget {
  const DyslexiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dyslexia App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
