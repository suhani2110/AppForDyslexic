import 'package:flutter/material.dart';

class DyslexiaTextStyles {
  // Change this ONE line later to switch fonts globally
  static const String activeFont = 'OpenDyslexic';
  // Alternatives: 'Lexend', null (system default)

  static TextStyle body({
    double size = 18,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black,
    double height = 1.6,
  }) {
    return TextStyle(
      fontFamily: activeFont,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle heading({
    double size = 22,
    FontWeight weight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: activeFont,
      fontSize: size,
      fontWeight: weight,
    );
  }
}
