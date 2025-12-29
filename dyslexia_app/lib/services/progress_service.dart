import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static String _key(String levelId) => "level_${levelId}_done_words";

  static Future<Set<String>> getDoneWords(String levelId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key(levelId))?.toSet() ?? {};
  }

  static Future<void> markWordDone(String levelId, String word) async {
    final prefs = await SharedPreferences.getInstance();
    final done = await getDoneWords(levelId);
    done.add(word);
    await prefs.setStringList(_key(levelId), done.toList());
  }

  static Future<bool> isLevelComplete(
      String levelId, List<String> allWords) async {
    final done = await getDoneWords(levelId);
    return done.length == allWords.length;
  }
}
