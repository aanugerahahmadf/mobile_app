import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Utils/SecurityQuestionPrompt/SecurityQuestionPrompt.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../Providers/AuthProvider/AuthProvider.dart';

import '../../../Data/AppLockService/AppLockService.dart';
import '../../Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart';

/// Satu kali Pondasi Keamanan, dijalankan setelah OTP verifikasi dan
/// setelah Complete Profile.
///
///   Sign Up biasa  --> LANGSUNG Home
///
///   Setelah OTP verifikasi   --+
///   Setelah Complete Profile --+--> Security Question
///                                        |-- Tidak --> Home
///                                        `-- Ya    --> Two Factor Auth
///                                                       --> Home
///
/// Untuk "Ya", 2FA di-setup dalam sesi yang sama lalu langsung ke Home.
/// Untuk "Tidak", pengguna tidak mengaktifkan 2FA sehingga langsung ke Home.
///
/// Tidak pernah ditanyakan di setiap Sign In. Halaman ini hanya dituju dari
/// dua alur di atas, dan sekali menjawab langsung dicatat di perangkat supaya
/// tidak muncul lagi -- lihat [SecurityQuestionPrompt].
class SecurityQuestionScreen extends ConsumerStatefulWidget {
  const SecurityQuestionScreen({super.key});

  @override
  ConsumerState<SecurityQuestionScreen> createState() =>
      _SecurityQuestionPageState();
}

class _SecurityQuestionPageState extends ConsumerState<SecurityQuestionScreen> {
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
      await _goHome();
      return;
    }

    if (await SecurityQuestionPrompt.isAnswered(auth.user.email) && mounted) {
      await _goHome();
    }
  }

  Future<void> _goHome() async {
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
  }

  /// Tutup sesi lalu arahkan ke Landing.
  ///
  /// Memakai [AuthNotifier.logoutForReauth], bukan [AuthNotifier.logout]:
  /// yang kedua akan langsung masuk ke akun tersimpan lain kalau ada, sehingga
  /// orang yang sedang menyiapkan keamanan akun ini justru terbawa ke akun
  /// yang berbeda.
  Future<void> _goToLanding() async {
    await ref.read(authProvider.notifier).logoutForReauth();
    if (!mounted) return;
    context.go('/landing');
  }

  Future<void> _skip() async {
    if (_answering) return;
    setState(() => _answering = true);
    await SecurityQuestionPrompt.markAnswered(_email ?? '');
    if (!mounted) return;
    await _goHome();
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
        if (!didPop) _goToLanding();
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
