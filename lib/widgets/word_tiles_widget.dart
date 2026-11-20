import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class WordTilesWidget extends StatelessWidget {
  final String targetWord;
  final String userInput;
  final bool largeText;

  const WordTilesWidget({
    super.key,
    required this.targetWord,
    required this.userInput,
    this.largeText = false,
  });

  @override
  Widget build(BuildContext context) {
    final chars = targetWord.split('');

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(chars.length, (index) {
        final char = chars[index];
        final isTyped = index < userInput.length;
        final isCurrent = index == userInput.length;
        final isCorrect = isTyped && userInput[index].toLowerCase() == char.toLowerCase();

        Color bgColor = Colors.white.withOpacity(0.9);
        Color borderColor = AppColors.lavenderBorder;
        Color textColor = Colors.black38;

        if (isCorrect) {
          bgColor = const Color(0xFFD1FAE5);
          borderColor = const Color(0xFF34D399);
          textColor = const Color(0xFF065F46);
        } else if (isCurrent) {
          bgColor = AppColors.activeKeyGlow;
          borderColor = AppColors.activeKeyBorder;
          textColor = AppColors.activeKeyText;
        }

        final size = largeText ? 64.0 : 54.0;
        final fontSize = largeText ? 34.0 : 28.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size + 10,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border(
              top: BorderSide(color: borderColor, width: isCurrent ? 3 : 2),
              left: BorderSide(color: borderColor, width: isCurrent ? 3 : 2),
              right: BorderSide(color: borderColor, width: isCurrent ? 3 : 2),
              bottom: BorderSide(color: borderColor, width: isCurrent ? 6 : 4),
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: AppColors.activeKeyBorder.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              isTyped ? userInput[index].toUpperCase() : char.toUpperCase(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      }),
    );
  }
}
