import 'package:flutter/material.dart';
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
  final DrawingCanvasController _canvasController = DrawingCanvasController();

  bool writingDone = false;
  bool speechDone = false; // placeholder for future
  bool locked = false;

  Future<void> _checkFullyCompleted() async {
    if (writingDone && speechDone) {
      await ProgressService.markWordFullyCompleted(widget.word);
      setState(() => locked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastWord = widget.index == widget.words.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7E8),
      appBar: AppBar(
        title: Text(widget.word),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // LETTER BLOCKS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.word
                .split('')
                .map(
                  (c) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
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

          const SizedBox(height: 20),

          // WRITING CANVAS
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DrawingCanvas(
                controller: _canvasController,
                targetWord: widget.word,
                onCorrect: () async {
                  writingDone = true;
                  await ProgressService.markWritingCompleted(widget.word);
                  await _checkFullyCompleted();
                },
              ),
            ),
          ),

          // ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _canvasController.clear();
                  },
                  child: const Text("Clear"),
                ),
                const SizedBox(width: 12),
                if (locked && !isLastWord)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
