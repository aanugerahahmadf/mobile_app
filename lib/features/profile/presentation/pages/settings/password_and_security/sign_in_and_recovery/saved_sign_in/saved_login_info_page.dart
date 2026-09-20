import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../../../core/widgets/app_snackbar/app_snackbar.dart';

class SavedLoginInfoPage extends ConsumerStatefulWidget {
  const SavedLoginInfoPage({super.key});

  @override
  ConsumerState<SavedLoginInfoPage> createState() => _SavedLoginInfoPageState();
}

class _SavedLoginInfoPageState extends ConsumerState<SavedLoginInfoPage> {
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
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
    );
  }
}
