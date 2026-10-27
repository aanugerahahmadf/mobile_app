import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../widgets/pin_pad/pin_pad.dart';

class PinUnlockPage extends StatelessWidget {
  const PinUnlockPage({super.key, required this.length, required this.error, required this.onDigit, required this.onDelete, required this.onForgot});
  final int length;
  final bool error;
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      PinDotDisplay(length: length, maxLength: 6),
      const SizedBox(height: 8),
      if (error) Text(l.wrongPin, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      const SizedBox(height: 28),
      PinEntryPad(onDigit: onDigit, onDelete: onDelete),
      const SizedBox(height: 8),
      TextButton(onPressed: onForgot, child: Text(l.forgotPin, style: const TextStyle(color: Colors.white70))),
    ]);
  }
}
