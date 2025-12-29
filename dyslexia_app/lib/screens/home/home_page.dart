import 'package:flutter/material.dart';
import '../../services/dataset_service.dart';
import '../../models/level_data.dart';
import '../learning/level_words_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      appBar: AppBar(title: const Text("My Notebook")),
      body: FutureBuilder<List<LevelData>>(
        future: _levelsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final levels = snapshot.data!;

          return ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];

              return Card(
                child: ListTile(
                  title: Text("Level ${level.levelId}"),
                  subtitle: Text("${level.phonicsRule} words"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelWordsPage(level: level),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
