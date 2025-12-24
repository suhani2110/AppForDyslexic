import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ScanResultPage extends StatefulWidget {
  final String text;

  const ScanResultPage({super.key, required this.text});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  final FlutterTts _tts = FlutterTts();

  double fontSize = 22;
  double speechRate = 0.45;
  bool boldText = false;
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(speechRate);
  }

  Future<void> _readAloud() async {
    await _tts.stop();
    await _tts.setSpeechRate(speechRate);
    await _tts.speak(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Readable Text"),
      ),

      // 🔴 IMPORTANT FIX: Expanded + ScrollView
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: boldText ? FontWeight.bold : FontWeight.normal,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),

          // ---------- Controls ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Font Size"),
                    Expanded(
                      child: Slider(
                        min: 16,
                        max: 36,
                        value: fontSize,
                        onChanged: (v) {
                          setState(() => fontSize = v);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Reading Speed"),
                    Expanded(
                      child: Slider(
                        min: 0.2,
                        max: 0.8,
                        value: speechRate,
                        onChanged: (v) {
                          setState(() => speechRate = v);
                        },
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text("Bold text"),
                  value: boldText,
                  onChanged: (v) {
                    setState(() => boldText = v);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorButton(Colors.white),
                    _colorButton(Colors.yellow.shade100),
                    _colorButton(Colors.blue.shade50),
                    _colorButton(Colors.green.shade50),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _readAloud,
                  icon: const Icon(Icons.volume_up),
                  label: const Text("Read Aloud"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() => backgroundColor = color);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
