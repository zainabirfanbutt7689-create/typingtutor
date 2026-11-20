import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/companion_model.dart';
import '../controllers/typing_controller.dart';
import '../data/companion_data.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TypingController>();
    final settings = controller.settings;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings_rounded, color: AppColors.lavenderDark),
                    SizedBox(width: 8),
                    Text(
                      'Settings & Accessibility',
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
              'Customize sounds, visual comfort, and typing companions',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Companion Picker
                    const Text(
                      'CHOOSE YOUR COMPANION',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.lavenderDark),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: kCompanions.map((comp) {
                        final isSelected = settings.companionId == comp.id;
                        return GestureDetector(
                          onTap: () => controller.setCompanion(comp.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? comp.avatarBgColor : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? comp.accentColor : Colors.black12,
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(comp.emoji, style: const TextStyle(fontSize: 26)),
                                const SizedBox(height: 2),
                                Text(
                                  comp.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? comp.accentColor : AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Section 2: Audio & Spoken
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.lavenderBorder),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Keyboard & Game Sounds', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Playful pop, boing, and success jingles', style: TextStyle(fontSize: 10)),
                            value: settings.soundEnabled,
                            onChanged: (val) {
                              settings.soundEnabled = val;
                              controller.updateSettings(settings);
                            },
                          ),
                          if (settings.soundEnabled) ...[
                            Row(
                              children: [
                                const Text('FX Volume:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                Expanded(
                                  child: Slider(
                                    value: settings.soundVolume,
                                    min: 0.1,
                                    max: 1.0,
                                    activeColor: AppColors.lavenderDark,
                                    onChanged: (val) {
                                      settings.soundVolume = val;
                                      controller.updateSettings(settings);
                                    },
                                  ),
                                ),
                                Text('${(settings.soundVolume * 100).round()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                          const Divider(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Spoken Pronunciation & Hints', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Read words, phonics, and letters aloud', style: TextStyle(fontSize: 10)),
                            value: settings.ttsEnabled,
                            onChanged: (val) {
                              settings.ttsEnabled = val;
                              controller.updateSettings(settings);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Section 3: Visual & Sensory Comfort
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Calm Mode (Reduced Motion)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Turns off bouncy animations for sensitive learners', style: TextStyle(fontSize: 10)),
                            value: settings.reducedMotion,
                            onChanged: (val) {
                              settings.reducedMotion = val;
                              controller.updateSettings(settings);
                            },
                          ),
                          const Divider(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Extra Large Letters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Enlarges typing tiles and prompt characters', style: TextStyle(fontSize: 10)),
                            value: settings.largeText,
                            onChanged: (val) {
                              settings.largeText = val;
                              controller.updateSettings(settings);
                            },
                          ),
                          const Divider(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Pastel Finger Guides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Color-codes keyboard columns for finger positioning', style: TextStyle(fontSize: 10)),
                            value: settings.showFingerGuides,
                            onChanged: (val) {
                              settings.showFingerGuides = val;
                              controller.updateSettings(settings);
                            },
                          ),
                          const Divider(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Bilingual Urdu Hints (BISMA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Show Urdu phonetic hints alongside English letters', style: TextStyle(fontSize: 10)),
                            value: settings.showUrduHints,
                            onChanged: (val) {
                              settings.showUrduHints = val;
                              controller.updateSettings(settings);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lavenderDark,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
