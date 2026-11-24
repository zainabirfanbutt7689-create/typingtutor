
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../constants/app_colors.dart';
import '../models/typing_models.dart';
import '../controllers/typing_controller.dart';
import '../data/alphabet_data.dart';
import '../data/word_data.dart';
import '../data/sentence_data.dart';
import '../data/paragraph_data.dart';
import '../widgets/companion_avatar_widget.dart';
import '../widgets/speech_bubble_widget.dart';
import '../widgets/cartoon_keyboard_widget.dart';
import '../widgets/word_tiles_widget.dart';
import '../widgets/sentence_display_widget.dart';
import 'welcome_screen.dart';
import 'progress_dashboard_screen.dart';
import 'ai_exercise_picker_dialog.dart';
import 'settings_modal.dart';

class TypingAdventureScreen extends StatefulWidget {
  const TypingAdventureScreen({super.key});

  @override
  State<TypingAdventureScreen> createState() =>
      _TypingAdventureScreenState();
}

class _TypingAdventureScreenState extends State<TypingAdventureScreen> {
  late ConfettiController _confettiController;
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Widget _buildWordEmoji(String iconName) {
    switch (iconName) {
      case 'cat':
        return const Text('🐱', style: TextStyle(fontSize: 48));
      case 'dog':
        return const Text('🐶', style: TextStyle(fontSize: 48));
      case 'sun':
        return const Text('☀️', style: TextStyle(fontSize: 48));
      case 'ball':
        return const Text('⚽', style: TextStyle(fontSize: 48));
      case 'apple':
        return const Text('🍎', style: TextStyle(fontSize: 48));
      case 'book':
        return const Text('📚', style: TextStyle(fontSize: 48));
      case 'star':
        return const Text('⭐', style: TextStyle(fontSize: 48));
      case 'fish':
        return const Text('🐠', style: TextStyle(fontSize: 48));
      case 'moon':
        return const Text('🌙', style: TextStyle(fontSize: 48));
      case 'frog':
        return const Text('🐸', style: TextStyle(fontSize: 48));
      case 'tree':
        return const Text('🌳', style: TextStyle(fontSize: 48));
      case 'bird':
        return const Text('🐦', style: TextStyle(fontSize: 48));
      case 'cake':
        return const Text('🎂', style: TextStyle(fontSize: 48));
      case 'duck':
        return const Text('🦆', style: TextStyle(fontSize: 48));
      case 'boat':
        return const Text('⛵', style: TextStyle(fontSize: 48));
      case 'milk':
        return const Text('🥛', style: TextStyle(fontSize: 48));
      default:
        return const Text('✨', style: TextStyle(fontSize: 48));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TypingController>();
    final settings = controller.settings;

    if (controller.companionMood == CompanionMood.celebrate &&
        !settings.reducedMotion) {
      _confettiController.play();
    }

    return RawKeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final keyLabel = event.logicalKey.keyLabel;

          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            controller.handleKeyPress('Backspace');
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            controller.handleKeyPress(' ');
          } else if (keyLabel.length == 1) {
            controller.handleKeyPress(keyLabel);
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.bgStart,
                    AppColors.bgMiddle,
                    AppColors.bgEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Responsive Top App Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.home_rounded,
                                      color: AppColors.lavenderDark,
                                    ),
                                    tooltip: 'Back to Home',
                                    onPressed: () {
                                      controller.backToWelcome();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const WelcomeScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const Text(
                                    '🐻',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'BISMA',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.lavenderDark,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      settings.soundEnabled
                                          ? Icons.volume_up_rounded
                                          : Icons.volume_off_rounded,
                                      color: settings.soundEnabled
                                          ? AppColors.lavenderDark
                                          : const Color(0xFFFF69B4),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      settings.soundEnabled =
                                      !settings.soundEnabled;
                                      controller.updateSettings(settings);
                                    },
                                  ),

                                  TextButton.icon(
                                    icon: const Icon(
                                      Icons.auto_awesome,
                                      size: 16,
                                      color: Color(0xFF78350F),
                                    ),
                                    label: const Text(
                                      'AI',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF78350F),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                      AppColors.activeKeyGlow,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(14),
                                        side: const BorderSide(
                                          color: AppColors.activeKeyBorder,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                        const AiExercisePickerDialog(),
                                      );
                                    },
                                  ),

                                  const SizedBox(width: 4),

                                  ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.bar_chart_rounded,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'Dashboard',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      AppColors.lavenderDark,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      minimumSize: const Size(0, 36),
                                      tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const ProgressDashboardScreen(),
                                        ),
                                      );
                                    },
                                  ),

                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.settings_rounded,
                                      color: AppColors.lavenderDark,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                        const SettingsModal(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Stage Selector Strip
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: Colors.white.withOpacity(0.5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildStageChip(
                              label: 'Letters',
                              emoji: '🔤',
                              isSelected:
                              controller.activeAiExercise == null &&
                                  controller.currentStage ==
                                      StageId.alphabet,
                              onTap: () =>
                                  controller.selectStage(StageId.alphabet),
                            ),
                            const SizedBox(width: 6),
                            _buildStageChip(
                              label: 'Words',
                              emoji: '🌳',
                              isSelected:
                              controller.activeAiExercise == null &&
                                  controller.currentStage ==
                                      StageId.words,
                              onTap: () =>
                                  controller.selectStage(StageId.words),
                            ),
                            const SizedBox(width: 6),
                            _buildStageChip(
                              label: 'Sentences',
                              emoji: '🌈',
                              isSelected:
                              controller.activeAiExercise == null &&
                                  controller.currentStage ==
                                      StageId.sentences,
                              onTap: () =>
                                  controller.selectStage(StageId.sentences),
                            ),
                            const SizedBox(width: 6),
                            _buildStageChip(
                              label: 'Stories',
                              emoji: '🏰',
                              isSelected:
                              controller.activeAiExercise == null &&
                                  controller.currentStage ==
                                      StageId.paragraphs,
                              onTap: () =>
                                  controller.selectStage(StageId.paragraphs),
                            ),
                            const SizedBox(width: 6),
                            _buildStageChip(
                              label: 'AI Exercise',
                              emoji: '✨',
                              isSelected:
                              controller.activeAiExercise != null,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                  const AiExercisePickerDialog(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Middle Arena Area
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, arenaConstraints) {
                          final compactHeight =
                              arenaConstraints.maxHeight < 520;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: compactHeight ? 4 : 8,
                            ),
                            child: Column(
                              children: [
                                // Companion Cheer Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CompanionAvatarWidget(
                                      companion: controller.currentCompanion,
                                      mood: controller.companionMood,
                                      size: compactHeight ? 58 : 80,
                                      onTap: () =>
                                          controller.cycleCompanion(),
                                    ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: SpeechBubbleWidget(
                                        text: controller.companionSpeech,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: compactHeight ? 4 : 10),

                                // Main Practice Card
                                Expanded(
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(
                                          compactHeight ? 10 : 18,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.92),
                                          borderRadius:
                                          BorderRadius.circular(28),
                                          border: Border.all(
                                            color: AppColors.lavenderBorder,
                                            width: 2,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: _buildStageContent(controller),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: compactHeight ? 4 : 10),

                                // Keyboard
                                CartoonKeyboardWidget(
                                  targetKey: controller.targetKey,
                                  lastPressedKey: controller.lastPressedKey,
                                  onKeyPress: controller.handleKeyPress,
                                  showFingerGuides:
                                  settings.showFingerGuides,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 35,
                colors: const [
                  Color(0xFFF472B6),
                  Color(0xFF38BDF8),
                  Color(0xFF34D399),
                  Color(0xFFFBBF24),
                  Color(0xFFA78BFA),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageChip({
    required String label,
    required String emoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavenderDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.lavenderDark
                : AppColors.lavenderBorder,
          ),
          boxShadow: isSelected
              ? [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                isSelected ? Colors.white : AppColors.lavenderDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageContent(TypingController controller) {
    // 1. ACTIVE AI EXERCISE
    if (controller.activeAiExercise != null) {
      final ex = controller.activeAiExercise!;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '✨ ${ex.worldName}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lavenderDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.butterYellow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.butterYellowBorder,
                  ),
                ),
                child: Text(
                  '⭐ +${ex.starsReward} Stars',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.butterYellowDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ex.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          if (ex.hint != null) ...[
            const SizedBox(height: 4),
            Text(
              '💡 ${ex.hint!}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (ex.text.length <= 8 && !ex.text.contains(' '))
            WordTilesWidget(
              targetWord: ex.text,
              userInput: controller.userInput,
              largeText: controller.settings.largeText,
            )
          else
            SentenceDisplayWidget(
              targetText: ex.text,
              userInput: controller.userInput,
              largeText: controller.settings.largeText,
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Restart'),
                onPressed: () => controller.repeatCurrent(),
              ),
              TextButton(
                onPressed: () => controller.exitAiExercise(),
                child: const Text('Back to Stages'),
              ),
            ],
          ),
        ],
      );
    }

    // 2. STAGE A: ALPHABET
    if (controller.currentStage == StageId.alphabet) {
      final item = kAlphabetList[controller.alphabetIndex];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  item.wordSample,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lavenderDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.lavenderDark,
                ),
                onPressed: () => controller.pronounceCurrent(),
              ),
            ],
          ),
          Text(
            'Phonics: "${item.phonics}"',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (controller.settings.showUrduHints &&
              item.urduPhonics != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.urduPhonics!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mintDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF3E8FF),
                  Color(0xFFFCE7F3),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.lavenderBorder,
                width: 3,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    item.uppercase,
                    style: TextStyle(
                      fontSize:
                      controller.settings.largeText ? 76 : 64,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lavenderDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item.lowercase,
                    style: TextStyle(
                      fontSize:
                      controller.settings.largeText ? 52 : 44,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Find and tap the target letter on the keyboard below!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 14),
            label: const Text(
              'Practice letter again',
              style: TextStyle(fontSize: 11),
            ),
            onPressed: () => controller.repeatCurrent(),
          ),
        ],
      );
    }

    // 3. STAGE B: WORDS
    if (controller.currentStage == StageId.words) {
      final item = kWordList[controller.wordIndex];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.skyBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: _buildWordEmoji(item.svgIcon),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  item.hint,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.lavenderDark,
                  size: 20,
                ),
                onPressed: () => controller.pronounceCurrent(),
              ),
            ],
          ),
          if (controller.settings.showUrduHints &&
              item.urduMeaning != null)
            Text(
              'اردو: ${item.urduMeaning!}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mintDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 8),
          WordTilesWidget(
            targetWord: item.word,
            userInput: controller.userInput,
            largeText: controller.settings.largeText,
          ),
        ],
      );
    }

    // 4. STAGE C: SENTENCES
    if (controller.currentStage == StageId.sentences) {
      final item = kSentenceList[controller.sentenceIndex];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  '🌈 Sentence Adventure',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lavenderDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.lavenderDark,
                  size: 20,
                ),
                onPressed: () => controller.pronounceCurrent(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SentenceDisplayWidget(
            targetText: item.sentence,
            userInput: controller.userInput,
            largeText: controller.settings.largeText,
          ),
          const SizedBox(height: 10),
          Text(
            controller.targetKey == ' '
                ? '👉 Tap the big SPACEBAR!'
                : controller.targetKey == '.'
                ? '👉 Tap the dot . to finish!'
                : 'Target key: ${controller.targetKey}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.lavenderDark,
            ),
          ),
        ],
      );
    }

    // 5. STAGE D: PARAGRAPHS
    final story = kParagraphList[controller.paragraphIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '🏰 ${story.title}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lavenderDark,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Step ${controller.paragraphSentenceStep + 1}/${story.sentences.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.lavenderDark,
                    size: 18,
                  ),
                  onPressed: () => controller.pronounceCurrent(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SentenceDisplayWidget(
          targetText: story.sentences[controller.paragraphSentenceStep],
          userInput: controller.userInput,
          largeText: controller.settings.largeText,
        ),
      ],
    );
  }
}
