import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class BiometricUnlockPage extends StatelessWidget {
  const BiometricUnlockPage({super.key, required this.face, required this.authenticating, required this.onAuthenticate});
  final bool face;
  final bool authenticating;
  final VoidCallback onAuthenticate;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (authenticating) {
      return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onAuthenticate,
        icon: Icon(face ? Icons.face : Icons.fingerprint, color: Colors.black),
        label: Text(
          face ? l.unlockWith.replaceFirst('%s', l.appLockFaceId) : l.unlockWithFingerprint,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      ),
    );
  }
}
