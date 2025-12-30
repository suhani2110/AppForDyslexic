import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _speech = SpeechToText();

  bool _initialized = false;

  Future<bool> init() async {
    _initialized = await _speech.initialize(
      onError: (_) {},
      onStatus: (_) {},
    );
    return _initialized;
  }

  Future<String> listenOnce() async {
    if (!_initialized) return "";

    String resultText = "";

    await _speech.listen(
      listenMode: ListenMode.confirmation,
      partialResults: false,
      onResult: (result) {
        if (result.finalResult) {
          resultText = result.recognizedWords;
        }
      },
    );

    // auto stop after short duration
    await Future.delayed(const Duration(seconds: 3));
    await _speech.stop();

    return resultText.toLowerCase().trim();
  }

  void dispose() {
    _speech.stop();
  }
}
