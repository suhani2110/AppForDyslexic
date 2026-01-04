import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingCanvasController {
  VoidCallback? _clear;
  VoidCallback? _submit;

  void clear() => _clear?.call();
  void submit() => _submit?.call();
}

class DrawingCanvas extends StatefulWidget {
  final DrawingCanvasController controller;
  final String targetWord;
  final VoidCallback onCorrect;

  const DrawingCanvas({
    super.key,
    required this.controller,
    required this.targetWord,
    required this.onCorrect,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset> _points = [];

  @override
  void initState() {
    super.initState();

    widget.controller._clear = () {
      setState(() => _points.clear());
    };

    widget.controller._submit = _handleSubmit;
  }

  void _handleSubmit() {
    if (_points.isEmpty) return;

    // TEMP: accept submission (accuracy work later)
    widget.onCorrect();

    setState(() => _points.clear());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        setState(() {
          _points.add(box.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (_) => _points.add(Offset.infinite),
      child: CustomPaint(
        painter: _CanvasPainter(_points),
        size: Size.infinite,
      ),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final List<Offset> points;
  _CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
