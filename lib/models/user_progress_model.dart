import 'dart:convert';
import 'typing_models.dart';
import 'world_model.dart';

class LetterStat {
  int attempts;
  int errors;

  LetterStat({this.attempts = 0, this.errors = 0});

  Map<String, dynamic> toJson() => {
    'attempts': attempts,
    'errors': errors,
  };

  factory LetterStat.fromJson(Map<String, dynamic> json) => LetterStat(
    attempts: json['attempts'] ?? 0,
    errors: json['errors'] ?? 0,
  );
}

class BadgeInfo {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;

  const BadgeInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
  });
}

class UserProgress {
  int totalKeystrokes;
  int correctKeystrokes;
  int totalWordsTyped;
  int totalPracticeSeconds;
  StageId currentStage;
  WorldId currentWorldId;
  Map<String, int> stageProgress;
  Map<String, int> worldBaseCompleted;
  Map<String, List<String>> worldCompletedAiIds;
  Map<String, AiExercise> aiExercises;
  Map<String, LetterStat> letterStats;
  int starsEarned;
  List<String> badges;
  String lastPracticeDate;

  UserProgress({
    this.totalKeystrokes = 0,
    this.correctKeystrokes = 0,
    this.totalWordsTyped = 0,
    this.totalPracticeSeconds = 0,
    this.currentStage = StageId.alphabet,
    this.currentWorldId = WorldId.meadow_of_letters,
    Map<String, int>? stageProgress,
    Map<String, int>? worldBaseCompleted,
    Map<String, List<String>>? worldCompletedAiIds,
    Map<String, AiExercise>? aiExercises,
    Map<String, LetterStat>? letterStats,
    this.starsEarned = 0,
    List<String>? badges,
    String? lastPracticeDate,
  })  : stageProgress = stageProgress ?? {
          'alphabet': 0,
          'words': 0,
          'sentences': 0,
          'paragraphs': 0,
        },
        worldBaseCompleted = worldBaseCompleted ?? {},
        worldCompletedAiIds = worldCompletedAiIds ?? {},
        aiExercises = aiExercises ?? {},
        letterStats = letterStats ?? {},
        badges = badges ?? [],
        lastPracticeDate = lastPracticeDate ?? DateTime.now().toIso8601String();

  double get accuracy => totalKeystrokes > 0
      ? ((correctKeystrokes / totalKeystrokes) * 100).clamp(0.0, 100.0)
      : 100.0;

  int? get wpm {
    if (totalKeystrokes < 25) return null;
    final minutes = (totalPracticeSeconds / 60.0).clamp(0.1, 1000.0);
    final words = correctKeystrokes / 5.0;
    return (words / minutes).round().clamp(0, 65);
  }

  Map<String, dynamic> toJson() => {
    'totalKeystrokes': totalKeystrokes,
    'correctKeystrokes': correctKeystrokes,
    'totalWordsTyped': totalWordsTyped,
    'totalPracticeSeconds': totalPracticeSeconds,
    'currentStage': currentStage.name,
    'currentWorldId': currentWorldId.name,
    'stageProgress': stageProgress,
    'worldBaseCompleted': worldBaseCompleted,
    'worldCompletedAiIds': worldCompletedAiIds,
    'aiExercises': aiExercises.map((k, v) => MapEntry(k, v.toJson())),
    'letterStats': letterStats.map((k, v) => MapEntry(k, v.toJson())),
    'starsEarned': starsEarned,
    'badges': badges,
    'lastPracticeDate': lastPracticeDate,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    Map<String, AiExercise> exercises = {};
    if (json['aiExercises'] != null) {
      (json['aiExercises'] as Map<String, dynamic>).forEach((k, v) {
        exercises[k] = AiExercise.fromJson(v as Map<String, dynamic>);
      });
    }

    Map<String, LetterStat> stats = {};
    if (json['letterStats'] != null) {
      (json['letterStats'] as Map<String, dynamic>).forEach((k, v) {
        stats[k] = LetterStat.fromJson(v as Map<String, dynamic>);
      });
    }

    Map<String, List<String>> aiIds = {};
    if (json['worldCompletedAiIds'] != null) {
      (json['worldCompletedAiIds'] as Map<String, dynamic>).forEach((k, v) {
        aiIds[k] = List<String>.from(v ?? []);
      });
    }

    return UserProgress(
      totalKeystrokes: json['totalKeystrokes'] ?? 0,
      correctKeystrokes: json['correctKeystrokes'] ?? 0,
      totalWordsTyped: json['totalWordsTyped'] ?? 0,
      totalPracticeSeconds: json['totalPracticeSeconds'] ?? 0,
      currentStage: StageId.values.firstWhere(
        (e) => e.name == json['currentStage'],
        orElse: () => StageId.alphabet,
      ),
      currentWorldId: WorldId.values.firstWhere(
        (e) => e.name == json['currentWorldId'],
        orElse: () => WorldId.meadow_of_letters,
      ),
      stageProgress: Map<String, int>.from(json['stageProgress'] ?? {}),
      worldBaseCompleted: Map<String, int>.from(json['worldBaseCompleted'] ?? {}),
      worldCompletedAiIds: aiIds,
      aiExercises: exercises,
      letterStats: stats,
      starsEarned: json['starsEarned'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
      lastPracticeDate: json['lastPracticeDate'] ?? DateTime.now().toIso8601String(),
    );
  }
}
