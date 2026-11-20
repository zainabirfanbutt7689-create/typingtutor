import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/user_progress_model.dart';
import '../models/world_model.dart';
import '../controllers/typing_controller.dart';
import '../data/worlds_data.dart';
import '../data/badges_data.dart';
import '../utils/formatters.dart';

class ProgressDashboardScreen extends StatelessWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TypingController>();
    final progress = controller.progress;
    final wpm = progress.wpm;

    final trickyLetters = progress.letterStats.entries
        .where((e) => e.value.errors > 0)
        .toList()
      ..sort((a, b) => b.value.errors.compareTo(a.value.errors));

    final completedAiList = progress.aiExercises.values.where((e) => e.completed).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.workspace_premium_rounded, color: AppColors.butterYellowDark),
            SizedBox(width: 8),
            Text(
              'My Progress Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lavenderDark),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized AI Recommendation Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEDE9FE), Color(0xFFFCE7F3), Color(0xFFFEF3C7)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lavenderBorder, width: 2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.psychology_rounded, color: AppColors.lavenderDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PERSONALIZED AI RECOMMENDATION ✨',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lavenderDark,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trickyLetters.isNotEmpty
                              ? "You are making wonderful progress! Let's practice key \"${trickyLetters.first.key.toUpperCase()}\" with gentle high-fives!"
                              : "Superstar typist! Your fingers are moving with great confidence across all keys!",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5 Core Metrics Cards
            Row(
              children: [
                _buildMetricCard(
                  title: 'Practice Time',
                  value: Formatters.formatPracticeTime(progress.totalPracticeSeconds),
                  icon: Icons.timer_rounded,
                  color: const Color(0xFF9333EA),
                  bg: const Color(0xFFFAF5FF),
                ),
                const SizedBox(width: 8),
                _buildMetricCard(
                  title: 'Accuracy',
                  value: '${progress.accuracy.toStringAsFixed(0)}%',
                  icon: Icons.track_changes_rounded,
                  color: const Color(0xFF059669),
                  bg: const Color(0xFFECFDF5),
                ),
                const SizedBox(width: 8),
                _buildMetricCard(
                  title: 'Correct Taps',
                  value: '${progress.correctKeystrokes}',
                  icon: Icons.keyboard_rounded,
                  color: const Color(0xFF4F46E5),
                  bg: const Color(0xFFEEF2FF),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMetricCard(
                  title: 'Words Typed',
                  value: '${progress.totalWordsTyped}',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF0284C7),
                  bg: const Color(0xFFF0F9FF),
                ),
                const SizedBox(width: 8),
                _buildMetricCard(
                  title: 'Gentle Speed',
                  value: wpm != null ? '$wpm WPM' : 'Warmup',
                  icon: Icons.speed_rounded,
                  color: const Color(0xFFD97706),
                  bg: const Color(0xFFFFFBEB),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Learning Categories & Practice Progress
            const Text(
              'Learning Categories & Practice Progress',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: kWorlds.length,
              itemBuilder: (context, index) {
                final world = kWorlds[index];
                int baseCount = 0;
                switch (world.id) {
                  case WorldId.meadow_of_letters:
                    baseCount = progress.stageProgress['alphabet'] ?? 0;
                    break;
                  case WorldId.forest_of_words:
                    baseCount = progress.stageProgress['words'] ?? 0;
                    break;
                  case WorldId.rainbow_bridge:
                    baseCount = progress.worldBaseCompleted['rainbow_bridge'] ?? 0;
                    break;
                  case WorldId.castle_of_stories:
                    baseCount = progress.stageProgress['paragraphs'] ?? 0;
                    break;
                  case WorldId.sentence_safari:
                    baseCount = progress.stageProgress['sentences'] ?? 0;
                    break;
                  case WorldId.paragraph_paradise:
                    baseCount = progress.worldBaseCompleted['paragraph_paradise'] ?? 0;
                    break;
                  case WorldId.creative_writing:
                    baseCount = progress.worldBaseCompleted['creative_writing'] ?? 0;
                    break;
                  case WorldId.champion_world:
                    baseCount = progress.worldBaseCompleted['champion_world'] ?? 0;
                    break;
                }

                final completedAiCount = progress.worldCompletedAiIds[world.id.name]?.length ?? 0;
                final total = baseCount + completedAiCount;

                return InkWell(
                  onTap: () {
                    controller.selectWorld(world.id);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: world.bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: world.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(world.icon, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                world.title,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: world.textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$total completed ${completedAiCount > 0 ? '(+$completedAiCount AI)' : ''}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: world.textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // Completed AI Exercises
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed AI Exercises (${completedAiList.length})',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text(
                  'Personalized',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (completedAiList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Text(
                  'No AI exercises completed yet. Tap "AI" during practice to create and type personalized exercises!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.black45),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: completedAiList.length,
                itemBuilder: (context, index) {
                  final ex = completedAiList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                      title: Text(ex.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${ex.worldName} · ${Formatters.formatDate(ex.completedAt)}', style: const TextStyle(fontSize: 11)),
                      trailing: Text('⭐ +${ex.starsReward}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.butterYellowDark)),
                    ),
                  );
                },
              ),

            const SizedBox(height: 18),

            // Keys to practice more
            const Text(
              'Keys to Practice More (Gentle Feedback)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            if (trickyLetters.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    '🎉 Super typing! All keys typed smoothly without tricky wobbles!',
                    style: TextStyle(color: AppColors.mintDark, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: trickyLetters.take(6).map((e) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.butterYellowBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.butterYellow,
                          child: Text(
                            e.key.toUpperCase(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.butterYellowDark),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${e.value.errors} gentle wobble${e.value.errors > 1 ? 's' : ''}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 18),

            // Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievement Badges (${progress.badges.length}/${kBadges.length})',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text(
                  '⭐ ${progress.starsEarned} Stars Earned',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.butterYellowDark),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.85,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: kBadges.length,
              itemBuilder: (context, index) {
                final badge = kBadges[index];
                final isUnlocked = progress.badges.contains(badge.id);

                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.butterYellow : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isUnlocked ? AppColors.butterYellowBorder : Colors.black12,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(badge.icon, style: TextStyle(fontSize: isUnlocked ? 26 : 22)),
                      const SizedBox(height: 4),
                      Text(
                        badge.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? AppColors.textDark : Colors.black26,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Reset Button
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.refresh_rounded, color: const Color(0xFFFF69B4), size: 16),
                label: const Text('Reset Progress', style: TextStyle(color: const Color(0xFFFF69B4))),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reset Progress?'),
                      content: const Text('Are you sure you want to reset all typed stats and stars to start a fresh adventure?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF69B4)),
                          onPressed: () {
                            controller.resetProgress();
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          child: const Text('Reset All', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
