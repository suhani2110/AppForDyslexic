class LevelData {
  final int levelId;
  final String difficulty;
  final String phonicsRule;
  final String wordPattern;
  final List<String> words;

  LevelData({
    required this.levelId,
    required this.difficulty,
    required this.phonicsRule,
    required this.wordPattern,
    required this.words,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      levelId: json['level_id'],
      difficulty: json['difficulty'],
      phonicsRule: json['phonics_rule'],
      wordPattern: json['word_pattern'],
      words: List<String>.from(json['words']),
    );
  }
}
