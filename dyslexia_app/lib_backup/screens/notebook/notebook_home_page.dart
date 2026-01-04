import 'package:flutter/material.dart';
import 'sample_lessons.dart';
import 'notebook_entry_page.dart';

class NotebookHomePage extends StatelessWidget {
  const NotebookHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notebook")),
      body: ListView.builder(
        itemCount: sampleLessons.length,
        itemBuilder: (context, index) {
          final lesson = sampleLessons[index];
          return ListTile(
            title: Text(lesson["title"]!),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotebookEntryPage(
                    title: lesson["title"]!,
                    content: lesson["content"]!,
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
