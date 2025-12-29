import 'package:flutter/material.dart';
import '../../services/tts_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/canvas/drawing_canvas.dart';

class WordPracticePage extends StatefulWidget {
  final String word;

  const WordPracticePage({super.key, required this.word});

  @override
  State<WordPracticePage> createState() => _WordPracticePageState();
}

class _WordPracticePageState extends State<WordPracticePage> {
  final TtsService _tts = TtsService();

  Color backgroundColor = Colors.white;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    completed = await ProgressService.isCompleted(widget.word);
    setState(() {});
  }

  Future<void> _markCompleted() async {
    if (completed) return;

    await ProgressService.markCompleted(widget.word);
    setState(() => completed = true);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
        actions: [
          Icon(
            completed ? Icons.check_circle : Icons.circle_outlined,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // WORD
            Text(
              widget.word,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // BACKGROUND COLORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorButton(Colors.white),
                _colorButton(Colors.yellow.shade100),
                _colorButton(Colors.blue.shade50),
                _colorButton(Colors.green.shade50),
              ],
            ),

            const SizedBox(height: 16),

            // TTS
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text("Hear Pronunciation"),
              onPressed: () => _tts.speak(widget.word),
            ),

            const SizedBox(height: 20),

            const Text(
              "Write the word:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            // ✅ CANVAS (FIXED)
            Expanded(
              child: DrawingCanvas(
                targetWord: widget.word,
                onCorrect: _markCompleted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => backgroundColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}
