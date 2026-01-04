import 'package:flutter/material.dart';
import '../../services/tts_service.dart';

class ScanResultPage extends StatelessWidget {
  final String text;

  const ScanResultPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final TtsService tts = TtsService();

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Recognized Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text("Read Aloud"),
              onPressed: () => tts.speak(text),
            )
          ],
        ),
      ),
    );
  }
}
