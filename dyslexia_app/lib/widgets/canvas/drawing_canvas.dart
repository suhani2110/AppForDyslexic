import 'package:flutter/material.dart';
import 'signature_painter.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset?> _points = [];

  void clear() => setState(() => _points.clear());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.white,
          child: GestureDetector(
            onPanUpdate: (details) {
              final box = context.findRenderObject() as RenderBox;
              setState(() {
                _points.add(
                  box.globalToLocal(details.globalPosition),
                );
              });
            },
            onPanEnd: (_) => _points.add(null),
            child: CustomPaint(
              painter: SignaturePainter(_points),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: clear,
          child: const Text("Clear Writing"),
        ),
      ],
    );
  }
}
