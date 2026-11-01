import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

import '../../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../../Core/Widgets/TwoFactorSetupFlow/TwoFactorSetupFlow.dart';
import '../../Providers/AuthProvider/AuthProvider.dart';

/// **Two Factor Auth** -- setup 2FA di tengah alur auth.
///
///   OTP terverifikasi / Complete Profile -> Security Question
///       -> jawab ya -> halaman ini -> Landing -> OtpEmailOrTwoFactory -> Home
///
/// Padanan `App\Filament\User\Auth\TwoFactorAuth\TwoFactorAuth`. Yang
/// membedakannya dari **Two Factor Setup** di Pengaturan hanya tiga hal, dan
/// ketiganya memang harus begitu -- persis seperti di backend, di mana
/// keduanya sama-sama turunan `TwoFactorAuthenticatorScreen`:
///
///   - Tujuannya: ini akhir alur auth, jadi setelah selesai ke Home.
///     Two Factor Setup kembali ke daftar Keamanan, karena di sana
///     pengguna sedang mengatur keamanan dan belum selesai.
///
///   - Tidak punya halaman sebelumnya. Pengguna datang dari Security
///     Question, jadi Back tidak boleh memunculkan apa pun -- ia berarti
///     "sudah cukup".
///
///   - 2FA yang sudah aktif tidak perlu setup lagi, jadi langsung ke Home.
///     Sama seperti `TwoFactorAuth::mount()`.
///
/// Isinya sendiri TIDAK disalin: semuanya berasal dari [TwoFactorSetupFlow],
/// widget yang sama dengan yang dipakai Two Factor Setup. Kalau alurnya
/// disalin ke sini, setiap perbaikan pada verifikasi TOTP harus diulang dua
/// kali dan pasti ada satu yang tertinggal -- persis alasan backend
/// mewarisi
/// satu base class alih-alih menyalin.
class TwoFactorSetupScreen extends ConsumerStatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  ConsumerState<TwoFactorSetupScreen> createState() =>
      _TwoFactorSetupPageState();
}

class _TwoFactorSetupPageState extends ConsumerState<TwoFactorSetupScreen> {
  String? _currentType;
  List<String> _backupCodes = [];
  bool _loading = true;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_isAuthenticated) {
        _goHome();
        return;
      }
      _fetchStatus();
    });
  }

  void _goHome() {
    if (!mounted) return;
    context.go('/home');
  }

  /// Selesai alur Security Question: 2FA baru saja diaktifkan.
  /// Langsung ke Home tanpa perlu login ulang, karena 2FA sudah di-setup
  /// dalam sesi yang sama.
  Future<void> _finishToLanding() async {
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _fetchStatus() async {
    if (!_isAuthenticated) return;
    try {
      final response = await DioClient.instance.get(
        ApiEndpoints.securityTwoFactorStatus,
      );
      final data = response.data;
      if (!mounted) return;

      final map = data is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>?
          : null;

      final type = map?['two_factor_type'] as String?;

      // Sudah aktif: tidak perlu setup lagi. Padanan
      // TwoFactorAuth::mount(), yang juga langsung ke Home.
      if (type != null && type != 'none') {
        _goHome();
        return;
      }

      setState(() {
        _currentType = type;
        _loading = false;
      });
    } catch (_) {
      // Status gagal dibaca bukan alasan untuk memblokir alur -- setup 2FA
      // tetap bisa dicoba, dan server yang akan menolak kalau memang sudah
      // aktif. Menahan pengguna di halaman ini justru membuat mereka
      // terjebak tanpa jalan keluar.
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showBackupCodes(List<String> codes) {
    final l = AppLocalizations.of(context)!;
    setState(() => _backupCodes = codes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: ListView(
            controller: scrollCtrl,
            children: [
              Text(l.backupCodes, style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSizes.xs),
              Text(
                l.backupCodesWarning,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              ..._backupCodes.map(
                (code) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      code,
                      style: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        letterSpacing: 2,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        AppSnackBar.show(
                          context,
                          l.copied,
                          type: SnackBarType.success,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              AppButton(
                label: l.twoFactorSetupDone,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _finishToLanding();
                },
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.twoFactorAuthTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.security_outlined),
      );
    }

    return PopScope(
      // Tidak ada halaman sebelumnya: pengguna datang dari Security Question
      // lewat context.go, jadi tidak ada yang bisa di-pop. Back diperlakukan
      // sebagai "sudah cukup" agar tidak menjebak di tengah alur.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finishToLanding();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(l.twoFactorAuthTitle),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 64,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      l.twoFactorAuthHeading,
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      l.twoFactorAuthSubheading,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Alurnya sama dengan Two Factor Setup; hanya
                    // onFinished yang berbeda. Selesai di sini langsung ke Home,
                    // karena 2FA sudah di-setup dalam sesi yang sama.
                    TwoFactorSetupFlow(
                      currentType: _currentType,
                      onFinished: _finishToLanding,
                      onBackupCodes: _showBackupCodes,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}