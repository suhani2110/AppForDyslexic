import 'package:flutter/material.dart';
import '../../services/tts_service.dart';
import '../../widgets/canvas/drawing_canvas.dart';

class WordPracticePage extends StatefulWidget {
  final String word;

  const WordPracticePage({
    super.key,
    required this.word,
  });

  @override
  State<WordPracticePage> createState() => _WordPracticePageState();
}

class _WordPracticePageState extends State<WordPracticePage> {
  // ✅ SINGLE TTS INSTANCE (NO DELAY)
  final TtsService _tts = TtsService();

  // UI states
  Color backgroundColor = Colors.white;

  @override
  void dispose() {
    _tts.stop(); // safety cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- WORD DISPLAY ----------
            Center(
              child: Text(
                widget.word,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- HEAR PRONUNCIATION ----------
            ElevatedButton.icon(
              onPressed: () => _tts.speak(widget.word),
              icon: const Icon(Icons.volume_up),
              label: const Text("Hear Pronunciation"),
            ),

            const SizedBox(height: 12),

            // ---------- BACKGROUND COLOR OPTIONS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorButton(Colors.white),
                _colorButton(Colors.yellow.shade100),
                _colorButton(Colors.blue.shade50),
                _colorButton(Colors.green.shade50),
              ],
            ),

            const SizedBox(height: 20),

            // ---------- WRITING CANVAS ----------
            const Text(
              "Write the word below:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            const DrawingCanvas(),

            const Spacer(),

            // ---------- SUBMIT (LOGIC LATER) ----------
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Submission logic coming next"),
                  ),
                );
              },
              child: const Text("Submit"),
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}
