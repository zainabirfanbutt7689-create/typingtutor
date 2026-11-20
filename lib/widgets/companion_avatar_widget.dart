import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/companion_model.dart';
import '../controllers/typing_controller.dart';

class CompanionAvatarWidget extends StatelessWidget {
  final Companion companion;
  final CompanionMood mood;
  final VoidCallback? onTap;
  final double size;

  const CompanionAvatarWidget({
    super.key,
    required this.companion,
    this.mood = CompanionMood.idle,
    this.onTap,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    final isBouncing = mood == CompanionMood.celebrate || mood == CompanionMood.happy;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isBouncing ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.elasticOut,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: companion.avatarBgColor,
            border: Border.all(
              color: companion.accentColor.withOpacity(0.5),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: companion.accentColor.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            companion.svgAssetPath,
            width: size - 16,
            height: size - 16,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
