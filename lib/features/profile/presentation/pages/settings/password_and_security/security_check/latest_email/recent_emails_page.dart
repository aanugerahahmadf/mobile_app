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

class RecentEmailsPage extends ConsumerStatefulWidget {
  const RecentEmailsPage({super.key});

  @override
  ConsumerState<RecentEmailsPage> createState() => _RecentEmailsPageState();
}

class _RecentEmailsPageState extends ConsumerState<RecentEmailsPage> {
  List<Map<String, dynamic>> _emails = [];
  bool _loading = true;
  String? _error;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isAuthenticated) _fetchEmails();
    });
  }

  Future<void> _fetchEmails() async {
    if (!_isAuthenticated) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await DioClient.instance.get('/security/recent-emails');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        setState(() {
          _emails = List<Map<String, dynamic>>.from(data['data']);
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

  String _resolveSubject(AppLocalizations l, Map<String, dynamic> email) {
    final type = email['type'] as String? ?? '';
    final bodyRaw = email['body'] as String? ?? '';

    switch (type) {
      case 'password_change':
        return l.securityEmailPasswordChange;
      case 'email_change':
        return l.securityEmailEmailChange;
      case 'login_alert':
        return l.securityEmailLoginAlert;
      case 'account_update':
        if (bodyRaw.startsWith('whatsapp_changed_at:')) {
          return l.securityEmailWhatsappChange;
        }
        return l.securityEmailAccountUpdate;
      default:
        return email['subject'] as String? ?? type;
    }
  }

  String _resolveBody(AppLocalizations l, Map<String, dynamic> email) {
    final type = email['type'] as String? ?? '';
    final bodyRaw = email['body'] as String? ?? '';
    DateTime? timestamp;
    if (bodyRaw.contains(':')) {
      final parts = bodyRaw.split(':');
      final ts = parts.sublist(1).join(':');
      try {
        timestamp = DateTime.parse(ts);
      } catch (_) {
        timestamp = null;
      }
    }

    final String baseMessage;
    switch (type) {
      case 'password_change':
        baseMessage = l.securityEmailPasswordChangeBody;
      case 'email_change':
        baseMessage = l.securityEmailEmailChangeBody;
      case 'login_alert':
        baseMessage = l.securityEmailLoginAlertBody;
      case 'account_update':
        if (bodyRaw.startsWith('whatsapp_changed_at:')) {
          baseMessage = l.securityEmailWhatsappChangeBody;
        } else {
          baseMessage = l.securityEmailAccountUpdateBody;
        }
      default:
        baseMessage = email['body'] as String? ?? '';
    }

    if (timestamp != null) {
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
      final day = timestamp.day.toString().padLeft(2, '0');
      final monthName = months[timestamp.month - 1];
      final time =
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      final formatted = '$day $monthName ${timestamp.year} $time';
      return '$baseMessage $formatted';
    }

    return baseMessage;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.recentEmails)),
        body: const GuestAuthPrompt(icon: Icons.mark_email_read_outlined),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.recentEmails),
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
                  TextButton(onPressed: _fetchEmails, child: Text(l.retry)),
                ],
              ),
            )
          : _emails.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    l.noSecurityEmails,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchEmails,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: _emails.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
                itemBuilder: (context, index) {
                  final email = _emails[index];
                  final type = email['type'] as String? ?? '';

                  final IconData icon;
                  final Color iconColor;
                  switch (type) {
                    case 'password_change':
                      icon = Icons.lock_outline;
                      iconColor = AppColors.primaryColor;
                    case 'email_change':
                      icon = Icons.email_outlined;
                      iconColor = Colors.orange;
                    case 'login_alert':
                      icon = Icons.login;
                      iconColor = Colors.red;
                    case 'account_update':
                      icon = Icons.person_outline;
                      iconColor = Colors.blue;
                    default:
                      icon = Icons.mail_outline;
                      iconColor = AppColors.textSecondary;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: iconColor.withValues(alpha: 0.1),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      title: Text(
                        _resolveSubject(l, email),
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        _resolveBody(l, email),
                        style: AppTextStyles.bodySmall,
                      ),
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
