import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HandwritingCanvas extends StatefulWidget {
  const HandwritingCanvas({super.key});

  @override
  HandwritingCanvasState createState() => HandwritingCanvasState();
}

class HandwritingCanvasState extends State<HandwritingCanvas> {
  final GlobalKey _repaintKey = GlobalKey();
  final List<Offset?> _points = [];

  void clear() => setState(() => _points.clear());

  Future<Uint8List> exportImage() async {
    final boundary =
        _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _repaintKey,
          child: Container(
            height: 220,
            width: double.infinity,
            color: Colors.white,
            child: GestureDetector(
              onPanUpdate: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                setState(() {
                  _points.add(box.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (_) => _points.add(null),
              child: CustomPaint(
                painter: _HandwritingPainter(_points),
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: clear,
          icon: const Icon(Icons.clear),
          label: const Text("Clear"),
        ),
      ],
    );
  }
}

class _HandwritingPainter extends CustomPainter {
  final List<Offset?> points;

  _HandwritingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
