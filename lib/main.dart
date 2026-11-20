import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/sound_service.dart';
import 'services/tts_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Child-safe orientation setup
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize offline persistent engines & audio
  await StorageService.init();
  await SoundService.init();
  await TtsService.init();

  runApp(const BismaTypingTutorApp());
}
