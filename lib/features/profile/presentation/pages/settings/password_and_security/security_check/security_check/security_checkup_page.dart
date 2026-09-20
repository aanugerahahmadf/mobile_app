import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../../../core/constants/app_sizes/app_sizes.dart';

class SecurityCheckupPage extends ConsumerStatefulWidget {
  const SecurityCheckupPage({super.key});

  @override
  ConsumerState<SecurityCheckupPage> createState() =>
      _SecurityCheckupPageState();
}

class _SecurityCheckupPageState extends ConsumerState<SecurityCheckupPage> {
  List<Map<String, dynamic>> _items = [];
  int _securedCount = 0;
  int _totalItems = 0;
  bool _loading = true;
  String? _error;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isAuthenticated) _fetchCheckup();
    });
  }

  Future<void> _fetchCheckup() async {
    if (!_isAuthenticated) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await DioClient.instance.get('/security/checkup');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is Map) {
        final securityData = data['data'] as Map<String, dynamic>;
        setState(() {
          _items = List<Map<String, dynamic>>.from(securityData['items'] ?? []);
          _securedCount = securityData['secured_count'] as int? ?? 0;
          _totalItems = securityData['total_items'] as int? ?? 0;
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

  String _resolveLabel(AppLocalizations l, Map<String, dynamic> item) {
    final key = item['label_key'] as String?;
    if (key == null) return item['label'] as String? ?? '';
    return switch (key) {
      'checkupPassword' => l.checkupPassword,
      'checkupEmail' => l.checkupEmail,
      'checkupWhatsapp' => l.checkupWhatsapp,
      'checkupTwoFactor' => l.checkupTwoFactor,
      'checkupIdentity' => l.checkupIdentity,
      _ => key,
    };
  }

  String _resolveDescription(AppLocalizations l, Map<String, dynamic> item) {
    if (item['description'] != null) return item['description'] as String;
    final key = item['description_key'] as String?;
    if (key == null) return '';
    return switch (key) {
      'checkupPasswordDesc' => l.checkupPasswordDesc,
      'checkupTwoFactorDesc' => l.checkupTwoFactorDesc,
      'checkupIdentityDesc' => l.checkupIdentityDesc,
      _ => key,
    };
  }

  String? _resolveDetail(AppLocalizations l, Map<String, dynamic> item) {
    final secured = item['secured'] as bool? ?? false;
    if (secured) {
      final verifiedKey = item['detail_verified_key'] as String?;
      final at = item['detail_verified_at'] as String?;
      if (verifiedKey != null) {
        final label = switch (verifiedKey) {
          'checkupEmailVerified' => l.checkupEmailVerified,
          'checkupWhatsappVerified' => l.checkupWhatsappVerified,
          'checkupIdentityVerified' => l.checkupIdentityVerified,
          _ => verifiedKey,
        };
        if (at != null && at.isNotEmpty) {
          try {
            final dt = DateTime.parse(at).toLocal();
            final day = dt.day.toString().padLeft(2, '0');
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
            final monthName = months[dt.month - 1];
            return '$label $day $monthName ${dt.year}';
          } catch (_) {
            return label;
          }
        }
        return label;
      }
    } else {
      final unverifiedKey = item['detail_unverified_key'] as String?;
      if (unverifiedKey != null) {
        return switch (unverifiedKey) {
          'checkupEmailNotVerified' => l.checkupEmailNotVerified,
          'checkupWhatsappNotVerified' => l.checkupWhatsappNotVerified,
          'checkupTwoFactorNotEnabled' => l.checkupTwoFactorNotEnabled,
          'checkupIdentityNotVerified' => l.checkupIdentityNotVerified,
          _ => unverifiedKey,
        };
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.securityCheckup)),
        body: const GuestAuthPrompt(icon: Icons.shield_outlined),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.securityCheckup),
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
                  TextButton(onPressed: _fetchCheckup, child: Text(l.retry)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchCheckup,
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.md),
                children: [
                  // ── Summary card ─────────────────────────────────
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        children: [
                          Icon(
                            _securedCount == _totalItems
                                ? Icons.shield
                                : Icons.shield_outlined,
                            size: 48,
                            color: _securedCount == _totalItems
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            _securedCount == _totalItems
                                ? l.securityAllSecured
                                : l.securityNeedsAttention,
                            style: AppTextStyles.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.xs),
                          LinearProgressIndicator(
                            value: _totalItems > 0
                                ? _securedCount / _totalItems
                                : 0,
                            backgroundColor: AppColors.dividerColor,
                            color: _securedCount == _totalItems
                                ? Colors.green
                                : AppColors.primaryColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            '$_securedCount / $_totalItems ${l.securedItems}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // ── Checklist items ──────────────────────────────
                  ..._items.map((item) {
                    final secured = item['secured'] as bool? ?? false;
                    final label = _resolveLabel(l, item);
                    final description = _resolveDescription(l, item);
                    final detail = _resolveDetail(l, item);
                    final actionRoute = item['action_route'] as String?;

                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.sm),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          secured
                              ? Icons.check_circle
                              : Icons.warning_amber_rounded,
                          color: secured ? Colors.green : Colors.orange,
                          size: 28,
                        ),
                        title: Text(label, style: AppTextStyles.bodyMedium),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(description, style: AppTextStyles.bodySmall),
                            if (detail != null && detail.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                detail,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: secured
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: actionRoute != null
                            ? Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                              )
                            : null,
                        onTap: actionRoute != null
                            ? () => context.push(actionRoute)
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
