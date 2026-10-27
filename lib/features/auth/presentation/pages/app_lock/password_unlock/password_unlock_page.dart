import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class PasswordUnlockPage extends StatelessWidget {
  const PasswordUnlockPage({super.key, required this.controller, required this.error, required this.onSubmit});
  final TextEditingController controller;
  final bool error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      TextField(
        controller: controller,
        obscureText: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => onSubmit(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.12),
          labelText: l.password,
          labelStyle: const TextStyle(color: Colors.white70),
          errorText: error ? l.wrongPassword : null,
        ),
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: onSubmit, child: Text(l.unlockApp)),
    ]);
  }
}
