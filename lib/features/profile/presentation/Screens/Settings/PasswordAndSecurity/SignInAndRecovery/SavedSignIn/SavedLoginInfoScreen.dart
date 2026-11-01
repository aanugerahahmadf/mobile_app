import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';

class SavedLoginInfoScreen extends ConsumerStatefulWidget {
  const SavedLoginInfoScreen({super.key});

  @override
  ConsumerState<SavedLoginInfoScreen> createState() => _SavedLoginInfoPageState();
}

class _SavedLoginInfoPageState extends ConsumerState<SavedLoginInfoScreen> {
  bool _savedLoginEnabled = true;
  bool _loading = true;
  bool _toggling = false;
  String? _error;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isAuthenticated) _fetchStatus();
    });
  }

  Future<void> _fetchStatus() async {
    if (!_isAuthenticated) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await DioClient.instance.get('/security/saved-login');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is Map) {
        setState(() {
          _savedLoginEnabled =
              (data['data'] as Map)['saved_login_enabled'] ?? true;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Unexpected response';
          _loading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        _error = e.message ?? 'Failed';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _toggleSavedLogin(bool enabled) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    setState(() => _toggling = true);
    try {
      await DioClient.instance.post(
        '/security/saved-login/toggle',
        data: {'enabled': enabled},
      );
      setState(() => _savedLoginEnabled = enabled);
      if (mounted) {
        AppSnackBar.show(
          context,
          enabled ? l.savedLoginEnabled : l.savedLoginDisabled,
          type: SnackBarType.success,
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          e.message ?? l.failed,
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _toggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.savedLoginInfo)),
        body: const GuestAuthPrompt(icon: Icons.bookmark_outline),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.savedLoginInfo),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(_error!, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: AppSizes.md),
                  TextButton(onPressed: _fetchStatus, child: Text(l.retry)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                // ═══ SUBJUDUL HALAMAN ═══
                Text(
                  l.savedLoginPageSubtitle,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: AppSizes.md),

                // ═══ ICON + EXPLANATION ═══
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 48,
                          color: _savedLoginEnabled
                              ? AppColors.primaryColor
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          l.savedLoginInfoTitle,
                          style: AppTextStyles.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          l.savedLoginInfoDesc,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // ═══ TOGGLE ═══
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    secondary: Icon(
                      _savedLoginEnabled
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: _savedLoginEnabled
                          ? AppColors.primaryColor
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      l.saveLoginInfo,
                      style: AppTextStyles.bodyMedium,
                    ),
                    subtitle: Text(
                      _savedLoginEnabled ? l.savedLoginOn : l.savedLoginOff,
                      style: AppTextStyles.bodySmall,
                    ),
                    value: _savedLoginEnabled,
                    onChanged: _toggling ? null : (v) => _toggleSavedLogin(v),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // Daftar perangkat + tombol hapus.
                //
                // Halaman `SavedLogin` di Filament BUKAN hanya saklar
                // simpan-tidak: di bawah saklarnya ada daftar
                // $devices dengan tombol "Hapus" per perangkat dan "Hapus
                // Semua Sign In Tersimpan" di akhir. Mobile sebelumnya
                // hanya punya saklarnya, jadi separuh isi halaman hilang
                // tanpa jejak -- tidak ada tempat pengguna mencabut
                // perangkat yang menyimpan info Sign In-nya.
                //
                // Daftar penuhnya tidak digabung di sini tapi dibuka lewat
                // /trusted-devices: isinya persis sama (daftar + hapus per
                // perangkat + hapus semua, dari endpoint yang sama), dan
                // halaman itu sudah ada serta dipakai juga dari Two Factor.
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.devices_other,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(
                      l.savedLoginDevices,
                      style: AppTextStyles.bodyMedium,
                    ),
                    subtitle: Text(
                      l.savedLoginDevicesDesc,
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => context.push('/trusted-devices'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
    );
  }
}
