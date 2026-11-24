
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../controllers/typing_controller.dart';
import '../data/companion_data.dart';
import '../widgets/companion_avatar_widget.dart';
import 'progress_dashboard_screen.dart';
import 'settings_modal.dart';
import 'typing_adventure_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TypingController>();
    final settings = controller.settings;

    return Scaffold(
      body: Container(
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Responsive Top Header
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 10,
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.lavenderBorder,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '🐻',
                                  style: TextStyle(fontSize: 26),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BISMA',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.lavenderDark,
                                        height: 1.1,
                                      ),
                                    ),
                                    Text(
                                      'AI Cartoon Typing Tutor',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Quick Actions
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
                                ),
                                onPressed: () {
                                  settings.soundEnabled =
                                  !settings.soundEnabled;
                                  controller.updateSettings(settings);
                                },
                              ),

                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.bar_chart_rounded,
                                  size: 18,
                                ),
                                label: const Text('Progress'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.lavenderDark,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(0, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
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
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const SettingsModal(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Central Hero
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.blushPinkBorder,
                          ),
                        ),
                        child: const Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('✨ ', style: TextStyle(fontSize: 14)),
                            Text(
                              "Let's learn typing together!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blushPinkDark,
                              ),
                            ),
                            Text(' ✨', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Typing Adventure!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lavenderDark,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Tap friendly keys, hear cheerful pops, collect shiny stars, and journey through magical animal stories!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Companion Selection
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.lavenderBorder,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: 4,
                              children: [
                                Text(
                                  'CHOOSE YOUR COMPANION:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.lavenderDark,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  'Tap any friend!',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Responsive Companion Lineup
                            Wrap(
                              alignment: WrapAlignment.spaceAround,
                              runAlignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 10,
                              children: kCompanions.map((comp) {
                                final isSelected =
                                    controller.settings.companionId ==
                                        comp.id;

                                return GestureDetector(
                                  onTap: () =>
                                      controller.setCompanion(comp.id),
                                  child: AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : comp.avatarBgColor
                                          .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? comp.accentColor
                                            : Colors.transparent,
                                        width: isSelected ? 3 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                        BoxShadow(
                                          color: comp.accentColor
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                          : null,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          comp.emoji,
                                          style: const TextStyle(
                                            fontSize: 32,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comp.name,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? comp.accentColor
                                                : AppColors.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 10),

                            // Speech Bubble
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lavender.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '💬 "${controller.companionSpeech}"',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lavenderDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Start Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: const BorderSide(
                                color: Color(0xFF047857),
                                width: 2,
                              ),
                            ),
                          ),
                          onPressed: () {
                            controller.startGame();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) =>
                                const TypingAdventureScreen(),
                              ),
                            );
                          },
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Start Typing Adventure!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Resume Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.lavenderBorder,
                          ),
                        ),
                        child: Text(
                          controller.progress.totalKeystrokes == 0
                              ? '🔤 Starting from Alphabet Letters (Stage A)'
                              : 'Ready to resume: ${controller.currentStage.name.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lavenderDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
