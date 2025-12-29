import 'package:flutter/material.dart';
import '../../models/level_data.dart';
import '../../services/progress_service.dart';
import 'word_practice_page.dart';

class LevelWordsPage extends StatefulWidget {
  final LevelData level;

  const LevelWordsPage({super.key, required this.level});

  @override
  State<LevelWordsPage> createState() => _LevelWordsPageState();
}

class _LevelWordsPageState extends State<LevelWordsPage> {
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${widget.level.levelId}"),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- PHONICS RULE ----------
            Text(
              widget.level.phonicsRule,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // ---------- COLOR OVERLAYS ----------
            Row(
              children: [
                _colorButton(Colors.white),
                _colorButton(Colors.yellow.shade100),
                _colorButton(Colors.blue.shade50),
                _colorButton(Colors.green.shade50),
              ],
            ),

            const SizedBox(height: 16),

            // ---------- WORD GRID ----------
            Expanded(
              child: GridView.builder(
                itemCount: widget.level.words.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, index) {
                  final word = widget.level.words[index];

                  return FutureBuilder<bool>(
                    future: ProgressService.isCompleted(word),
                    builder: (context, snapshot) {
                      final completed = snapshot.data ?? false;

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WordPracticePage(word: word),
                            ),
                          );
                          setState(() {}); // refresh progress
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: completed
                                ? Colors.green.shade300
                                : Colors.orange.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            word,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() => backgroundColor = color);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
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
