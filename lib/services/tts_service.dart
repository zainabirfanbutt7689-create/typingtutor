import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static bool isEnabled = true;

  static Future<void> init() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45); // Slower, clearer speech cadence for children
      await _tts.setPitch(1.2); // Child-friendly warm pitch
    } catch (_) {}
  }

  static void setEnabled(bool enabled) {
    isEnabled = enabled;
  }

  static Future<void> speak(String text) async {
    if (!isEnabled || text.isEmpty) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
