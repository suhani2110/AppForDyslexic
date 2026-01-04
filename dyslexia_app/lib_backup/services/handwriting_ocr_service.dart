import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class HandwritingOcrService {
  static Future<String> recognize(Uint8List pngBytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/handwriting.png');
    await file.writeAsBytes(pngBytes);

    final inputImage = InputImage.fromFile(file);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final result = await recognizer.processImage(inputImage);
    await recognizer.close();

    return result.text;
  }
}
