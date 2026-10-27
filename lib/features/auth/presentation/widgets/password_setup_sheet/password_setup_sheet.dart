import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../providers/biometric_settings_provider/biometric_settings_provider.dart';

enum PasswordSheetMode { setup, change, disable }

Future<void> showPasswordSetupSheet(
  BuildContext context, {
  PasswordSheetMode mode = PasswordSheetMode.setup,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _PasswordSetupSheet(mode: mode),
  );
}

class _PasswordSetupSheet extends ConsumerStatefulWidget {
  const _PasswordSetupSheet({required this.mode});
  final PasswordSheetMode mode;

  @override
  ConsumerState<_PasswordSetupSheet> createState() => _PasswordSetupSheetState();
}

class _PasswordSetupSheetState extends ConsumerState<_PasswordSetupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;

  bool get _needsCurrent => widget.mode != PasswordSheetMode.setup;

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final email = ref.read(currentAccountEmailProvider);
    if (_needsCurrent &&
        !await verifyAppLockPassword(_current.text, email: email)) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.wrongPassword)),
        );
      }
      return;
    }
    if (widget.mode == PasswordSheetMode.disable) {
      await clearAppLockPassword(email: email);
      await ref.read(passwordUnlockProvider.notifier).setEnabled(false);
    } else {
      await saveAppLockPassword(_password.text, email: email);
      await ref.read(passwordUnlockProvider.notifier).setEnabled(true);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDisable = widget.mode == PasswordSheetMode.disable;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(isDisable ? l.disablePassword : l.appLockPassword,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (_needsCurrent)
            TextFormField(
              controller: _current,
              obscureText: true,
              decoration: InputDecoration(labelText: l.currentPassword),
              validator: (v) => v == null || v.isEmpty ? l.passwordRequired : null,
            ),
          if (!isDisable) ...[
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l.password),
              validator: (v) => v == null || v.length < 8 ? l.passwordMin8Chars : null,
            ),
            TextFormField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(labelText: l.confirmPassword),
              validator: (v) => v != _password.text ? l.passwordMismatch : null,
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving ? const CircularProgressIndicator() : Text(l.save),
          ),
        ]),
      ),
    );
  }
}
