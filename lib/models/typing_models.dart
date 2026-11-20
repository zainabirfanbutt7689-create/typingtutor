enum StageId {
  alphabet,
  words,
  sentences,
  paragraphs,
}

class AlphabetItem {
  final String id;
  final String char;
  final String uppercase;
  final String lowercase;
  final String wordSample;
  final String phonics;
  final String? urduPhonics;
  final String icon;

  const AlphabetItem({
    required this.id,
    required this.char,
    required this.uppercase,
    required this.lowercase,
    required this.wordSample,
    required this.phonics,
    this.urduPhonics,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'char': char,
    'uppercase': uppercase,
    'lowercase': lowercase,
    'wordSample': wordSample,
    'phonics': phonics,
    'urduPhonics': urduPhonics,
    'icon': icon,
  };

  factory AlphabetItem.fromJson(Map<String, dynamic> json) => AlphabetItem(
    id: json['id'] ?? '',
    char: json['char'] ?? '',
    uppercase: json['uppercase'] ?? '',
    lowercase: json['lowercase'] ?? '',
    wordSample: json['wordSample'] ?? '',
    phonics: json['phonics'] ?? '',
    urduPhonics: json['urduPhonics'],
    icon: json['icon'] ?? '',
  );
}

class WordItem {
  final String id;
  final String word;
  final String category;
  final String phonics;
  final String? urduMeaning;
  final String hint;
  final String svgIcon;

  const WordItem({
    required this.id,
    required this.word,
    required this.category,
    required this.phonics,
    this.urduMeaning,
    required this.hint,
    required this.svgIcon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'category': category,
    'phonics': phonics,
    'urduMeaning': urduMeaning,
    'hint': hint,
    'svgIcon': svgIcon,
  };

  factory WordItem.fromJson(Map<String, dynamic> json) => WordItem(
    id: json['id'] ?? '',
    word: json['word'] ?? '',
    category: json['category'] ?? '',
    phonics: json['phonics'] ?? '',
    urduMeaning: json['urduMeaning'],
    hint: json['hint'] ?? '',
    svgIcon: json['svgIcon'] ?? '',
  );
}

class SentenceItem {
  final String id;
  final String sentence;
  final String theme;
  final int wordCount;

  const SentenceItem({
    required this.id,
    required this.sentence,
    required this.theme,
    required this.wordCount,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sentence': sentence,
    'theme': theme,
    'wordCount': wordCount,
  };

  factory SentenceItem.fromJson(Map<String, dynamic> json) => SentenceItem(
    id: json['id'] ?? '',
    sentence: json['sentence'] ?? '',
    theme: json['theme'] ?? '',
    wordCount: json['wordCount'] ?? 4,
  );
}

class ParagraphItem {
  final String id;
  final String title;
  final List<String> sentences;
  final String theme;

  const ParagraphItem({
    required this.id,
    required this.title,
    required this.sentences,
    required this.theme,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'sentences': sentences,
    'theme': theme,
  };

  factory ParagraphItem.fromJson(Map<String, dynamic> json) => ParagraphItem(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    sentences: List<String>.from(json['sentences'] ?? []),
    theme: json['theme'] ?? '',
  );
}

class AiExercise {
  final String id;
  final String worldId;
  final String worldName;
  final String activityType;
  final String title;
  final String text;
  final String? hint;
  final String? phonicsHint;
  final String? focusLetter;
  bool completed;
  String? completedAt;
  final int starsReward;

  AiExercise({
    required this.id,
    required this.worldId,
    required this.worldName,
    required this.activityType,
    required this.title,
    required this.text,
    this.hint,
    this.phonicsHint,
    this.focusLetter,
    this.completed = false,
    this.completedAt,
    this.starsReward = 3,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'worldId': worldId,
    'worldName': worldName,
    'activityType': activityType,
    'title': title,
    'text': text,
    'hint': hint,
    'phonicsHint': phonicsHint,
    'focusLetter': focusLetter,
    'completed': completed,
    'completedAt': completedAt,
    'starsReward': starsReward,
  };

  factory AiExercise.fromJson(Map<String, dynamic> json) => AiExercise(
    id: json['id'] ?? '',
    worldId: json['worldId'] ?? '',
    worldName: json['worldName'] ?? '',
    activityType: json['activityType'] ?? 'words',
    title: json['title'] ?? '',
    text: json['text'] ?? '',
    hint: json['hint'],
    phonicsHint: json['phonicsHint'],
    focusLetter: json['focusLetter'],
    completed: json['completed'] ?? false,
    completedAt: json['completedAt'],
    starsReward: json['starsReward'] ?? 3,
  );
}
