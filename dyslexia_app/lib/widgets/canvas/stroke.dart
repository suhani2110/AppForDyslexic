import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  Stroke({
    required this.points,
    this.color = Colors.black,
    this.width = 4.0,
  });
}
