import 'package:flutter/material.dart';
import '../../models/level_data.dart';
import '../../services/dataset_service.dart';
import '../learning/level_words_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<LevelData>> _levelsFuture;

  @override
  void initState() {
    super.initState();
    _levelsFuture = DatasetService.loadLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notebook"),
        backgroundColor: const Color(0xFFEAF7E8),
      ),
      body: FutureBuilder<List<LevelData>>(
        future: _levelsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final levels = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];

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
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "Level ${level.levelId}",
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
      ),
    );
  }
}
