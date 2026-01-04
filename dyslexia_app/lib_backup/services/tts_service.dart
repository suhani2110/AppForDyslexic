import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  late FlutterTts _tts;

  TtsService._internal() {
    _tts = FlutterTts();
    _configure();
  }

  void _configure() {
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.45);
    _tts.setPitch(1.0);
    _tts.awaitSpeakCompletion(false); // 🔑 DO NOT BLOCK
  }

  Future<void> speak(String text) async {
    await _tts.stop(); // clear any queued audio
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
