import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../../../core/widgets/app_snackbar/app_snackbar.dart';

class TrustedDevicesPage extends ConsumerStatefulWidget {
  const TrustedDevicesPage({super.key});

  @override
  ConsumerState<TrustedDevicesPage> createState() => _TrustedDevicesPageState();
}

class _TrustedDevicesPageState extends ConsumerState<TrustedDevicesPage> {
  List<Map<String, dynamic>> _devices = [];
  bool _loading = true;
  String? _error;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isAuthenticated) _fetchDevices();
    });
  }

  Future<void> _fetchDevices() async {
    if (!_isAuthenticated) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await DioClient.instance.get('/security/trusted-devices');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        setState(() {
          _devices = List<Map<String, dynamic>>.from(data['data']);
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

  Future<void> _removeDevice(int id) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    try {
      await DioClient.instance.delete(ApiEndpoints.securityRemoveTrustedDevice(id));
      if (mounted) {
        AppSnackBar.show(context, l.deviceRemoved, type: SnackBarType.success);
        _fetchDevices();
      }
    } on DioException catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          e.message ?? l.failed,
          type: SnackBarType.error,
        );
      }
    }
  }

  /// Hapus semua perangkat terpercaya sekaligus.
  ///
  /// Padanan removeAllTrustedDevices() di panel Filament. Diformat sebagai
  /// dialog konfirmasi dulu karena efeknya tidak bisa dibatalkan per-item.
  Future<void> _removeAllDevices() async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    try {
      await DioClient.instance.delete(
        ApiEndpoints.securityRemoveAllTrustedDevices,
      );
      if (mounted) {
        AppSnackBar.show(
          context,
          l.allDevicesRemoved,
          type: SnackBarType.success,
        );
        _fetchDevices();
      }
    } on DioException catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          e.message ?? l.failed,
          type: SnackBarType.error,
        );
      }
    }
  }

  /// Jawaban "Ya, Ini Saya" untuk perangkat yang masih menunggu
  /// konfirmasi (trusted_at null). Menandai perangkat sebagai milik user --
  /// padanan tombol confirmItIsMe() di web DeviceTrustPrompt.
  Future<void> _verifyDevice(int id) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    try {
      await DioClient.instance.post(
        ApiEndpoints.securityVerifyTrustedDevice(id),
      );
      if (mounted) {
        AppSnackBar.show(context, l.deviceTrustedMsg, type: SnackBarType.success);
        _fetchDevices();
      }
    } on DioException catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          e.message ?? l.failed,
          type: SnackBarType.error,
        );
      }
    }
  }

  /// Jawaban "Bukan saya": server mencabut SEMUA token Sanctum -- termasuk
  /// token HP yang memanggil ini -- jadi sesinya memang habis meski respons
  /// masih terkirim. Keluar rapi (logoutForReauth), lalu buka sheet Sign In:
  /// pemilik akun yang sedang meninjau langsung masuk lagi, penyerang tidak.
  Future<void> _rejectDevice(int id) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    try {
      await DioClient.instance.post(
        ApiEndpoints.securityRejectTrustedDevice(id),
      );
      // Respons bisa gagal terbaca di sisi server SETELAH token dicabut --
      // anggap sukses jika HTTP-nya menembus atau 401 (token sudah mati).
      if (!mounted) return;
      AppSnackBar.show(context, l.deviceRejectedMsg, type: SnackBarType.error);
      await ref.read(authProvider.notifier).logoutForReauth();
      if (!mounted) return;
      await showSignInSheet(context);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token sudah dicabut server -- berarti penolakan terjadi.
        if (mounted) {
          AppSnackBar.show(
            context,
            l.deviceRejectedMsg,
            type: SnackBarType.error,
          );
          await ref.read(authProvider.notifier).logoutForReauth();
          if (mounted) await showSignInSheet(context);
        }
        return;
      }
      if (mounted) {
        AppSnackBar.show(
          context,
          e.message ?? l.failed,
          type: SnackBarType.error,
        );
      }
    }
  }

  String _formatDate(String? iso) {    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final day = dt.day.toString().padLeft(2, '0');
      final monthName = months[dt.month - 1];
      return '$day $monthName ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.trustedDevices)),
        body: const GuestAuthPrompt(icon: Icons.devices_other_outlined),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trustedDevices),
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
                  TextButton(onPressed: _fetchDevices, child: Text(l.retry)),
                ],
              ),
            )
          : _devices.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.devices_other,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    l.noTrustedDevices,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchDevices,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: _devices.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
                itemBuilder: (context, index) {
                  final device = _devices[index];

                  // Perangkat yang belum dijawab ("Perangkat Baru -- Apakah
                  // Ini Anda?" masih menggantung): kartu tanya DUA tombol,
                  // bukan kartu daftar biasa.
                  if (device['trusted_at'] == null) {
                    return _buildPendingCard(device, l);
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.devices_other,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        device['device_name'] ?? 'Unknown Device',
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (device['platform'] != null)
                            Text(
                              device['platform'],
                              style: AppTextStyles.bodySmall,
                            ),
                          Text(
                            '${l.trustedSince} ${_formatDate(device['trusted_at'])}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 22,
                        ),
                        onPressed: () => _showRemoveDialog(device),
                      ),
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: _devices.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _showRemoveAllDialog,
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: Text(l.removeAll),
            ),
    );
  }

  /// Kartu perangkat yang menunggu konfirmasi -- padanan visual halaman
  /// web DeviceTrustPrompt: rincian perangkat + dua aksi tegas.
  Widget _buildPendingCard(Map<String, dynamic> device, AppLocalizations l) {
    final theme = Theme.of(context);
    final warnColor = Colors.orange.shade700;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: warnColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: warnColor.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.phonelink_ring_outlined,
                    color: warnColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    l.newDeviceQuestion,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: warnColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              device['device_name'] ?? 'Unknown Device',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              [
                if (device['platform'] != null) device['platform'],
                if (device['last_ip'] != null) device['last_ip'],
              ].join(' · '),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (device['first_seen_at'] != null) ...[
              const SizedBox(height: 2),
              Text(
                '${l.firstUsed} ${_formatDate(device['first_seen_at'])}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _verifyDevice(device['id'] as int),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(l.yesItWasMe, overflow: TextOverflow.ellipsis),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _rejectDevice(device['id'] as int),
                    icon: const Icon(Icons.block_outlined, size: 18),
                    label: Text(l.noItWasNotMe, overflow: TextOverflow.ellipsis),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(Map<String, dynamic> device) {
    final l = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.removeTrustedDevice),
        content: Text(l.removeTrustedDeviceConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _removeDevice(device['id'] as int);
            },
            child: Text(
              l.remove,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveAllDialog() {
    final l = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.removeAllTrustedDevices),
        content: Text(l.removeAllTrustedDevicesConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _removeAllDevices();
            },
            child: Text(
              l.removeAll,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
