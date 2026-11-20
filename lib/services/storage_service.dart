import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress_model.dart';
import '../models/app_settings_model.dart';
import '../data/worlds_data.dart';
import '../models/typing_models.dart';

class StorageService {
  static const String _progressKey = 'bisma_typing_progress_v1';
  static const String _settingsKey = 'bisma_typing_settings_v1';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveProgress(UserProgress progress) async {
    try {
      final jsonStr = jsonEncode(progress.toJson());
      await _prefs.setString(_progressKey, jsonStr);
    } catch (_) {}
  }

  static UserProgress loadProgress() {
    try {
      final jsonStr = _prefs.getString(_progressKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        final loaded = UserProgress.fromJson(decoded);
        // Merge initial AI exercises if missing
        for (final entry in kInitialAiExercises.entries) {
          if (!loaded.aiExercises.containsKey(entry.key)) {
            loaded.aiExercises[entry.key] = entry.value;
          }
        }
        return loaded;
      }
    } catch (_) {}

    final defaultProg = UserProgress();
    defaultProg.aiExercises = Map<String, AiExercise>.from(kInitialAiExercises);
    return defaultProg;
  }

  static Future<void> saveSettings(AppSettings settings) async {
    try {
      final jsonStr = jsonEncode(settings.toJson());
      await _prefs.setString(_settingsKey, jsonStr);
    } catch (_) {}
  }

  static AppSettings loadSettings() {
    try {
      final jsonStr = _prefs.getString(_settingsKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        return AppSettings.fromJson(decoded);
      }
    } catch (_) {}
    return AppSettings();
  }

  static Future<void> resetAll() async {
    await _prefs.remove(_progressKey);
  }
}
