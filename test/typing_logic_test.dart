import 'package:flutter_test/flutter_test.dart';
import 'package:bisma_typing_tutor/models/user_progress_model.dart';
import 'package:bisma_typing_tutor/models/typing_models.dart';
import 'package:bisma_typing_tutor/data/alphabet_data.dart';
import 'package:bisma_typing_tutor/data/word_data.dart';
import 'package:bisma_typing_tutor/data/sentence_data.dart';
import 'package:bisma_typing_tutor/data/paragraph_data.dart';
import 'package:bisma_typing_tutor/data/companion_data.dart';

void main() {
  group('Typing Logic & Progress Unit Tests', () {
    test('Default accuracy starts at 100%', () {
      final progress = UserProgress();
      expect(progress.accuracy, 100.0);
      expect(progress.wpm, isNull);
    });

    test('Accuracy calculates properly on keystrokes', () {
      final progress = UserProgress(
        totalKeystrokes: 20,
        correctKeystrokes: 18,
      );
      expect(progress.accuracy, 90.0);
    });

    test('WPM calculates when keystrokes >= 25', () {
      final progress = UserProgress(
        totalKeystrokes: 50,
        correctKeystrokes: 50,
        totalPracticeSeconds: 60, // 1 minute
      );
      // 50 chars / 5 = 10 words in 1 minute = 10 WPM
      expect(progress.wpm, 10);
    });

    test('All 26 alphabet items exist with uppercase and lowercase', () {
      expect(kAlphabetList.length, 26);
      for (final item in kAlphabetList) {
        expect(item.uppercase.length, 1);
        expect(item.lowercase.length, 1);
        expect(item.phonics.isNotEmpty, isTrue);
      }
    });

    test('All 16 vocabulary words exist and are uppercase', () {
      expect(kWordList.length, 16);
      for (final item in kWordList) {
        expect(item.word, item.word.toUpperCase());
        expect(item.hint.isNotEmpty, isTrue);
      }
    });

    test('Sentences and paragraphs data integrity', () {
      expect(kSentenceList.length, 10);
      expect(kParagraphList.length, 4);
      for (final s in kSentenceList) {
        expect(s.sentence.isNotEmpty, isTrue);
      }
      for (final p in kParagraphList) {
        expect(p.sentences.length, greaterThanOrEqualTo(3));
      }
    });

    test('All 5 cartoon companions are configured', () {
      expect(kCompanions.length, 5);
      final names = kCompanions.map((c) => c.name).toList();
      expect(names, containsAll(['Bisma', 'Pip', 'Sparky', 'Buzzy', 'Ollie']));
    });

    test('AI Exercise JSON serialization works properly', () {
      final ex = AiExercise(
        id: 'ai-test-1',
        worldId: 'forest_of_words',
        worldName: 'Forest of Words',
        activityType: 'words',
        title: 'Test Exercise',
        text: 'BEAR',
        hint: 'Friendly furry forest friend',
        completed: false,
        starsReward: 3,
      );

      final jsonMap = ex.toJson();
      final restored = AiExercise.fromJson(jsonMap);

      expect(restored.id, 'ai-test-1');
      expect(restored.text, 'BEAR');
      expect(restored.starsReward, 3);
      expect(restored.completed, isFalse);
    });
  });
}
