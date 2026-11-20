import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SentenceDisplayWidget extends StatelessWidget {
  final String targetText;
  final String userInput;
  final bool largeText;

  const SentenceDisplayWidget({
    super.key,
    required this.targetText,
    required this.userInput,
    this.largeText = false,
  });

  @override
  Widget build(BuildContext context) {
    final chars = targetText.split('');
    final fontSize = largeText ? 24.0 : 20.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lavenderBorder, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
            height: 1.4,
          ),
          children: List.generate(chars.length, (index) {
            final char = chars[index];
            final isTyped = index < userInput.length;
            final isCurrent = index == userInput.length;
            final isCorrect = isTyped && userInput[index] == char;
            final isWrong = isTyped && !isCorrect;

            Color charColor = Colors.black38;
            Color? highlightBg;

            if (isCorrect) {
              charColor = const Color(0xFF059669);
            } else if (isWrong) {
              charColor = const Color(0xFFE11D48);
              highlightBg = const Color(0xFFFFE4E6);
            } else if (isCurrent) {
              charColor = AppColors.activeKeyText;
              highlightBg = AppColors.activeKeyGlow;
            }

            return TextSpan(
              text: char,
              style: TextStyle(
                color: charColor,
                backgroundColor: highlightBg,
                fontWeight: (isCurrent || isCorrect) ? FontWeight.bold : FontWeight.w600,
              ),
            );
          }),
        ),
      ),
    );
  }
}
