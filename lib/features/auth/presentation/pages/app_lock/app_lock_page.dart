import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../providers/biometric_settings_provider/biometric_settings_provider.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../../data/biometric_auth_service/biometric_auth_service.dart';
import '../../widgets/pin_pad/pin_pad.dart';
import '../../widgets/pin_setup_sheet/pin_setup_sheet.dart';
import '../../widgets/auth_modals/auth_modals.dart';

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
  bool _anyEnabled = false;
  String _pinBuffer = '';
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
      _anyEnabled = flags.pin || _hasBiometric;
    });
    if (!_anyEnabled) {
      _goHome();
      return;
    }
    if (_hasBiometric) {
      await _authenticateBiometric();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Don't re-prompt if: authenticating, no biometric enabled, recently prompted,
    // or user is currently entering PIN digits (mid-entry).
    if (state == AppLifecycleState.resumed &&
        !_authenticating &&
        _hasBiometric &&
        _pinBuffer.isEmpty &&
        DateTime.now().difference(_lastAuthAttempt).inSeconds > 2) {
      _authenticateBiometric();
    }
  }

  Future<void> _authenticateBiometric() async {
    _lastAuthAttempt = DateTime.now();
    final l = AppLocalizations.of(context)!;
    setState(() => _authenticating = true);

    // Face ID: use AI Core face verification (scan wajah → kamera → server).
    // Sidik Jari: tetap pakai biometrik perangkat (local_auth).
    if (_faceEnabled) {
      await _authenticateWithAiFace(l);
    } else {
      await _authenticateWithDeviceBiometric(l);
    }
  }

  Future<void> _authenticateWithAiFace(AppLocalizations l) async {
    // Navigate to face scanner for a live face capture.
    final path = await context.push<String>('/face-scanner');
    // Always update timestamp to prevent lifecycle resume from re-prompting.
    _lastAuthAttempt = DateTime.now();
    if (path == null || !mounted) {
      setState(() => _authenticating = false);
      return;
    }

    // Verify face against enrolled reference via AI Core.
    final appLockService = ref.read(appLockServiceProvider);
    suppressAppLock(const Duration(seconds: 10));
    final verified = await appLockService.verifyFaceOnServer(path);

    _lastAuthAttempt = DateTime.now();
    if (!mounted) return;
    setState(() => _authenticating = false);
    if (verified) {
      _goHome();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.failed)));
    }
  }

  Future<void> _authenticateWithDeviceBiometric(AppLocalizations l) async {
    final service = BiometricAuthService();
    final available = await service.isAvailable();
    if (!available) {
      if (mounted) setState(() => _authenticating = false);
      return;
    }
    final typeName = await service.biometricTypeName;
    final reason = l.unlockWith.replaceFirst('%s', typeName);
    suppressAppLock(const Duration(seconds: 10));
    final success = await service.authenticate(reason: reason);
    _lastAuthAttempt = DateTime.now();
    if (!mounted) return;
    setState(() => _authenticating = false);
    if (success) _goHome();
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
    final showPin = _pinEnabled;
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
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      showPin ? l.enterPinToUnlock : l.useBiometricToUnlock,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    if (showPin) ...[
                      PinDotDisplay(length: _pinBuffer.length, maxLength: 6),
                      const SizedBox(height: 8),
                      if (_pinError)
                        Text(
                          l.wrongPin,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 28),
                      PinEntryPad(onDigit: _onPinDigit, onDelete: _onPinDelete),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _forgotPin,
                        child: Text(
                          l.forgotPin,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ] else if (_authenticating)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    else
                      SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _authenticateBiometric,
                          icon: Icon(
                            _faceEnabled
                                ? Icons.screen_lock_portrait
                                : Icons.fingerprint,
                            color: AppColors.primaryDark,
                          ),
                          label: Text(
                            _faceEnabled
                                ? l.unlockWith.replaceFirst(
                                    '%s',
                                    l.appLockFaceId,
                                  )
                                : l.unlockWithFingerprint,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    if (showPin && _hasBiometric) ...[
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: _authenticateBiometric,
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
