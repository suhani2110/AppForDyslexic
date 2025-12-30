import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechInputWidget extends StatefulWidget {
  final String targetWord;
  final void Function(bool correct) onSubmitted;

  const SpeechInputWidget({
    super.key,
    required this.targetWord,
    required this.onSubmitted,
  });

  @override
  State<SpeechInputWidget> createState() => _SpeechInputWidgetState();
}

class _SpeechInputWidgetState extends State<SpeechInputWidget> {
  final SpeechToText _stt = SpeechToText();
  String _recognized = '';
  bool _hasRecording = false;

  Future<void> _startListening() async {
    await _stt.initialize();
    _stt.listen(onResult: (result) {
      setState(() {
        _recognized = result.recognizedWords.toLowerCase().trim();
        _hasRecording = true;
      });
    });
  }

  void _stopListening() {
    _stt.stop();
  }

  void _submit() {
    final correct = _recognized == widget.targetWord.toLowerCase();
    widget.onSubmitted(correct);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPressStart: (_) => _startListening(),
              onLongPressEnd: (_) => _stopListening(),
              child: const CircleAvatar(
                radius: 26,
                child: Icon(Icons.mic),
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.play_arrow,
              color: _hasRecording ? Colors.black : Colors.grey,
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _hasRecording ? _submit : null,
              child: const Text("Submit Voice"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_hasRecording)
          Text(
            "You said: $_recognized",
            style: const TextStyle(fontSize: 14),
          ),
      ],
    );
  }
}
