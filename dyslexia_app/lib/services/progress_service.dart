import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _key = 'completed_words';

  static Future<Set<String>> getCompletedWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  static Future<void> markCompleted(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_key)?.toSet() ?? {};
    completed.add(word);
    await prefs.setStringList(_key, completed.toList());
  }

  static Future<bool> isCompleted(String word) async {
    final completed = await getCompletedWords();
    return completed.contains(word);
  }
}
