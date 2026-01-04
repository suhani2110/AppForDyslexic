import 'package:flutter/material.dart';
import '../../models/level_data.dart';
import '../../services/progress_service.dart';
import 'word_practice_page.dart'; // ✅ REQUIRED IMPORT

class LevelWordsPage extends StatelessWidget {
  final LevelData level;

  const LevelWordsPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${level.levelId}"),
        backgroundColor: const Color(0xFFEAF7E8),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: level.words.length,
        itemBuilder: (context, index) {
          final word = level.words[index];

          return ValueListenableBuilder(
            valueListenable: ProgressService.notifier,
            builder: (_, __, ___) {
              return FutureBuilder<bool>(
                future: ProgressService.isWordFullyCompleted(word),
                builder: (context, snapshot) {
                  final completed = snapshot.data ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WordPracticePage(
                            word: word,
                            words: level.words,
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: completed ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
