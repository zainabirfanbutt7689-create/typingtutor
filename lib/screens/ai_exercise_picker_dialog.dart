import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/typing_models.dart';
import '../controllers/typing_controller.dart';

class AiExercisePickerDialog extends StatelessWidget {
  const AiExercisePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TypingController>();
    final exercises = controller.progress.aiExercises.values.toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFFD97706)),
                    SizedBox(width: 8),
                    Text(
                      'AI Typing Exercises',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.lavenderDark),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Text(
              'Personalized typing exercises crafted by Gemini AI to match your skill',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),

            // Generate Action Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEF3C7), Color(0xFFFCE7F3)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.butterYellowBorder),
              ),
              child: Row(
                children: [
                  const Text('🪄', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate a New Exercise',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF78350F)),
                        ),
                        Text(
                          'Adaptive practice targeting your tricky keys!',
                          style: TextStyle(fontSize: 10, color: Color(0xFF92400E)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: const Color(0xFF78350F),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: controller.isGeneratingAi
                        ? null
                        : () async {
                            await controller.generateNewAiExercise();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    child: controller.isGeneratingAi
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('+ Create AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // List of exercises
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: ex.completed ? const Color(0xFF34D399) : AppColors.lavenderBorder,
                      ),
                    ),
                    color: ex.completed ? const Color(0xFFECFDF5) : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ex.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.butterYellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('⭐ +${ex.starsReward}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.butterYellowDark)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"${ex.text}"',
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
                          ),
                          if (ex.hint != null) ...[
                            const SizedBox(height: 2),
                            Text('💡 ${ex.hint!}', style: const TextStyle(fontSize: 10, color: Colors.black54)),
                          ],
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              icon: Icon(ex.completed ? Icons.refresh_rounded : Icons.play_arrow_rounded, size: 16),
                              label: Text(ex.completed ? 'Practice Again' : 'Start Typing', style: const TextStyle(fontSize: 11)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ex.completed ? const Color(0xFF059669) : AppColors.lavenderDark,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                controller.startAiExercise(ex);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
