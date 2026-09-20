import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../../../core/widgets/app_snackbar/app_snackbar.dart';

class TwoFactorSettingsPage extends ConsumerStatefulWidget {
  const TwoFactorSettingsPage({super.key});

  @override
  ConsumerState<TwoFactorSettingsPage> createState() =>
      _TwoFactorSettingsPageState();
}

class _TwoFactorSettingsPageState extends ConsumerState<TwoFactorSettingsPage> {
  bool _twoFactorEnabled = false;
  String? _whatsappNumber;
  bool _whatsappVerified = false;
  int _backupCodesRemaining = 0;
  int _trustedDevicesCount = 0;
  bool _loading = true;
  bool _toggling = false;
  String? _error;

  List<String> _generatedCodes = [];

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
      final resp = await DioClient.instance.get('/security/two-factor/status');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is Map) {
        final d = data['data'] as Map<String, dynamic>;
        setState(() {
          _twoFactorEnabled = d['two_factor_enabled'] ?? false;
          _whatsappNumber = d['whatsapp_number'] as String?;
          _whatsappVerified = d['whatsapp_verified'] ?? false;
          _backupCodesRemaining = d['backup_codes_remaining'] ?? 0;
          _trustedDevicesCount = d['trusted_devices_count'] ?? 0;
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

  Future<void> _toggle2FA(bool enabled) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    if (enabled && (_whatsappNumber == null || _whatsappNumber!.isEmpty)) {
      AppSnackBar.show(
        context,
        l.whatsappRequired2FA,
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => _toggling = true);
    try {
      await DioClient.instance.post(
        '/security/two-factor/toggle',
        data: {'enabled': enabled},
      );
      setState(() => _twoFactorEnabled = enabled);
      if (mounted) {
        AppSnackBar.show(
          context,
          enabled ? l.twoFactorEnabled : l.twoFactorDisabled,
          type: SnackBarType.success,
        );
      }
      if (enabled) {
        _showGenerateBackupCodesDialog();
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

  Future<void> _generateBackupCodes() async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    try {
      final resp = await DioClient.instance.post(
        '/security/two-factor/backup-codes',
      );
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is Map) {
        final codes = List<String>.from(
          (data['data'] as Map)['backup_codes'] ?? [],
        );
        setState(() {
          _generatedCodes = codes;
          _backupCodesRemaining = codes.length;
        });
        _showBackupCodesSheet();
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

  void _showGenerateBackupCodesDialog() {
    final l = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.backupCodes),
        content: Text(l.generateBackupCodesConfirm),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _fetchStatus();
            },
            child: Text(l.later),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _generateBackupCodes();
            },
            child: Text(l.generate),
          ),
        ],
      ),
    );
  }

  void _showBackupCodesSheet() {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Text(l.backupCodes, style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSizes.xs),
              Text(
                l.backupCodesDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              ..._generatedCodes.map(
                (code) => Card(
                  margin: const EdgeInsets.only(bottom: AppSizes.xs),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          code,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontFamily: 'monospace',
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
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
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final allCodes = _generatedCodes.join('\n');
                    Clipboard.setData(ClipboardData(text: allCodes));
                    AppSnackBar.show(
                      context,
                      l.allCodesCopied,
                      type: SnackBarType.success,
                    );
                  },
                  icon: const Icon(Icons.copy_all, size: 18),
                  label: Text(l.copyAllCodes),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                l.backupCodesWarning,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.orange),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.md),
            ],
          ),
        ),
      ),
    );
  }

  void _showWhatsappMethodSheet() {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(l.whatsapp, style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSizes.xs),
            Text(
              l.whatsappCodeMethodDesc,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.chat_outlined, color: Colors.green),
              title: Text(l.whatsappNumber, style: AppTextStyles.bodyMedium),
              subtitle: Text(
                _whatsappNumber != null && _whatsappNumber!.isNotEmpty
                    ? _whatsappNumber!
                    : l.noNumberLinked,
                style: AppTextStyles.bodySmall,
              ),
              trailing: _whatsappVerified
                  ? Text(
                      l.whatsappVerified,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.green,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdditionalMethodsSheet() {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(l.additionalMethods, style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSizes.xs),
            Text(
              l.additionalMethodsDesc,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.phonelink_lock_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text(l.loginRequests, style: AppTextStyles.bodyMedium),
              subtitle: Text(
                l.loginRequestsDesc,
                style: AppTextStyles.bodySmall,
              ),
            ),
            const Divider(height: 1, indent: 56),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.phonelink_setup_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text(
                l.authenticatorApp,
                style: AppTextStyles.bodyMedium,
              ),
              subtitle: Text(
                l.authenticatorAppDesc,
                style: AppTextStyles.bodySmall,
              ),
            ),
            const Divider(height: 1, indent: 56),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.vpn_key_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text(l.backupCodes, style: AppTextStyles.bodyMedium),
              subtitle: Text(l.backupCodesDesc, style: AppTextStyles.bodySmall),
              enabled: _twoFactorEnabled,
              trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () {
                Navigator.of(ctx).pop();
                if (_twoFactorEnabled) _showGenerateBackupCodesDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.twoFactorAuth)),
        body: const GuestAuthPrompt(icon: Icons.security_outlined),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.twoFactorAuth),
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
              children: [
                const SizedBox(height: AppSizes.sm),

                // ═══ STATUS 2FA ═══
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    secondary: Icon(
                      _twoFactorEnabled
                          ? Icons.security
                          : Icons.security_outlined,
                      color: _twoFactorEnabled
                          ? Colors.green
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      l.enableTwoFactor,
                      style: AppTextStyles.bodyMedium,
                    ),
                    subtitle: Text(
                      _twoFactorEnabled
                          ? l.twoFactorEnabledDesc
                          : l.twoFactorDisabledDesc,
                      style: AppTextStyles.bodySmall,
                    ),
                    value: _twoFactorEnabled,
                    onChanged: _toggling ? null : (v) => _toggle2FA(v),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // ═══ CARA MENDAPATKAN KODE LOGIN ═══
                _sectionHeader(l.loginCodeMethod.toUpperCase()),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.chat_outlined,
                          color: Colors.green,
                        ),
                        title: Text(
                          l.whatsapp,
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: Text(
                          _whatsappNumber != null && _whatsappNumber!.isNotEmpty
                              ? _whatsappNumber!
                              : l.noNumberLinked,
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: _whatsappVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l.active,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            : Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                              ),
                        onTap: _showWhatsappMethodSheet,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: Icon(
                          Icons.more_horiz,
                          color: AppColors.textSecondary,
                        ),
                        title: Text(
                          l.additionalMethods,
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: Text(
                          l.additionalMethodsDesc,
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                        onTap: _showAdditionalMethodsSheet,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // ═══ KODE CADANGAN ═══
                _sectionHeader(l.backupCodes.toUpperCase()),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.vpn_key_outlined,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          l.backupCodes,
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: Text(
                          _backupCodesRemaining > 0
                              ? l.backupCodesRemaining(_backupCodesRemaining)
                              : l.noBackupCodes,
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                        onTap: _twoFactorEnabled
                            ? () => _showGenerateBackupCodesDialog()
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // ═══ PERANGKAT TERPERCAYA ═══
                _sectionHeader(l.trustedDevices.toUpperCase()),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.devices_other,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(
                      l.trustedDevices,
                      style: AppTextStyles.bodyMedium,
                    ),
                    subtitle: Text(
                      l.trustedDevicesCount(_trustedDevicesCount),
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        0,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
