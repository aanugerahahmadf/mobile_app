import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../providers/biometric_settings_provider/biometric_settings_provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../../data/biometric_auth_service/biometric_auth_service.dart';
import '../../widgets/pin_setup_sheet/pin_setup_sheet.dart';
import '../../widgets/auth_modals/auth_modals.dart';
import 'pin_unlock/pin_unlock_page.dart';
import 'password_unlock/password_unlock_page.dart';
import 'biometric_unlock/biometric_unlock_page.dart';

class AppLockPage extends ConsumerStatefulWidget {
  const AppLockPage({super.key});

  @override
  ConsumerState<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends ConsumerState<AppLockPage>
    with WidgetsBindingObserver {
  bool _authenticating = false;
  bool _pinError = false;
  bool _pinEnabled = false;
  bool _faceEnabled = false;
  bool _fingerprintEnabled = false;
  bool _passwordEnabled = false;
  bool _anyEnabled = false;
  String _pinBuffer = '';
  final _passwordController = TextEditingController();
  bool _passwordError = false;
  // Track whether biometric auth was attempted and failed, so we can fall back
  // to PIN instead of showing a blank screen or stuck loading indicator.
  bool _biometricFailed = false;
  // Guards against re-prompting when the native biometric dialog closes (its
  // dismissal fires a lifecycle resume that would otherwise loop the prompt).
  DateTime _lastAuthAttempt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _passwordController.dispose();
    super.dispose();
  }

  bool get _hasBiometric => _faceEnabled || _fingerprintEnabled;

  Future<void> _init() async {
    // Sync from DB (source of truth) to local storage on cold start.
    final service = ref.read(appLockServiceProvider);
    await syncAppLockFromDb(
      service,
      email: ref.read(currentAccountEmailProvider),
    );

    final flags = await loadAppLockFlags(
      email: ref.read(currentAccountEmailProvider),
    );
    if (!mounted) return;
    setState(() {
      _pinEnabled = flags.pin;
      _faceEnabled = flags.face;
      _fingerprintEnabled = flags.fingerprint;
      _passwordEnabled = flags.password;
      _anyEnabled = flags.any;
    });
    if (!_anyEnabled) {
      _goHome();
      return;
    }
    // Auto-prompt biometric on cold start, but fall back to PIN if it fails
    // or is unavailable on the device.
    if (_hasBiometric) {
      await _authenticateBiometric();
      // If biometric failed and PIN is available, show the PIN pad instead
      // of leaving the user stuck on a blank screen.
      if (_biometricFailed && _pinEnabled && mounted) {
        setState(() {
          _biometricFailed = false;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reset the biometric-failed flag when the app is paused so that the next
    // resume will try biometric again (the user may have enrolled it in settings).
    if (state == AppLifecycleState.paused) {
      _biometricFailed = false;
    }
    // Don't re-prompt if: authenticating, no biometric enabled, recently prompted,
    // already fell back to PIN, or user is currently entering PIN digits (mid-entry).
    if (state == AppLifecycleState.resumed &&
        !_authenticating &&
        _hasBiometric &&
        !_biometricFailed &&
        _pinBuffer.isEmpty &&
        DateTime.now().difference(_lastAuthAttempt).inSeconds > 2) {
      _authenticateBiometric();
    }
  }

  Future<void> _authenticateBiometric() async {
    _lastAuthAttempt = DateTime.now();
    final l = AppLocalizations.of(context)!;
    setState(() => _authenticating = true);

    // Both Face ID and fingerprint use the platform biometric prompt. This
    // gives iOS Face ID and Android enrolled biometrics the OS-level security
    // guarantees instead of treating a camera photo as Face ID.
    await _authenticateWithDeviceBiometric(l);
  }

  Future<void> _authenticateWithDeviceBiometric(AppLocalizations l) async {
    final service = BiometricAuthService();
    final available = await service.isAvailable();
    if (!available) {
      // Device biometric not available — fall back to PIN if enabled.
      if (mounted) {
        setState(() {
          _authenticating = false;
          _biometricFailed = true;
        });
      }
      return;
    }
    final typeName = await service.biometricTypeName;
    final reason = l.unlockWith.replaceFirst('%s', typeName);
    suppressAppLock(const Duration(seconds: 10));
    final success = await service.authenticate(reason: reason);
    _lastAuthAttempt = DateTime.now();
    if (!mounted) return;
    if (success) {
      _goHome();
    } else {
      // Biometric failed — mark it so the UI can fall back to PIN.
      setState(() {
        _authenticating = false;
        _biometricFailed = true;
      });
    }
  }

  void _onPinDigit(String d) {
    if (_pinBuffer.length >= 6) return;
    setState(() {
      _pinBuffer += d;
      _pinError = false;
    });
    if (_pinBuffer.length == 6) _verifyPin();
  }

  void _onPinDelete() {
    if (_pinBuffer.isEmpty) return;
    setState(() => _pinBuffer = _pinBuffer.substring(0, _pinBuffer.length - 1));
  }

  Future<void> _verifyPin() async {
    final ok = await verifyPin(
      _pinBuffer,
      email: ref.read(currentAccountEmailProvider),
    );
    if (!mounted) return;
    if (ok) {
      _goHome();
    } else {
      setState(() {
        _pinBuffer = '';
        _pinError = true;
      });
    }
  }

  Future<void> _verifyPassword() async {
    final ok = await verifyAppLockPassword(
      _passwordController.text,
      email: ref.read(currentAccountEmailProvider),
    );
    if (!mounted) return;
    if (ok) {
      _goHome();
    } else {
      setState(() {
        _passwordController.clear();
        _passwordError = true;
      });
    }
  }

  Future<void> _forgotPin() async {
    final l = AppLocalizations.of(context)!;
    final email = _currentUserEmail();
    if (email == null || email.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.emailNotFound)));
      }
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.forgotPin),
        content: Text(l.forgotPinConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.sendOtp),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await showOtpVerificationSheet(
      context,
      email: email,
      purpose: 'reset_app_lock',
      onVerified: () async {
        await resetAppLock(
          email: email,
          service: ref.read(appLockServiceProvider),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.appLockReset)));
        await showPinSetupSheet(context, mode: PinSheetMode.setup);
        if (!mounted) return;
        _goHome();
      },
    );
  }

  String? _currentUserEmail() {
    final state = ref.read(authProvider);
    if (state is AuthAuthenticated && state.user.email.isNotEmpty) {
      return state.user.email;
    }
    final accounts = ref.read(authProvider.notifier).savedAccounts;
    if (accounts.isNotEmpty) {
      final idx = ref.read(authProvider.notifier).activeAccountIndex;
      if (idx >= 0 && idx < accounts.length) {
        return accounts[idx].email;
      }
    }
    return null;
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final route = prefs.getString('pre_lock_route');
    await prefs.remove('pre_lock_route');
    if (!mounted) return;
    context.go(route ?? '/home');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Show PIN pad when: PIN is enabled AND (biometric failed OR no biometric
    // is available on this device). This ensures the user always has a way
    // to unlock the app, even if biometric is broken or unavailable.
    final showPin = _pinEnabled && (_biometricFailed || !_hasBiometric);
    final showPassword = _passwordEnabled && (_biometricFailed || !_hasBiometric);
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _faceEnabled
                            ? Icons.screen_lock_portrait
                            : Icons.fingerprint,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l.unlockApp,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      showPin || showPassword ? l.enterPinToUnlock : l.useBiometricToUnlock,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    if (showPin) ...[
                      PinUnlockPage(
                        length: _pinBuffer.length,
                        error: _pinError,
                        onDigit: _onPinDigit,
                        onDelete: _onPinDelete,
                        onForgot: _forgotPin,
                      ),
                    ] else if (showPassword) ...[
                      PasswordUnlockPage(
                        controller: _passwordController,
                        error: _passwordError,
                        onSubmit: _verifyPassword,
                      ),
                    ] else if (_authenticating)
                      BiometricUnlockPage(
                        face: _faceEnabled,
                        authenticating: true,
                        onAuthenticate: _authenticateBiometric,
                      )
                    else
                      BiometricUnlockPage(
                        face: _faceEnabled,
                        authenticating: false,
                        onAuthenticate: _authenticateBiometric,
                      ),
                    // When PIN is shown after biometric failed, offer a retry button.
                    if (showPin && _hasBiometric && _biometricFailed) ...[
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _biometricFailed = false;
                          });
                          _authenticateBiometric();
                        },
                        icon: Icon(
                          _faceEnabled
                              ? Icons.screen_lock_portrait
                              : Icons.fingerprint,
                          color: Colors.white,
                        ),
                        label: Text(
                          _faceEnabled ? l.useAppLockFaceId : l.useFingerprint,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
