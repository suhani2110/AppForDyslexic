import 'package:flutter/material.dart';
import '../../models/level_data.dart';
import '../../services/progress_service.dart';
import '../learning/level_words_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = LevelData.sampleLevels; // your existing data source

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // ---------- APP BAR ----------
      appBar: AppBar(
        title: const Text(
          "My Notebook",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFEAF7E8), // green shade
        elevation: 0,
      ),

      // ---------- BODY ----------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: levels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // ✅ 3 per row
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final level = levels[index];

            return ValueListenableBuilder(
              valueListenable: ProgressService.notifier,
              builder: (_, __, ___) {
                return FutureBuilder<bool>(
                  future: ProgressService.isLevelCompleted(level.words),
                  builder: (context, snapshot) {
                    final completed = snapshot.data ?? false;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LevelWordsPage(level: level),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: completed ? Colors.green : Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Text(
                          "Level ${level.levelId}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      ),
    );
  }
}
