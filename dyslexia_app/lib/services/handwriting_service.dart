import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class HandwritingService {
  static final DigitalInkRecognizer _recognizer =
      DigitalInkRecognizer(languageCode: 'en-US');

  static Future<String?> recognize(
    List<List<StrokePoint>> strokes,
  ) async {
    if (strokes.isEmpty) return null;

    final ink = Ink();

    for (final strokePoints in strokes) {
      final stroke = Stroke();
      stroke.points.addAll(strokePoints);
      ink.strokes.add(stroke);
    }

    try {
      final candidates =
          await _recognizer.recognize(ink).timeout(const Duration(seconds: 3));

      if (candidates.isEmpty) return null;

      return candidates.first.text;
    } catch (e) {
      // ⛔ timeout OR ML failure
      return null;
    }
  }

  static Future<void> dispose() async {
    await _recognizer.close();
  }
}
