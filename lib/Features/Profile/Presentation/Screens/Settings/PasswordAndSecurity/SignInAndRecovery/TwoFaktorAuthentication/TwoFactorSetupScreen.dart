import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

import '../../../../../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import '../../../../../../../../Core/Widgets/TwoFactorSetupFlow/TwoFactorSetupFlow.dart';
import '../../../../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';

/// **Two Factor Setup** -- setup 2FA dari Pengaturan.
///
///   Kata Sandi dan Keamanan -> Autentikasi Dua Faktor
///       -> Tambah/Kelola Aplikasi Autentikasi -> halaman ini
///           -> selesai -> Autentikasi Dua Faktor
///
/// Padanan
/// `PasswordSecurityScreen\SignInAndRecovery\TwoFactorySetup\TwoFactorySetup`.
///
/// Yang membedakannya dari **Two Factor Auth** di `Features/Auth` hanya
/// tujuan akhirnya, dan itu memang harus berbeda:
///
///   Two Factor Auth  -> Home     (akhir alur login)
///   Two Factor Setup -> kembali ke Autentikasi Dua Faktor
///
/// Yang kedua penting: di sini pengguna sedang mengatur keamanan dan belum
/// selesai. Melompat ke Home setelah setup berarti keluar dari tempat dia
/// berniat berada. Persis `TwoFactorySetup::getRedirectUrl()` yang menunjuk
/// balik ke halaman Two Factor.
///
/// Alurnya sendiri TIDAK disalin dari Two Factor Auth -- keduanya memakai
/// [TwoFactorSetupFlow], widget yang sama, sama seperti di backend di mana
/// keduanya sama-sama turunan `TwoFactorAuthenticatorScreen`.
class TwoFactorSetupScreen extends ConsumerStatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  ConsumerState<TwoFactorSetupScreen> createState() => _TwoFactorSetupPageState();
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
      if (!mounted || !_isAuthenticated) return;
      _fetchStatus();
    });
  }

  Future<void> _fetchStatus() async {
    if (!_isAuthenticated) return;
    try {
      final response = await DioClient.instance.get(
        ApiEndpoints.securityTwoFactorStatus,
      );
      if (!mounted) return;

      final map = response.data is Map<String, dynamic>
          ? (response.data as Map<String, dynamic>)['data']
                as Map<String, dynamic>?
          : null;

      setState(() {
        _currentType = map?['two_factor_type'] as String?;
        _loading = false;
      });
    } catch (_) {
      // Kegagalan membaca status tidak boleh menahan halaman: server yang
      // akan menolak metode yang sudah pernah dipakai, jadi pengguna tetap
      // bisa memilih metode lain.
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Kembali ke daftar Autentikasi Dua Faktor.
  ///
  /// `pop`, bukan `go`: pengguna datang dari sana lewat
  /// `context.push('/security/two-factor-setup')`, jadi menumpuknya kembali
  /// dengan `pop` yang benar. `go` di sini akan mengganti seluruh tumpukan
  /// navigasi dan membuang halaman Pengaturan yang sedang dibuka.
  void _backToTwoFactor() {
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      // Dibuka langsung (deep link / restore state), jadi tidak ada
      // halaman sebelumnya untuk dipop.
      context.go('/two-factor-settings');
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
                onPressed: _backToTwoFactor,
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
          title: Text(l.twoFactorSetupTitle),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(38),
            child: AppBreadcrumbs.global(),
          ),
        ),
        body: const GuestAuthPrompt(icon: Icons.security_outlined),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(l.twoFactorSetupTitle),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(38),
          child: AppBreadcrumbs.global(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.twoFactorSetupHeading,
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    l.twoFactorSetupSubtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Alurnya sama dengan Two Factor Auth; hanya onFinished
                  // yang berbeda -- di sini kembali ke daftar Keamanan.
                  TwoFactorSetupFlow(
                    currentType: _currentType,
                    onFinished: _backToTwoFactor,
                    onBackupCodes: _showBackupCodes,
                  ),
                ],
              ),
            ),
    );
  }
}