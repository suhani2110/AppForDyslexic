import 'package:flutter/material.dart';
import '../screens/home/home_page.dart';
import '../screens/learning/word_practice_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const HomePage(),
    '/practice': (context) {
      final word = ModalRoute.of(context)!.settings.arguments as String;
      return WordPracticePage(word: word);
    },
  };
}
