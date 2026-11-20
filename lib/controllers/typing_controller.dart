import 'dart:async';
import 'package:flutter/material.dart';
import '../models/typing_models.dart';
import '../models/world_model.dart';
import '../models/companion_model.dart';
import '../models/user_progress_model.dart';
import '../models/app_settings_model.dart';
import '../data/alphabet_data.dart';
import '../data/word_data.dart';
import '../data/sentence_data.dart';
import '../data/paragraph_data.dart';
import '../data/companion_data.dart';
import '../data/worlds_data.dart';
import '../services/sound_service.dart';
import '../services/tts_service.dart';
import '../services/storage_service.dart';
import '../services/ai_tutor_service.dart';

enum CompanionMood {
  idle,
  happy,
  celebrate,
  thinking,
}

class TypingController extends ChangeNotifier {
  late UserProgress progress;
  late AppSettings settings;

  // Navigation State
  bool isGameStarted = false;
  bool isGeneratingAi = false;

  // Active stage & world
  StageId currentStage = StageId.alphabet;
  WorldId currentWorldId = WorldId.meadow_of_letters;
  AiExercise? activeAiExercise;

  // Progression indices
  int alphabetIndex = 0;
  int wordIndex = 0;
  int sentenceIndex = 0;
  int paragraphIndex = 0;
  int paragraphSentenceStep = 0;

  // Typing input
  String userInput = '';
  String? lastPressedKey;
  int streakCount = 0;

  // Companion mood and speech
  CompanionMood companionMood = CompanionMood.idle;
  String companionSpeech = 'Welcome to BISMA! Tap the glowing key!';
  String aiCoachCheer = '';

  Timer? _practiceTimer;

  TypingController() {
    progress = StorageService.loadProgress();
    settings = StorageService.loadSettings();

    currentStage = progress.currentStage;
    currentWorldId = progress.currentWorldId;

    if (progress.stageProgress['alphabet'] != null) {
      alphabetIndex = progress.stageProgress['alphabet']! % kAlphabetList.length;
    }
    if (progress.stageProgress['words'] != null) {
      wordIndex = progress.stageProgress['words']! % kWordList.length;
    }
    if (progress.stageProgress['sentences'] != null) {
      sentenceIndex = progress.stageProgress['sentences']! % kSentenceList.length;
    }
    if (progress.stageProgress['paragraphs'] != null) {
      paragraphIndex = progress.stageProgress['paragraphs']! % kParagraphList.length;
    }

    _applySettings();
  }

  void _applySettings() {
    SoundService.setMuted(!settings.soundEnabled);
    SoundService.setVolume(settings.soundVolume);
    TtsService.setEnabled(settings.ttsEnabled);
  }

  void startGame() {
    isGameStarted = true;
    SoundService.playCorrect();
    companionSpeech = 'Tap the glowing letter to start!';
    _startTimer();
    notifyListeners();
  }

  void backToWelcome() {
    isGameStarted = false;
    _stopTimer();
    notifyListeners();
  }

  void _startTimer() {
    _practiceTimer?.cancel();
    _practiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      progress.totalPracticeSeconds++;
      if (progress.totalPracticeSeconds % 30 == 0) {
        StorageService.saveProgress(progress);
      }
      notifyListeners();
    });
  }

  void _stopTimer() {
    _practiceTimer?.cancel();
    StorageService.saveProgress(progress);
  }

  Companion get currentCompanion {
    return kCompanions.firstWhere(
      (c) => c.id == settings.companionId,
      orElse: () => kCompanions.first,
    );
  }

  void setCompanion(CompanionId id) {
    settings.companionId = id;
    StorageService.saveSettings(settings);
    final comp = currentCompanion;
    SoundService.playCorrect();
    companionSpeech = "Hi! I'm ${comp.name}! ${comp.tagline}";
    TtsService.speak("Hi! I am ${comp.name}! Let's type together!");
    notifyListeners();
  }

  void cycleCompanion() {
    final list = CompanionId.values;
    final nextIdx = (list.indexOf(settings.companionId) + 1) % list.length;
    setCompanion(list[nextIdx]);
  }

  String get targetText {
    if (activeAiExercise != null) {
      return activeAiExercise!.text;
    }
    switch (currentStage) {
      case StageId.alphabet:
        return kAlphabetList[alphabetIndex].uppercase;
      case StageId.words:
        return kWordList[wordIndex].word;
      case StageId.sentences:
        return kSentenceList[sentenceIndex].sentence;
      case StageId.paragraphs:
        return kParagraphList[paragraphIndex].sentences[paragraphSentenceStep];
    }
  }

  String get targetKey {
    if (userInput.length < targetText.length) {
      return targetText[userInput.length];
    }
    return '';
  }

  void pronounceCurrent() {
    if (activeAiExercise != null) {
      TtsService.speak(activeAiExercise!.text);
      return;
    }
    switch (currentStage) {
      case StageId.alphabet:
        final item = kAlphabetList[alphabetIndex];
        TtsService.speak('${item.uppercase}. ${item.phonics}. ${item.wordSample}!');
        break;
      case StageId.words:
        final item = kWordList[wordIndex];
        TtsService.speak('${item.word}. ${item.hint}');
        break;
      case StageId.sentences:
        TtsService.speak(kSentenceList[sentenceIndex].sentence);
        break;
      case StageId.paragraphs:
        TtsService.speak(kParagraphList[paragraphIndex].sentences[paragraphSentenceStep]);
        break;
    }
  }

  void repeatCurrent() {
    userInput = '';
    companionSpeech = "Let's practice this once more! You can do it!";
    notifyListeners();
  }

  void selectStage(StageId stage) {
    currentStage = stage;
    activeAiExercise = null;
    userInput = '';
    progress.currentStage = stage;
    StorageService.saveProgress(progress);
    companionSpeech = 'Switched to ${stage.name} practice! Press the glowing key!';
    notifyListeners();
  }

  void selectWorld(WorldId worldId) {
    currentWorldId = worldId;
    progress.currentWorldId = worldId;
    final world = kWorlds.firstWhere((w) => w.id == worldId, orElse: () => kWorlds.first);
    currentStage = world.stageId;
    activeAiExercise = null;
    userInput = '';
    StorageService.saveProgress(progress);
    companionSpeech = world.companionQuote;
    notifyListeners();
  }

  void startAiExercise(AiExercise exercise) {
    activeAiExercise = exercise;
    currentWorldId = WorldId.values.firstWhere(
      (w) => w.name == exercise.worldId,
      orElse: () => WorldId.meadow_of_letters,
    );
    final world = kWorlds.firstWhere((w) => w.id == currentWorldId, orElse: () => kWorlds.first);
    currentStage = world.stageId;
    userInput = '';
    isGameStarted = true;
    _startTimer();
    SoundService.playCorrect();
    companionMood = CompanionMood.happy;
    companionSpeech = 'AI Exercise ready: "${exercise.title}"! Tap the glowing keys!';
    TtsService.speak(exercise.title);
    notifyListeners();
  }

  void exitAiExercise() {
    activeAiExercise = null;
    userInput = '';
    companionSpeech = 'Back to standard practice! Choose any stage to type!';
    notifyListeners();
  }

  Future<void> generateNewAiExercise([WorldId? targetWorld]) async {
    final world = targetWorld ?? currentWorldId;
    isGeneratingAi = true;
    companionMood = CompanionMood.thinking;
    companionSpeech = 'BISMA AI is crafting a personalized typing exercise for you... ✨';
    notifyListeners();

    try {
      final tricky = progress.letterStats.entries
          .where((e) => e.value.errors > 0)
          .toList()
        ..sort((a, b) => b.value.errors.compareTo(a.value.errors));

      final trickyLetters = tricky.map((e) => e.key).take(4).toList();

      final newEx = await AiTutorService.generateAiExercise(
        worldId: world,
        accuracy: progress.accuracy,
        trickyLetters: trickyLetters,
      );

      progress.aiExercises[newEx.id] = newEx;
      StorageService.saveProgress(progress);
      startAiExercise(newEx);
    } catch (_) {
      companionSpeech = "Let's keep typing! Your fingers are doing wonderful!";
    } finally {
      isGeneratingAi = false;
      companionMood = CompanionMood.idle;
      notifyListeners();
    }
  }

  void handleKeyPress(String key) {
    if (!isGameStarted) return;

    lastPressedKey = key;
    Timer(const Duration(milliseconds: 180), () {
      lastPressedKey = null;
      notifyListeners();
    });

    if (key == 'Backspace') {
      if (userInput.isNotEmpty) {
        SoundService.playBackspace();
        userInput = userInput.substring(0, userInput.length - 1);
        streakCount = 0;
        notifyListeners();
      }
      return;
    }

    if (key == ' ') {
      SoundService.playSpace();
    }

    if (userInput.length >= targetText.length) return;

    final expectedChar = targetText[userInput.length];
    final isCorrect = key.toLowerCase() == expectedChar.toLowerCase();

    // Stats tracking
    progress.totalKeystrokes++;
    final letterKey = expectedChar.toLowerCase();
    final currentLetterStat = progress.letterStats[letterKey] ?? LetterStat();
    currentLetterStat.attempts++;

    if (isCorrect) {
      progress.correctKeystrokes++;
      SoundService.playCorrect();
      companionMood = CompanionMood.happy;
      streakCount++;

      if (streakCount >= 15 && !progress.badges.contains('streak_king')) {
        progress.badges.add('streak_king');
      }

      userInput += expectedChar;

      _checkBadges();

      if (userInput.length == targetText.length) {
        _handleItemCompletion();
      }
    } else {
      SoundService.playWrong();
      currentLetterStat.errors++;
      companionMood = CompanionMood.thinking;
      streakCount = 0;
      companionSpeech = 'Oops! Gentle try! Look for the glowing key "${expectedChar.toUpperCase()}"!';
      Timer(const Duration(milliseconds: 600), () {
        companionMood = CompanionMood.idle;
        notifyListeners();
      });
    }

    progress.letterStats[letterKey] = currentLetterStat;
    StorageService.saveProgress(progress);
    notifyListeners();
  }

  void _handleItemCompletion() {
    companionMood = CompanionMood.celebrate;

    // 1. AI EXERCISE COMPLETION
    if (activeAiExercise != null) {
      final ex = activeAiExercise!;
      final isFirstTime = !ex.completed;
      SoundService.playSentenceComplete();

      ex.completed = true;
      ex.completedAt = DateTime.now().toIso8601String();
      progress.aiExercises[ex.id] = ex;

      if (isFirstTime) {
        progress.starsEarned += ex.starsReward;
        progress.totalWordsTyped += ex.text.split(' ').length;
        final list = progress.worldCompletedAiIds[ex.worldId] ?? [];
        if (!list.contains(ex.id)) {
          list.add(ex.id);
          progress.worldCompletedAiIds[ex.worldId] = list;
        }
      }

      _checkBadges();
      StorageService.saveProgress(progress);
      companionSpeech = '🎊 Woohoo! AI Exercise "${ex.title}" completed! You earned stars! ⭐';
      TtsService.speak('Hooray! Exercise completed! You earned stars!');

      Timer(const Duration(milliseconds: 1400), () {
        userInput = '';
        companionMood = CompanionMood.idle;
        activeAiExercise = null;
        notifyListeners();
      });
      return;
    }

    // 2. STANDARD STAGES
    if (currentStage == StageId.alphabet) {
      SoundService.playWordComplete();
      progress.starsEarned += 1;
      progress.stageProgress['alphabet'] = (progress.stageProgress['alphabet'] ?? 0) + 1;
      companionSpeech = 'Woohoo! High five! You typed ${kAlphabetList[alphabetIndex].uppercase}! ⭐';

      Timer(const Duration(milliseconds: 700), () {
        userInput = '';
        companionMood = CompanionMood.idle;
        alphabetIndex = (alphabetIndex + 1) % kAlphabetList.length;

        // Auto progression
        if ((progress.stageProgress['alphabet'] ?? 0) >= 10 && progress.accuracy >= 80) {
          currentStage = StageId.words;
          currentWorldId = WorldId.forest_of_words;
          progress.currentStage = StageId.words;
          progress.currentWorldId = WorldId.forest_of_words;
          companionSpeech = '🎉 AMAZING! You graduated to Stage B: Word Practice!';
        }
        _checkBadges();
        StorageService.saveProgress(progress);
        notifyListeners();
      });
    } else if (currentStage == StageId.words) {
      SoundService.playWordComplete();
      progress.starsEarned += 2;
      progress.totalWordsTyped += 1;
      progress.stageProgress['words'] = (progress.stageProgress['words'] ?? 0) + 1;
      companionSpeech = 'Brilliant! You typed ${kWordList[wordIndex].word}! ⭐⭐';

      Timer(const Duration(milliseconds: 800), () {
        userInput = '';
        companionMood = CompanionMood.idle;
        wordIndex = (wordIndex + 1) % kWordList.length;

        // Auto progression
        if ((progress.stageProgress['words'] ?? 0) >= 5 && progress.accuracy >= 80) {
          currentStage = StageId.sentences;
          currentWorldId = WorldId.sentence_safari;
          progress.currentStage = StageId.sentences;
          progress.currentWorldId = WorldId.sentence_safari;
          companionSpeech = '🚀 Super Typist! Moving forward to Stage C: Sentences!';
        }
        _checkBadges();
        StorageService.saveProgress(progress);
        notifyListeners();
      });
    } else if (currentStage == StageId.sentences) {
      SoundService.playSentenceComplete();
      progress.starsEarned += 3;
      progress.totalWordsTyped += kSentenceList[sentenceIndex].wordCount;
      progress.stageProgress['sentences'] = (progress.stageProgress['sentences'] ?? 0) + 1;
      companionSpeech = 'Wonderful sentence typing! You used spaces and capitals perfectly! ⭐⭐⭐';

      Timer(const Duration(milliseconds: 900), () {
        userInput = '';
        companionMood = CompanionMood.idle;
        sentenceIndex = (sentenceIndex + 1) % kSentenceList.length;

        // Auto progression
        if ((progress.stageProgress['sentences'] ?? 0) >= 4) {
          currentStage = StageId.paragraphs;
          currentWorldId = WorldId.castle_of_stories;
          progress.currentStage = StageId.paragraphs;
          progress.currentWorldId = WorldId.castle_of_stories;
          companionSpeech = '🏰 You are a Story Hero! Welcome to Stage D: Storybooks!';
        }
        _checkBadges();
        StorageService.saveProgress(progress);
        notifyListeners();
      });
    } else {
      // Paragraphs
      final story = kParagraphList[paragraphIndex];
      final isLastSentence = paragraphSentenceStep >= story.sentences.length - 1;

      if (!isLastSentence) {
        SoundService.playSentenceComplete();
        progress.starsEarned += 2;
        progress.totalWordsTyped += 5;
        companionSpeech = 'Sentence complete! Onto the next line of ${story.title}!';

        Timer(const Duration(milliseconds: 800), () {
          userInput = '';
          companionMood = CompanionMood.idle;
          paragraphSentenceStep++;
          _checkBadges();
          StorageService.saveProgress(progress);
          notifyListeners();
        });
      } else {
        SoundService.playVictory();
        progress.starsEarned += 5;
        progress.totalWordsTyped += 15;
        progress.stageProgress['paragraphs'] = (progress.stageProgress['paragraphs'] ?? 0) + 1;
        companionSpeech = '🎊 VICTORY! You typed the entire story "${story.title}"!';

        Timer(const Duration(milliseconds: 1400), () {
          userInput = '';
          companionMood = CompanionMood.idle;
          paragraphSentenceStep = 0;
          paragraphIndex = (paragraphIndex + 1) % kParagraphList.length;
          _checkBadges();
          StorageService.saveProgress(progress);
          notifyListeners();
        });
      }
    }
  }

  void _checkBadges() {
    final set = Set<String>.from(progress.badges);
    if (progress.totalKeystrokes >= 1) set.add('first_key');
    if ((progress.stageProgress['alphabet'] ?? 0) >= 26) set.add('alphabet_champ');
    if (progress.totalWordsTyped >= 10) set.add('word_wizard');
    if ((progress.stageProgress['sentences'] ?? 0) >= 5) set.add('sentence_scout');
    if ((progress.stageProgress['paragraphs'] ?? 0) >= 2) set.add('story_master');
    if (progress.accuracy >= 85 && progress.totalKeystrokes >= 30) set.add('speedy_bunny');
    if (progress.totalPracticeSeconds >= 300) set.add('practice_champ');
    progress.badges = set.toList();
  }

  void resetProgress() {
    progress = UserProgress();
    progress.aiExercises = Map<String, AiExercise>.from(kInitialAiExercises);
    alphabetIndex = 0;
    wordIndex = 0;
    sentenceIndex = 0;
    paragraphIndex = 0;
    paragraphSentenceStep = 0;
    userInput = '';
    currentStage = StageId.alphabet;
    currentWorldId = WorldId.meadow_of_letters;
    activeAiExercise = null;
    isGameStarted = false;
    _stopTimer();
    StorageService.saveProgress(progress);
    companionSpeech = 'Fresh adventure started! Tap Start Typing Adventure to begin!';
    notifyListeners();
  }

  void updateSettings(AppSettings newSettings) {
    settings = newSettings;
    _applySettings();
    StorageService.saveSettings(settings);
    notifyListeners();
  }

  @override
  void dispose() {
    _practiceTimer?.cancel();
    super.dispose();
  }
}
