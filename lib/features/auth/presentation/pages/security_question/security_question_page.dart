import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/utils/security_question_prompt/security_question_prompt.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../providers/auth_provider/auth_provider.dart';

/// Satu kali Pondasi Keamanan, dijalankan setelah OTP verifikasi dan
/// setelah Complete Profile.
///
///   Sign Up biasa  --> LANGSUNG Home
///
///   Setelah OTP verifikasi   --+
///   Setelah Complete Profile --+--> Security Question
///                                        |-- Tidak --> Home
///                                        `-- Ya    --> Two Factor Auth --> Home
///
/// Tidak pernah ditanyakan di setiap Sign In. Halaman ini hanya dituju dari
/// dua alur di atas, dan sekali menjawab langsung dicatat di perangkat supaya
/// tidak muncul lagi -- lihat [SecurityQuestionPrompt].
class SecurityQuestionPage extends ConsumerStatefulWidget {
  const SecurityQuestionPage({super.key});

  @override
  ConsumerState<SecurityQuestionPage> createState() =>
      _SecurityQuestionPageState();
}

class _SecurityQuestionPageState extends ConsumerState<SecurityQuestionPage> {
  bool _answering = false;

  /// Email akun yang sedang dipakai sebagai kunci penanda.
  ///
  /// Dibaca dari AuthAuthenticated, bukan dari profil: halaman ini bisa
  /// dibuka tepat setelah OTP, sebelum profil pernah di-load.
  String? get _email {
    final state = ref.read(authProvider);
    return state is AuthAuthenticated ? state.user.email : null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guard());
  }

  /// Cegah halaman ini muncul di tempat yang seharusnya tidak.
  ///
  /// Dua hal, keduanya padanan mount() milik Filament:
  ///
  ///   1. Sudah dijawab (refresh, atau kembali dari Two Factor Auth) --
  ///      jangan tanya lagi.
  ///
  ///   2. Belum terautentikasi. Halaman ini adalah langkah di tengah alur
  ///      auth, bukan halaman yang bisa dibuka sendiri. Tanpa guard ini,
  ///      restore URI terakhir atau deep link bisa mendarat di sini lalu
  ///      terjebak, karena kedua tombolnya hanya mengarah ke Home.
  Future<void> _guard() async {
    if (!mounted) return;

    final auth = ref.read(authProvider);
    if (auth is! AuthAuthenticated) {
      _goHome();
      return;
    }

    if (await SecurityQuestionPrompt.isAnswered(auth.user.email) && mounted) {
      _goHome();
    }
  }

  void _goHome() {
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _skip() async {
    if (_answering) return;
    setState(() => _answering = true);
    await SecurityQuestionPrompt.markAnswered(_email ?? '');
    if (!mounted) return;
    _goHome();
  }

  Future<void> _strengthen() async {
    if (_answering) return;
    setState(() => _answering = true);
    await SecurityQuestionPrompt.markAnswered(_email ?? '');
    if (!mounted) return;
    // Sama seperti TwoFactorAuth::getRedirectUrl() di backend: tujuan
    // berikutnya Home, bukan daftar Keamanan. Melompat ke Pengaturan setelah
    // setup berarti keluar dari alur login.
    context.go('/two-factor-setup');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return PopScope(
      // Satu langkah di tengah alur: tidak ada halaman sebelumnya untuk
      // kembali. Back tidak boleh memunculkan halaman auth, dan tidak boleh
      // membiarkan pengguna terjebak di sini tanpa tujuan.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 72,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      l.strengthenAccount,
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      l.strengthenAccountSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.xl),
                    AppButton(
                      label: l.strengthenAccountConfirm,
                      loading: _answering,
                      onPressed: _strengthen,
                      type: ButtonType.primary,
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppButton(
                      label: l.strengthenAccountSkip,
                      disabled: _answering,
                      onPressed: _skip,
                      type: ButtonType.outline,
                    ),
                    const SizedBox(height: AppSizes.lg),
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
