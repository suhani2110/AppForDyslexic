import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<String?> startRecording(String word) async {
    if (!await _recorder.hasPermission()) return null;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$word.wav';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: path,
    );

    return path;
  }

  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }
}
