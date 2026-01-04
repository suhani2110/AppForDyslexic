import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ProgressService {
  /// 🔔 GLOBAL NOTIFIER
  static final ValueNotifier<int> notifier = ValueNotifier(0);

  static String _writingKey(String word) => 'writing_$word';
  static String _speechKey(String word) => 'speech_$word';
  static String _fullKey(String word) => 'full_$word';

  // ---------- WRITING ----------
  static Future<void> markWritingCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_writingKey(word), true);
    notifier.value++;
  }

  static Future<bool> isWritingCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_writingKey(word)) ?? false;
  }

  // ---------- SPEECH ----------
  static Future<void> markSpeechCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_speechKey(word), true);
    notifier.value++;
  }

  static Future<bool> isSpeechCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_speechKey(word)) ?? false;
  }

  // ---------- FULL WORD ----------
  static Future<void> markWordFullyCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fullKey(word), true);
    notifier.value++;
  }

  static Future<bool> isWordFullyCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_fullKey(word)) ?? false;
  }

  // ---------- LEVEL ----------
  static Future<int> countFullyCompletedWords(List<String> words) async {
    int count = 0;
    for (final w in words) {
      if (await isWordFullyCompleted(w)) count++;
    }
    return count;
  }

  static Future<bool> isLevelCompleted(List<String> words) async {
    for (final w in words) {
      if (!await isWordFullyCompleted(w)) return false;
    }
    return true;
  }
}
