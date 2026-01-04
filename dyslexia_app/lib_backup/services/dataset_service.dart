import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/level_data.dart';

class DatasetService {
  static Future<List<LevelData>> loadLevels() async {
    debugPrint("📦 Loading dataset...");

    final jsonString = await rootBundle.loadString('assets/data/levels.json');

    final List<dynamic> jsonList = json.decode(jsonString);

    final levels = jsonList.map((e) => LevelData.fromJson(e)).toList();

    debugPrint("✅ Loaded ${levels.length} levels");
    return levels;
  }
}
