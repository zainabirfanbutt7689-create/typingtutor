import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'controllers/typing_controller.dart';
import 'screens/welcome_screen.dart';

class BismaTypingTutorApp extends StatelessWidget {
  const BismaTypingTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TypingController(),
      child: MaterialApp(
        title: 'BISMA: AI Cartoon Typing Tutor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const WelcomeScreen(),
      ),
    );
  }
}
