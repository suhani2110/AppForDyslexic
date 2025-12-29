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
  Color bg = Colors.white;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    completed = await ProgressService.isCompleted(widget.word);
    setState(() {});
  }

  Future<void> _markCompleted() async {
    await ProgressService.markCompleted(widget.word);
    setState(() => completed = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Correct!")),
    );
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
        color: bg,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.word,
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _color(Colors.white),
                _color(Colors.yellow.shade100),
                _color(Colors.blue.shade50),
                _color(Colors.green.shade50),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _tts.speak(widget.word),
              icon: const Icon(Icons.volume_up),
              label: const Text("Hear Pronunciation"),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Write the word:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
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

  Widget _color(Color c) => GestureDetector(
        onTap: () => setState(() => bg = c),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black26),
          ),
        ),
      );
}
