import 'package:flutter/material.dart';
import 'core/routes.dart';

void main() {
  runApp(const DyslexiaApp());
}

class DyslexiaApp extends StatelessWidget {
  const DyslexiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App For Dyslexic',
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}

