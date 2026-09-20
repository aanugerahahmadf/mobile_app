import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../providers/biometric_settings_provider/biometric_settings_provider.dart';
import '../pin_pad/pin_pad.dart';

enum PinSheetMode { setup, change, disable }

Future<void> showPinSetupSheet(
  BuildContext context, {
  PinSheetMode mode = PinSheetMode.setup,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => _PinSetupSheet(mode: mode),
  );
}

class _PinSetupSheet extends ConsumerStatefulWidget {
  const _PinSetupSheet({required this.mode});

  final PinSheetMode mode;

  @override
  ConsumerState<_PinSetupSheet> createState() => _PinSetupSheetState();
}

class _PinSetupSheetState extends ConsumerState<_PinSetupSheet> {
  String _buffer = '';
  String _newPin = '';
  int _step = 0;
  bool _error = false;
  bool _saving = false;

  bool get _isChange => widget.mode == PinSheetMode.change;
  bool get _needsCurrent => _isChange || widget.mode == PinSheetMode.disable;

  @override
  void initState() {
    super.initState();
    _step = _needsCurrent ? 0 : 1;
  }

  void _onDigit(String d) {
    if (_saving) return;
    if (_buffer.length >= 6) return;
    setState(() {
      _buffer += d;
      _error = false;
    });
    if (_buffer.length >= 6) {
      if (widget.mode == PinSheetMode.disable) {
        _confirmDisable();
      } else {
        _advance();
      }
    }
  }

  void _onDelete() {
    if (_saving) return;
    setState(() {
      if (_buffer.isNotEmpty) {
        _buffer = _buffer.substring(0, _buffer.length - 1);
      }
      _error = false;
    });
  }

  Future<void> _advance() async {
    final pin = _buffer;
    if (_step == 0) {
      final ok = await verifyPin(
        pin,
        email: ref.read(currentAccountEmailProvider),
      );
      if (!mounted) return;
      if (!ok) {
        setState(() {
          _buffer = '';
          _error = true;
        });
        return;
      }
      setState(() {
        _buffer = '';
        _error = false;
        _step = 1;
      });
      return;
    }
    if (_step == 1) {
      _newPin = pin;
      setState(() {
        _buffer = '';
        _step = 2;
      });
      return;
    }
    if (_step == 2) {
      if (pin != _newPin) {
        setState(() {
          _buffer = '';
          _error = true;
          _step = 1;
        });
        return;
      }
      await _save(pin);
    }
  }

  Future<void> _save(String pin) async {
    setState(() => _saving = true);
    await savePin(pin, email: ref.read(currentAccountEmailProvider));
    ref.read(pinUnlockProvider.notifier).setEnabled(true);
    final service = ref.read(appLockServiceProvider);
    await service.setPin(pin);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _disable() async {
    setState(() => _saving = true);
    ref.read(pinUnlockProvider.notifier).setEnabled(false);
    // Clear stored PIN locally.
    await clearStoredPin(email: ref.read(currentAccountEmailProvider));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDisable() async {
    final ok = await verifyPin(
      _buffer,
      email: ref.read(currentAccountEmailProvider),
    );
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _buffer = '';
        _error = true;
      });
      return;
    }
    await _disable();
  }

  String _title(AppLocalizations l) {
    if (_step == 0) return l.enterCurrentPin;
    if (_step == 1) return l.enterNewPin;
    return l.confirmPin;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDisable = widget.mode == PinSheetMode.disable;
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryDark, AppColors.primaryColor],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          top: 32,
          bottom: 32 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isDisable ? l.disablePin : _title(l),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isDisable ? l.enterCurrentPinToDisable : l.enterPinToUnlock,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PinDotDisplay(length: _buffer.length, maxLength: 6),
              const SizedBox(height: 8),
              if (_error)
                Text(
                  l.wrongPin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 32),
              if (_saving)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              else
                PinEntryPad(
                  onDigit: _onDigit,
                  onDelete: _onDelete,
                  onVerify: isDisable ? _confirmDisable : null,
                  verifyLabel: isDisable ? l.confirm : null,
                  showCheckKey: isDisable,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
