import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';

/// Displays dots representing the digits already entered.
class PinDotDisplay extends StatelessWidget {
  const PinDotDisplay({super.key, required this.length, this.maxLength = 6});

  final int length;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < length
                ? AppColors.primaryColor
                : Colors.white.withValues(alpha: 0.4),
          ),
        );
      }),
    );
  }
}

/// A numeric PIN keypad used both to set and to unlock.
class PinEntryPad extends StatelessWidget {
  const PinEntryPad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.onVerify,
    this.verifyLabel,
    this.showCheckKey = false,
  });

  final void Function(String digit) onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onVerify;
  final String? verifyLabel;
  final bool showCheckKey;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final digit in row) _key(digit, textColor, onDigit),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCheckKey && onVerify != null)
              _actionKey(Icons.check_circle, AppColors.primaryColor, onVerify!)
            else
              const SizedBox(width: 76),
            _key('0', textColor, onDigit),
            _actionKey(Icons.backspace_outlined, textColor, onDelete),
          ],
        ),
        if (verifyLabel != null && onVerify != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              verifyLabel!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _key(String digit, Color color, void Function(String) onPress) {
    return _PinKey(
      onPressed: () => onPress(digit),
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _actionKey(IconData icon, Color color, VoidCallback onPressed) {
    return _PinKey(
      onPressed: onPressed,
      child: Icon(icon, size: 28, color: color),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: Colors.white.withValues(alpha: 0.1),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(width: 76, height: 76, child: Center(child: child)),
        ),
      ),
    );
  }
}
