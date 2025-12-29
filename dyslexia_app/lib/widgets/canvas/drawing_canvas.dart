import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import '../../services/handwriting_service.dart';

class DrawingCanvas extends StatefulWidget {
  final String targetWord;
  final VoidCallback onCorrect;

  const DrawingCanvas({
    super.key,
    required this.targetWord,
    required this.onCorrect,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<List<StrokePoint>> _strokes = [];
  List<StrokePoint> _currentStroke = [];
  bool _recognizing = false;

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  Future<void> _submit() async {
    if (_strokes.isEmpty) return;

    setState(() => _recognizing = true);

    final recognized = await HandwritingService.recognize(_strokes);

    setState(() => _recognizing = false);

    if (recognized == null) {
      _show("Could not recognize handwriting ❌", false);
      return;
    }

    final isCorrect = recognized.trim().toLowerCase() ==
        widget.targetWord.trim().toLowerCase();

    if (isCorrect) {
      widget.onCorrect();
      _show("Correct! ✅ ($recognized)", true);
    } else {
      _show("Incorrect ❌ You wrote \"$recognized\"", false);
    }
  }

  void _show(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // DRAWING AREA
        Container(
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onPanStart: (_) => _currentStroke = [],
            onPanUpdate: (details) {
              setState(() {
                _currentStroke.add(
                  StrokePoint(
                    x: details.localPosition.dx,
                    y: details.localPosition.dy,
                    t: DateTime.now().millisecondsSinceEpoch,
                  ),
                );
              });
            },
            onPanEnd: (_) {
              _strokes.add(_currentStroke);
              _currentStroke = [];
            },
            child: CustomPaint(
              painter: _CanvasPainter(_strokes),
              size: Size.infinite,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // CONTROLS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: _clearCanvas,
              child: const Text("Clear"),
            ),
            ElevatedButton(
              onPressed: _recognizing ? null : _submit,
              child: _recognizing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Submit"),
            ),
          ],
        ),
      ],
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final List<List<StrokePoint>> strokes;

  _CanvasPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          Offset(stroke[i].x, stroke[i].y),
          Offset(stroke[i + 1].x, stroke[i + 1].y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
