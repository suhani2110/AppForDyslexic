import 'package:shared_preferences/shared_preferences.dart';

const String _fullyCompletedPrefix = 'fully_';

class ProgressService {
  static Future<void> markWordFullyCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fullyCompletedPrefix + word.toLowerCase(), true);
  }

  static Future<void> markWritingCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('writing_$word', true);
  }

  static Future<void> markSpeechCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('speech_$word', true);
  }

  static Future<bool> isWritingCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('writing_$word') ?? false;
  }

  static Future<bool> isSpeechCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('speech_$word') ?? false;
  }

  static Future<bool> isWordFullyCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_fullyCompletedPrefix + word.toLowerCase()) ?? false;
  }

  static Future<int> countFullyCompletedWords(List<String> words) async {
    int count = 0;
    for (final w in words) {
      if (await isWordFullyCompleted(w)) count++;
    }
    return count;
  }
}
