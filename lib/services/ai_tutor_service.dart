
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/typing_models.dart';
import '../models/world_model.dart';
import '../data/worlds_data.dart';

class AiTutorService {
  /// Optional user-configured Gemini API Key
  /// Can be set via settings or environment: --dart-define=GEMINI_API_KEY=YOUR_KEY
  static String geminiApiKey = const String.fromEnvironment('GEMINI_API_KEY');

  /// Optional backend proxy URL (matches Express server endpoints if available)
  static String backendUrl = const String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://10.0.2.2:3000', // Standard Android emulator localhost
  );

  /// Requests personalized coaching cheer & recommendation from Gemini AI
  static Future<Map<String, dynamic>> getAiRecommendation({
    required StageId currentStage,
    required double accuracy,
    required List<String> trickyLetters,
    String childName = 'Little Champion',
    String theme = 'animals',
  }) async {
    // 1. Try Gemini REST API if apiKey is configured
    if (geminiApiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$geminiApiKey',
        );

        final prompt = '''You are a warm, encouraging, child-friendly typing coach for an educational app called "BISMA".
Child info:
- Name: "$childName"
- Current Stage: ${currentStage.name} (alphabet, words, sentences, paragraphs)
- Current Accuracy: ${accuracy.toStringAsFixed(0)}%
- Tricky letters: ${trickyLetters.isNotEmpty ? trickyLetters.join(', ') : 'None, doing great!'}
- Favorite theme: $theme

Generate a short encouraging 1-2 sentence cheer for the child (max 25 words), AND a customized practice focus for their tricky letters in their theme.
Return JSON ONLY with this exact format:
{
  "cheer": "Friendly cheer message",
  "focusLetter": "Letter to practice",
  "targetPractice": "word or sentence matching stage",
  "phonicsHint": "short fun phonics rhyme"
}''';

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'responseMimeType': 'application/json',
              'temperature': 0.7,
            }
          }),
        ).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '{}';
          final parsed = jsonDecode(text);
          return {
            'source': 'gemini-ai',
            'cheer': parsed['cheer'] ?? 'Keep typing like a champion!',
            'focusLetter': parsed['focusLetter'] ?? (trickyLetters.isNotEmpty ? trickyLetters.first : 'A'),
            'targetPractice': parsed['targetPractice'] ?? 'STAR',
            'phonicsHint': parsed['phonicsHint'] ?? 'Press keys gently like bubble pops!',
          };
        }
      } catch (_) {
        // Fall through to backend or rule engine
      }
    }

    // 2. Try backend API proxy if reachable
    try {
      final backendUri = Uri.parse('$backendUrl/api/ai-tutor');
      final res = await http.post(
        backendUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentStage': currentStage.name,
          'accuracy': accuracy.toInt(),
          'trickyLetters': trickyLetters,
          'childName': childName,
          'theme': theme,
        }),
      ).timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}

    // 3. Fallback to on-device rule engine
    return _generateLocalRecommendation(currentStage, accuracy, trickyLetters, theme);
  }

  /// Generates a brand new AI Typing Exercise matching the selected world & child stats
  static Future<AiExercise> generateAiExercise({
    required WorldId worldId,
    required double accuracy,
    required List<String> trickyLetters,
    String childName = 'Champion',
    String theme = 'nature',
  }) async {
    final worldInfo = kWorlds.firstWhere(
          (w) => w.id == worldId,
      orElse: () => kWorlds.first,
    );

    final stableId = 'ai-${worldId.name}-${DateTime.now().millisecondsSinceEpoch}';

    // 1. Direct Gemini AI API call
    if (geminiApiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$geminiApiKey',
        );

        final prompt = '''You are an educational AI typing content creator for the child-friendly typing game "BISMA".
Generate a single child-friendly typing exercise for:
- World: "${worldInfo.title}" (${worldId.name})
- Activity Type: "${worldInfo.activityType}"
- Tricky letters to incorporate: ${trickyLetters.isNotEmpty ? trickyLetters.join(', ') : 'any'}
- Child Name: "$childName"
- Theme: "$theme"

Rules:
1. For 'alphabet': 1 uppercase letter. Focus on tricky letter.
2. For 'words': 1 simple child word (3-6 uppercase letters).
3. For 'punctuation': 1 child sentence (4-7 words) with comma and period. E.g. "Look, a blue star is shining."
4. For 'sentences': 1 cheerful animal or safari sentence (4-7 words).
5. For 'stories': 2 short connected sentences (total 10-18 words) about a friendly castle or animal adventure.
6. For 'paragraphs': 2 connected descriptive sentences (total 12-20 words) about an island or nature paradise.
7. For 'creative': 1 imaginative whimsical sentence or rhyme (6-12 words).
8. For 'mixed': 1 lively challenge sentence (6-10 words) highlighting good typing technique.

Return JSON ONLY:
{
  "title": "Creative short title (2-4 words)",
  "text": "The exact text to type",
  "hint": "Child-friendly hint (max 10 words)",
  "phonicsHint": "Short pronunciation or finger position clue",
  "focusLetter": "Single letter or empty"
}''';

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'responseMimeType': 'application/json',
              'temperature': 0.7,
            }
          }),
        ).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '{}';
          final parsed = jsonDecode(text);

          return AiExercise(
            id: stableId,
            worldId: worldId.name,
            worldName: worldInfo.title,
            activityType: worldInfo.activityType,
            title: parsed['title'] ?? 'Magical ${worldInfo.title} Exercise',
            text: parsed['text'] ?? 'STAR',
            hint: parsed['hint'] ?? 'Type gently with happy fingers!',
            phonicsHint: parsed['phonicsHint'] ?? 'Relax and enjoy typing!',
            focusLetter: parsed['focusLetter'] ?? (trickyLetters.isNotEmpty ? trickyLetters.first : 'S'),
            completed: false,
            starsReward: worldInfo.baseTargetCount > 10 ? 3 : 5,
          );
        }
      } catch (_) {}
    }

    // 2. Backend proxy call
    try {
      final backendUri = Uri.parse('$backendUrl/api/ai-exercise');
      final res = await http.post(
        backendUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'worldId': worldId.name,
          'activityType': worldInfo.activityType,
          'accuracy': accuracy.toInt(),
          'trickyLetters': trickyLetters,
          'childName': childName,
          'theme': theme,
        }),
      ).timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        return AiExercise.fromJson(decoded);
      }
    } catch (_) {}

    // 3. Fallback to on-device generator
    return _generateLocalAiExercise(worldId, worldInfo, trickyLetters, stableId);
  }

  static Map<String, dynamic> _generateLocalRecommendation(
    StageId stage,
    double accuracy,
    List<String> trickyLetters,
    String theme,
  ) {
    final focus = trickyLetters.isNotEmpty ? trickyLetters.first.toUpperCase() : 'A';
    final cheer = accuracy >= 88
        ? 'Superstar typist! Your fingers are moving with great confidence!'
        : 'You are making wonderful progress! Let\'s practice key "$focus" with gentle high-fives!';

    return {
      'source': 'offline-rule-engine',
      'cheer': cheer,
      'focusLetter': focus,
      'targetPractice': stage == StageId.alphabet ? focus : 'STAR',
      'phonicsHint': '$focus makes a playful sound! Tap it with a gentle touch.',
    };
  }

  static AiExercise _generateLocalAiExercise(
    WorldId worldId,
    WorldInfo info,
    List<String> trickyLetters,
    String stableId,
  ) {
    final focus = trickyLetters.isNotEmpty ? trickyLetters.first.toUpperCase() : 'S';

    switch (worldId) {
      case WorldId.meadow_of_letters:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'alphabet',
          title: 'Magical Letter $focus',
          text: focus,
          hint: 'Find and tap the glowing letter "$focus"!',
          phonicsHint: '$focus says its playful sound!',
          focusLetter: focus,
          completed: false,
          starsReward: 2,
        );

      case WorldId.forest_of_words:
        const words = ['BIRD', 'FROG', 'BEAR', 'MOON', 'STAR', 'LEAF', 'TREE', 'ROSE'];
        final word = words.firstWhere((w) => w.contains(focus), orElse: () => 'STAR');
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'words',
          title: 'Forest Phonics: $word',
          text: word,
          hint: 'Type all letters of $word smoothly!',
          phonicsHint: '${word.split('').join(' - ')} ($word)',
          focusLetter: focus,
          completed: false,
          starsReward: 3,
        );

      case WorldId.rainbow_bridge:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'punctuation',
          title: 'Rainbow Precision Practice',
          text: 'Look, a purple butterfly is dancing.',
          hint: 'Remember the comma pause and ending dot!',
          phonicsHint: 'Tap spacebar gently between each word.',
          completed: false,
          starsReward: 4,
        );

      case WorldId.castle_of_stories:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'stories',
          title: 'Royal Castle Tale',
          text: 'Prince Bisma explored the sparkling castle tower. The royal owl hooted a gentle song.',
          hint: 'Take your time typing each charming sentence.',
          phonicsHint: 'Keep a calm, steady rhythm like reading a storybook.',
          completed: false,
          starsReward: 5,
        );

      case WorldId.sentence_safari:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'sentences',
          title: 'Wild Safari Journey',
          text: 'A playful cheetah cub runs across the savanna.',
          hint: 'Type each word with safari speed and joy!',
          phonicsHint: 'Capital letter first, dot at the finish line!',
          completed: false,
          starsReward: 3,
        );

      case WorldId.paragraph_paradise:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'paragraphs',
          title: 'Tropical Island Dream',
          text: 'Warm ocean breezes gently swayed the coconut palms on the island. Tiny golden crabs built sandcastles while dolphins leaped playfully in the azure waves.',
          hint: 'Enjoy the tropical story and type line by line.',
          phonicsHint: 'Breathe smoothly and let your fingers glide.',
          completed: false,
          starsReward: 5,
        );

      case WorldId.creative_writing:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'creative',
          title: 'Imagination Wonder Spark',
          text: 'If I had a flying cloud, I would draw smiley faces in the sky.',
          hint: 'Let your creativity sparkle as you type!',
          phonicsHint: 'Each typed word brings your imagination to life!',
          completed: false,
          starsReward: 4,
        );

      case WorldId.champion_world:
      default:
        return AiExercise(
          id: stableId,
          worldId: worldId.name,
          worldName: info.title,
          activityType: 'mixed',
          title: 'Champion Crown Challenge',
          text: 'Champion fingers type with swift precision and joyful confidence.',
          hint: 'Master level challenge! You have got this!',
          phonicsHint: 'Stay steady, smooth, and proud!',
          completed: false,
          starsReward: 5,
        );
    }
  }
}
