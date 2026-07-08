import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/biometric_settings_provider.dart';
import '../../data/biometric_auth_service.dart';

class AppLockPage extends ConsumerStatefulWidget {
  const AppLockPage({super.key});

  @override
  ConsumerState<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends ConsumerState<AppLockPage> with WidgetsBindingObserver {
  bool _authenticating = false;
  BiometricType? _biometricType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _detectBiometric();
    Future.microtask(_authenticate);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _detectBiometric() async {
    final types = await BiometricAuthService().getAvailableBiometrics();
    if (mounted) {
      setState(() {
        if (types.contains(BiometricType.fingerprint)) {
          _biometricType = BiometricType.fingerprint;
        } else if (types.contains(BiometricType.face)) {
          _biometricType = BiometricType.face;
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_authenticating) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final l = AppLocalizations.of(context)!;
    final enabled = ref.read(fingerprintUnlockProvider);
    if (!enabled) {
      context.go('/home');
      return;
    }

    setState(() => _authenticating = true);

    final service = BiometricAuthService();
    final available = await service.isAvailable();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.biometricNotAvailable)),
        );
        context.go('/home');
      }
      return;
    }

    final typeName = await service.biometricTypeName;
    final reason = l.unlockWith.replaceFirst('%s', typeName);

    final success = await service.authenticate(reason: reason);

    if (mounted) {
      setState(() => _authenticating = false);
      if (success) {
        context.go('/home');
      }
    }
  }

  IconData get _biometricIcon {
    if (_biometricType == BiometricType.face) return Icons.face;
    return Icons.fingerprint;
  }

  String _unlockLabel(AppLocalizations l) {
    if (_biometricType == BiometricType.face) return l.unlockWithFaceId;
    return l.unlockWithFingerprint;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.primaryColor],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_biometricIcon, size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l.unlockApp,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.useBiometricToUnlock,
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (_authenticating)
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  else
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _authenticate,
                        icon: Icon(_biometricIcon, color: AppColors.primaryDark),
                        label: Text(_unlockLabel(l),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
