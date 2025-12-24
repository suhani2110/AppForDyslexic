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

  // ✅ bold ON by default
  bool boldText = true;

  Color backgroundColor = Colors.white;

  int highlightedWordIndex = -1;
  bool isReading = false;

  late List<String> words;

  @override
  void initState() {
    super.initState();

    words = widget.text.split(RegExp(r'\s+'));

    _tts.setLanguage("en-US");
    _tts.setPitch(1.0);
    _tts.setSpeechRate(speechRate);
    _tts.awaitSpeakCompletion(true);
  }

  Future<void> _readAloud() async {
    for (int i = 0; i < words.length; i++) {
      if (!mounted) return;

      setState(() => highlightedWordIndex = i);

      await _tts.stop(); // clear previous
      await _tts.speak(words[i]); // waits until spoken
    }

    setState(() => highlightedWordIndex = -1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Readable Text"),
      ),
      body: Column(
        children: [
          // ---------- TEXT AREA ----------
          Expanded(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 6,
                  children: List.generate(words.length, (index) {
                    final isHighlighted = index == highlightedWordIndex;

                    return Text(
                      words[index],
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight:
                            boldText ? FontWeight.bold : FontWeight.normal,
                        backgroundColor:
                            isHighlighted ? Colors.yellowAccent : null,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // ---------- CONTROLS ----------
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
                        onChanged: (v) => setState(() => fontSize = v),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Reading Speed"),
                    Expanded(
                      child: Slider(
                        min: 0.25,
                        max: 0.8,
                        value: speechRate,
                        onChanged: (v) {
                          setState(() => speechRate = v);
                          _tts.setSpeechRate(v);
                        },
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text("Bold text"),
                  value: boldText,
                  onChanged: (v) => setState(() => boldText = v),
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
