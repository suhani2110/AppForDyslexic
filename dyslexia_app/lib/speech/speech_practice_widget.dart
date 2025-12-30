import 'package:flutter/material.dart';

import '../../services/tts_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/canvas/drawing_canvas.dart';
import '../../widgets/speech/speech_practice_widget.dart';

class WordPracticePage extends StatefulWidget {
  final String word;
  final List<String> words; // full word list
  final int index; // current word index

  const WordPracticePage({
    super.key,
    required this.word,
    required this.words,
    required this.index,
  });

  @override
  State<WordPracticePage> createState() => _WordPracticePageState();
}

class _WordPracticePageState extends State<WordPracticePage> {
  final TtsService _tts = TtsService();

  // default → green shade
  Color backgroundColor = const Color(0xFFE8F5E9);

  bool writingDone = false;
  bool speechDone = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    writingDone = await ProgressService.isWritingCompleted(widget.word);
    speechDone = await ProgressService.isSpeechCompleted(widget.word);
    setState(() {});
  }

  Future<void> _onWritingCorrect() async {
    await ProgressService.markWritingCompleted(widget.word);
    setState(() => writingDone = true);
  }

  Future<void> _onSpeechCorrect() async {
    await ProgressService.markSpeechCompleted(widget.word);
    setState(() => speechDone = true);
  }

  bool get fullyCompleted => writingDone && speechDone;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastWord = widget.index == widget.words.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
        backgroundColor: const Color(0xFFE8F5E9),
        actions: [
          if (fullyCompleted)
            const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- WORD ----------
            Center(
              child: Text(
                widget.word,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- LETTER BLOCKS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.word
                  .split('')
                  .map(
                    (c) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        c.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // ---------- BACKGROUND COLORS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorButton(Colors.white),
                _colorButton(Colors.yellow.shade100),
                _colorButton(Colors.blue.shade50),
                _colorButton(const Color(0xFFE8F5E9)),
              ],
            ),

            const SizedBox(height: 16),

            // ---------- TTS ----------
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.volume_up),
                label: const Text("Hear"),
                onPressed: () => _tts.speak(widget.word),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- SPEECH ----------
            SpeechPracticeWidget(
              targetWord: widget.word,
              onCorrect: _onSpeechCorrect,
            ),

            const SizedBox(height: 20),

            const Text(
              "Write the word:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            // ---------- CANVAS ----------
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black38, width: 1.5),
                ),
                child: DrawingCanvas(
                  targetWord: widget.word,
                  onCorrect: _onWritingCorrect,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- ACTION BUTTONS ----------
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => DrawingCanvasController.clear?.call(),
                    child: const Text("Clear"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: fullyCompleted ? null : () {},
                    child: const Text("Submit"),
                  ),
                ),
                if (!isLastWord) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: fullyCompleted
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WordPracticePage(
                                    word: widget.words[widget.index + 1],
                                    words: widget.words,
                                    index: widget.index + 1,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Next"),
                    ),
                  ),
                ]
              ],
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
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}
