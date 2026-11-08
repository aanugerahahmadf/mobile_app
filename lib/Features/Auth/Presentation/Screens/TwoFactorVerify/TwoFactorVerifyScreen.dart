import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppNotification/AppNotification.dart';
import '../../Providers/AuthProvider/AuthProvider.dart';
import '../../../Data/AppLockService/AppLockService.dart';
import '../../Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

/// Verifikasi 2FA setelah Sign In — sebagai screen, bukan modal.
///
/// Padanan `OtpEmailOrTwoFactory` di panel Filament: satu tempat untuk tiga
/// cara membuktikan identitas (aplikasi autentikasi / email / kode
/// pemulihan), dipilih lewat "Opsi Lainnya".
///
/// Alur:
///   Landing Screen (Google login)
///     -> AuthTwoFactorRequired
///     -> /two-factor-verify (screen ini)
///     -> Home Screen
class TwoFactorVerifyScreen extends ConsumerStatefulWidget {
  const TwoFactorVerifyScreen({super.key});

  @override
  ConsumerState<TwoFactorVerifyScreen> createState() =>
      _TwoFactorVerifyScreenState();
}

class _TwoFactorVerifyScreenState
    extends ConsumerState<TwoFactorVerifyScreen> {
  static const String _methodAuthenticator = 'authenticator';
  static const String _methodEmail = 'email';
  static const String _methodRecovery = 'recovery';

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  /// Challenge dibaca dari provider, bukan diteruskan sebagai argumen.
  AuthTwoFactorRequired? get _challenge {
    final state = ref.read(authProvider);
    return state is AuthTwoFactorRequired ? state : null;
  }

  late String _method;
  bool _verifying = false;
  bool _resending = false;
  bool _moreOpen = false;

  @override
  void initState() {
    super.initState();
    _method = _challenge?.method ?? _methodAuthenticator;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  bool get _isRecovery => _method == _methodRecovery;
  bool get _isEmail => _method == _methodEmail;

  /// Kode pemulihan "abcd-efgh" -> "ABCD-EFGH".
  String get _normalizedCode => _isRecovery
      ? _codeController.text.trim().toUpperCase()
      : _codeController.text.replaceAll(RegExp(r'\D'), '');

  String _hint(AppLocalizations l) {
    if (_isRecovery) return l.twoFactorRecoveryHint;
    if (_isEmail) return l.twoFactorEmailHint;
    return l.twoFactorAuthenticatorHint;
  }

  void _switchMethod(String method) {
    if (method == _method) return;
    setState(() {
      _method = method;
      _moreOpen = false;
      _codeController.clear();
    });
  }

  Future<void> _onVerify() async {
    final l = AppLocalizations.of(context)!;
    final challenge = _challenge;
    if (challenge == null) {
      _closeAndGoLanding();
      return;
    }

    final code = _normalizedCode;
    final valid = _isRecovery ? code.length == 9 : code.length == 6;
    if (!valid) {
      AppNotification.show(
        context,
        _isRecovery ? l.twoFactorRecoveryCodeLabel : l.enter6DigitOtp,
        type: NotificationType.error,
      );
      return;
    }

    setState(() => _verifying = true);
    try {
      await ref
          .read(authProvider.notifier)
          .verifyTwoFactor(
            challengeToken: challenge.challengeToken,
            code: code,
            method: _method,
          );

      // Berhasil: provider sudah menjadi AuthAuthenticated.
      // Langsung ke Home (atau AppLock jika aktif).
      if (!mounted) return;
      final service = AppLockService();
      await syncAppLockFromDb(
        service,
        email: ref.read(currentAccountEmailProvider),
      );
      final flags = await loadAppLockFlags(
        email: ref.read(currentAccountEmailProvider),
      );
      if (!mounted) return;
      if (flags.any) {
        context.go('/app-lock');
      } else {
        context.go('/home');
      }
    } on TwoFactorVerifyException catch (e) {
      if (!mounted) return;
      setState(() => _verifying = false);

      // Challenge kedaluwarsa: kembali ke Landing.
      if (e.sessionExpired) {
        _backToLanding(
          e.message.isEmpty ? l.twoFactorSessionExpired : e.message,
        );
        return;
      }

      _codeController.clear();
      AppNotification.show(
        context,
        e.message.isEmpty ? l.twoFactorWrongCodeBody : e.message,
        type: NotificationType.error,
      );
    }
  }

  Future<void> _onResend() async {
    final l = AppLocalizations.of(context)!;
    final challenge = _challenge;
    if (challenge == null || _resending) return;

    setState(() => _resending = true);
    final ok = await ref
        .read(authProvider.notifier)
        .resendTwoFactorCode(challenge.challengeToken);
    if (!mounted) return;
    setState(() => _resending = false);

    AppNotification.show(
      context,
      ok ? l.verificationCodeSent : l.failedSendVerificationCode,
      type: ok ? NotificationType.success : NotificationType.error,
    );
  }

  /// Tutup screen ini dan kembali ke Landing.
  void _closeAndGoLanding() {
    if (!mounted) return;
    // Buang challenge yang tertinggal.
    ref.read(authProvider.notifier).resetTwoFactorChallenge();
    if (!mounted) return;
    context.go('/landing');
  }

  /// Kembali ke Landing dengan pesan kesalahan.
  void _backToLanding(String? message) {
    final l = AppLocalizations.of(context)!;
    AppNotification.show(
      context,
      message ?? l.twoFactorSessionExpired,
      type: NotificationType.error,
    );
    context.go('/landing');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final challenge = _challenge;

    // Challenge hilang — tidak ada yang perlu diverifikasi.
    if (challenge == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _verifying ? null : _closeAndGoLanding,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isRecovery
                    ? l.twoFactorRecoveryTitle
                    : l.twoFactorVerifyTitle,
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                _hint(l),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // ── Kode ────────────────────────────────────────────────
              TextField(
                controller: _codeController,
                autofocus: true,
                textAlign: TextAlign.center,
                keyboardType: _isRecovery
                    ? TextInputType.text
                    : TextInputType.number,
                inputFormatters: _isRecovery
                    ? [
                        LengthLimitingTextInputFormatter(9),
                        _UpperCaseFormatter(),
                      ]
                    : [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: _isRecovery ? 2 : 6,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: _isRecovery ? 'XXXX-XXXX' : 'XXXXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (_) {
                  // Verifikasi otomatis begitu panjangnya pas.
                  final code = _normalizedCode;
                  final ready =
                      _isRecovery ? code.length == 9 : code.length == 6;
                  if (ready && !_verifying) _onVerify();
                },
              ),
              const SizedBox(height: AppSizes.lg),

              AppButton(
                label: l.verify,
                loading: _verifying,
                onPressed: _onVerify,
                type: ButtonType.primaryGradient,
              ),

              // ── Opsi Lainnya ───────────────────────────────────────
              const SizedBox(height: AppSizes.md),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _moreOpen = !_moreOpen),
                  icon: Icon(
                    _moreOpen ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                  ),
                  label: Text(l.twoFactorOtherOptions),
                ),
              ),
              if (_moreOpen) ...[
                const SizedBox(height: AppSizes.xs),
                _methodTile(
                  l.twoFactorMethodAuthenticator,
                  Icons.phonelink_setup_outlined,
                  _methodAuthenticator,
                ),
                _methodTile(
                  l.twoFactorMethodEmail,
                  Icons.email_outlined,
                  _methodEmail,
                ),
                _methodTile(
                  l.twoFactorMethodRecovery,
                  Icons.vpn_key_outlined,
                  _methodRecovery,
                ),
              ],

              // ── Kirim ulang, hanya relevan untuk kode email ───────
              if (_isEmail) ...[
                const SizedBox(height: AppSizes.sm),
                Center(
                  child: TextButton(
                    onPressed: _resending ? null : _onResend,
                    child: Text(
                      _resending ? l.sending : l.twoFactorResendCode,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],

              // ── Jalan keluar terakhir ──────────────────────────────
              const SizedBox(height: AppSizes.lg),
              Center(
                child: TextButton(
                  onPressed: _verifying ? null : _closeAndGoLanding,
                  child: Text(
                    l.logout,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodTile(String label, IconData icon, String method) {
    final selected = _method == method;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: selected ? AppColors.primaryColor : AppColors.textSecondary,
      ),
      title: Text(label, style: AppTextStyles.bodyMedium),
      trailing: selected
          ? Icon(Icons.check_circle, color: AppColors.primaryColor, size: 20)
          : null,
      onTap: () => _switchMethod(method),
    );
  }
}

/// Memaksa huruf besar saat mengetik kode pemulihan.
class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
