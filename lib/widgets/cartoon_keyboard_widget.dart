import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CartoonKeyboardWidget extends StatelessWidget {
  final String targetKey;
  final String? lastPressedKey;
  final ValueChanged<String> onKeyPress;
  final bool showFingerGuides;

  const CartoonKeyboardWidget({
    super.key,
    required this.targetKey,
    this.lastPressedKey,
    required this.onKeyPress,
    this.showFingerGuides = true,
  });

  Color _getFingerColor(String char) {
    if (!showFingerGuides) return Colors.white;
    final k = char.toLowerCase();
    // Pinky fingers (Pink)
    if (['1', 'q', 'a', 'z', '0', 'p', ';', '/', '-', '='].contains(k)) {
      return AppColors.fingerPinky;
    }
    // Ring fingers (Peach)
    if (['2', 'w', 's', 'x', '9', 'o', 'l', '.'].contains(k)) {
      return AppColors.fingerRing;
    }
    // Middle fingers (Mint)
    if (['3', 'e', 'd', 'c', '8', 'i', 'k', ','].contains(k)) {
      return AppColors.fingerMiddle;
    }
    // Index fingers (Sky Blue)
    if (['4', '5', 'r', 't', 'f', 'g', 'v', 'b', '6', '7', 'y', 'u', 'h', 'j', 'n', 'm'].contains(k)) {
      return AppColors.fingerIndex;
    }
    // Thumbs (Lavender)
    return AppColors.fingerThumb;
  }

  Widget _buildKey(String label, String value, {double flex = 1, bool isSpecial = false}) {
    final isTarget = value.toLowerCase() == targetKey.toLowerCase();
    final isPressed = lastPressedKey?.toLowerCase() == value.toLowerCase();

    Color bgColor = isTarget ? AppColors.activeKeyGlow : _getFingerColor(value);
    Color borderColor = isTarget ? AppColors.activeKeyBorder : AppColors.lavenderBorder;
    Color textColor = isTarget ? AppColors.activeKeyText : AppColors.textDark;

    if (isSpecial && value == 'Backspace') {
      bgColor = const Color(0xFFFFE4E6);
      borderColor = const Color(0xFFFDA4AF);
      textColor = const Color(0xFF9F1239);
    }

    return Expanded(
      flex: (flex * 10).toInt(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onKeyPress(value),
            borderRadius: BorderRadius.circular(14),
            splashColor: AppColors.lavenderDark.withOpacity(0.2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: 48,
              transform: isPressed ? (Matrix4.identity()..translate(0.0, 3.0)) : Matrix4.identity(),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border(
                  top: BorderSide(color: borderColor, width: isTarget ? 3 : 1.5),
                  left: BorderSide(color: borderColor, width: isTarget ? 3 : 1.5),
                  right: BorderSide(color: borderColor, width: isTarget ? 3 : 1.5),
                  bottom: BorderSide(
                    color: borderColor,
                    width: isPressed ? (isTarget ? 2 : 1.5) : (isTarget ? 5 : 4),
                  ),
                ),
                boxShadow: isTarget
                    ? [
                        BoxShadow(
                          color: AppColors.activeKeyBorder.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: label.length > 2 ? 12 : 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    const row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
    const row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.lavenderBorder, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1
          Row(children: row1.map((k) => _buildKey(k, k)).toList()),
          // Row 2
          Row(children: row2.map((k) => _buildKey(k, k)).toList()),
          // Row 3
          Row(
            children: [
              ...row3.map((k) => _buildKey(k, k)),
              _buildKey('⌫', 'Backspace', flex: 1.5, isSpecial: true),
            ],
          ),
          // Row 4
          Row(
            children: [
              _buildKey(',', ',', flex: 1),
              _buildKey('␣ SPACEBAR', ' ', flex: 5),
              _buildKey('.', '.', flex: 1),
              _buildKey('!', '!', flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}
