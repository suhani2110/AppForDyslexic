class LevelData {
  final int levelId;
  final String difficulty;
  final String phonicsRule;
  final List<String> words;

  LevelData({
    required this.levelId,
    required this.difficulty,
    required this.phonicsRule,
    required this.words,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      levelId: json['level_id'],
      difficulty: json['difficulty'],
      phonicsRule: json['phonics_rule'],
      words: List<String>.from(json['words']),
    );
  }

  // ✅ ADD THIS
  static final List<LevelData> sampleLevels = [
    LevelData(
      levelId: 1,
      difficulty: 'Easy',
      phonicsRule: 'CVC words',
      words: ['cat', 'dog', 'fan'],
    ),
    LevelData(
      levelId: 2,
      difficulty: 'Easy',
      phonicsRule: 'Short vowels',
      words: ['sun', 'mat', 'pen'],
    ),
    LevelData(
      levelId: 3,
      difficulty: 'Medium',
      phonicsRule: 'Blends',
      words: ['frog', 'stop', 'clap'],
    ),
  ];
}
