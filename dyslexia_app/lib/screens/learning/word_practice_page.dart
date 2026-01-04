import 'package:flutter/material.dart';
import '../../services/tts_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/canvas/drawing_canvas.dart';

class WordPracticePage extends StatefulWidget {
  final String word;
  final List<String> words;
  final int index;

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
  final DrawingCanvasController _canvasController = DrawingCanvasController();

  bool writingDone = false;
  bool speechDone = false;

  Color backgroundColor = const Color(0xFFEAF7E8); // default green

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _checkFullyCompleted() async {
    if (writingDone && speechDone) {
      await ProgressService.markWordFullyCompleted(widget.word);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Word completed ✅")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastWord = widget.index == widget.words.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
        backgroundColor: Colors.white, // ✅ DIFFERENT FROM PAGE BG
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- BACKGROUND COLOR OPTIONS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bgOption(const Color(0xFFEAF7E8)),
                _bgOption(Colors.white),
                _bgOption(const Color(0xFFFFF3CD)),
                _bgOption(const Color(0xFFE3F2FD)),
              ],
            ),

            const SizedBox(height: 16),

            // ---------- WORD ----------
            Center(
              child: Text(
                widget.word,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- LETTER BLOCKS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.word
                  .toUpperCase()
                  .split('')
                  .map(
                    (c) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // ---------- HEAR ----------
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text("Hear"),
                onPressed: () => _tts.speak(widget.word),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------- SPEECH UI ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: speechDone ? Colors.green : Colors.grey,
                    size: 32,
                  ),
                  onPressed: () async {
                    setState(() => speechDone = true);
                    await _checkFullyCompleted();
                  },
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => speechDone = true);
                    await ProgressService.markSpeechCompleted(widget.word);
                    await _checkFullyCompleted();
                  },
                  child: const Text("Submit"),
                ),
              ],
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
                  border: Border.all(color: Colors.black26, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DrawingCanvas(
                  controller: _canvasController,
                  targetWord: widget.word,
                  onCorrect: () async {
                    setState(() => writingDone = true);
                    await ProgressService.markWritingCompleted(widget.word);
                    await _checkFullyCompleted();
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- ACTION BUTTONS ----------
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _canvasController.clear,
                    child: const Text("Clear"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canvasController.submit,
                    child: const Text("Submit"),
                  ),
                ),
                if (!isLastWord) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
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
                      },
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bgOption(Color color) {
    return GestureDetector(
      onTap: () => setState(() => backgroundColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}
