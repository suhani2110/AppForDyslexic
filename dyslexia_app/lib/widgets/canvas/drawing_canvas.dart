import 'package:flutter/material.dart';

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
  final List<Offset> _points = [];
  late List<bool> _letterCorrect;

  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _letterCorrect = List.filled(widget.targetWord.length, false);
  }

  void _clear() {
    setState(() {
      _points.clear();
      _letterCorrect = List.filled(widget.targetWord.length, false);
    });
  }

  bool _validate() {
    final letters = widget.targetWord.toLowerCase();
    final slots = letters.length;
    final slotWidth = _size.width / slots;

    final slotPoints = List.generate(slots, (_) => <Offset>[]);

    for (final p in _points) {
      final slot = (p.dx / slotWidth).floor().clamp(0, slots - 1);
      slotPoints[slot].add(p);
    }

    bool allCorrect = true;

    for (int i = 0; i < slots; i++) {
      final pts = slotPoints[i];
      final letter = letters[i];

      if (pts.length < 15) {
        _letterCorrect[i] = false;
        allCorrect = false;
        continue;
      }

      final minY = pts.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
      final maxY = pts.map((p) => p.dy).reduce((a, b) => a > b ? a : b);
      final heightRatio = (maxY - minY) / _size.height;

      bool validHeight;

      // Tall letters
      if ("fthl".contains(letter)) {
        validHeight = heightRatio > 0.45;
      }
      // Short letters
      else {
        validHeight = heightRatio < 0.65;
      }

      _letterCorrect[i] = validHeight;
      if (!validHeight) allCorrect = false;
    }

    setState(() {});
    return allCorrect;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _size = Size(constraints.maxWidth, constraints.maxHeight);
      final slots = widget.targetWord.length;

      return Column(
        children: [
          // ---------- SLOT GUIDES ----------
          SizedBox(
            height: 40,
            child: Row(
              children: List.generate(slots, (i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _letterCorrect[i] ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.targetWord[i],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          // ---------- CANVAS ----------
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final pos = box.globalToLocal(details.globalPosition);

                  if (pos.dx >= 0 &&
                      pos.dx <= _size.width &&
                      pos.dy >= 0 &&
                      pos.dy <= _size.height) {
                    setState(() => _points.add(pos));
                  }
                },
                onPanEnd: (_) => _points.add(Offset.zero),
                child: CustomPaint(
                  painter: _StrokePainter(_points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ---------- ACTIONS ----------
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  child: const Text("Clear"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validate()) {
                      widget.onCorrect();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Correct! ✅"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Some letters are incorrect ❌"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _StrokePainter extends CustomPainter {
  final List<Offset> points;
  _StrokePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
