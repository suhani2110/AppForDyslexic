import 'package:flutter/material.dart';
import '../screens/home/home_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomePage(),
  };
}

