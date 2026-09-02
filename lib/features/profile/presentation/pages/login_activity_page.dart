import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_snackbar.dart';

class LoginActivityPage extends ConsumerStatefulWidget {
  const LoginActivityPage({super.key});

  @override
  ConsumerState<LoginActivityPage> createState() => _LoginActivityPageState();
}

class _LoginActivityPageState extends ConsumerState<LoginActivityPage> {
  Map<String, dynamic>? _current;
  List<Map<String, dynamic>> _others = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await DioClient.instance.get('/security/login-activity');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is Map) {
        final sessionData = data['data'] as Map<String, dynamic>;
        setState(() {
          _current = sessionData['current'] as Map<String, dynamic>?;
          _others = List<Map<String, dynamic>>.from(sessionData['others'] ?? []);
          _loading = false;
        });
      } else {
        setState(() { _error = 'Unexpected response'; _loading = false; });
      }
    } on DioException catch (e) {
      setState(() { _error = e.message ?? 'Failed'; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _removeSession(int id) async {
    final l = AppLocalizations.of(context)!;
    try {
      await DioClient.instance.delete('/security/login-activity/$id');
      if (mounted) {
        AppSnackBar.show(context, l.sessionRemoved, type: SnackBarType.success);
        _fetchSessions();
      }
    } on DioException catch (e) {
      if (mounted) {
        AppSnackBar.show(context, e.message ?? l.failed, type: SnackBarType.error);
      }
    }
  }

  String _formatLastActive(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      final day = dt.day.toString().padLeft(2, '0');
      final monthName = months[dt.month - 1];
      final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$day $monthName ${dt.year}, $time';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.whereYouLoggedIn),
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
                      Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: AppSizes.sm),
                      Text(_error!, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSizes.md),
                      TextButton(onPressed: _fetchSessions, child: Text(l.retry)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchSessions,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSizes.md),
                    children: [
                      // ═══ PERANGKAT INI ═══
                      _sectionHeader(l.thisDevice.toUpperCase()),
                      if (_current != null)
                        Card(
                          margin: const EdgeInsets.only(bottom: AppSizes.sm),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                              child: Icon(Icons.smartphone, color: AppColors.primaryColor, size: 20),
                            ),
                            title: Text(
                              _current!['device_name'] ?? l.currentDevice,
                              style: AppTextStyles.bodyMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_current!['platform'] != null)
                                  Text(_current!['platform'], style: AppTextStyles.bodySmall),
                                Text(
                                  _formatLastActive(_current!['last_active_at']),
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l.currentlyActive,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryColor),
                              ),
                            ),
                            isThreeLine: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        )
                      else
                        Card(
                          margin: const EdgeInsets.only(bottom: AppSizes.sm),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.smartphone, color: AppColors.primaryColor),
                            title: Text(l.currentDevice, style: AppTextStyles.bodyMedium),
                            subtitle: Text(l.noSessionData, style: AppTextStyles.bodySmall),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      const SizedBox(height: AppSizes.lg),

                      // ═══ LOGIN PERANGKAT LAIN ═══
                      _sectionHeader(l.otherDeviceLogins.toUpperCase()),
                      if (_others.isEmpty)
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.md),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.devices_other, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                                  const SizedBox(height: AppSizes.sm),
                                  Text(
                                    l.noOtherLogins,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ..._others.map((session) => Card(
                              margin: const EdgeInsets.only(bottom: AppSizes.sm),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange.withValues(alpha: 0.1),
                                  child: const Icon(Icons.devices_other, color: Colors.orange, size: 20),
                                ),
                                title: Text(
                                  session['device_name'] ?? 'Unknown Device',
                                  style: AppTextStyles.bodyMedium,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (session['platform'] != null)
                                      Text(session['platform'], style: AppTextStyles.bodySmall),
                                    if (session['ip_address'] != null)
                                      Text(session['ip_address'], style: AppTextStyles.bodySmall),
                                    Text(
                                      _formatLastActive(session['last_active_at']),
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).colorScheme.error, size: 22),
                                  onPressed: () => _showRemoveDialog(session),
                                ),
                                isThreeLine: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            )),
                    ],
                  ),
                ),
    );
  }

  void _showRemoveDialog(Map<String, dynamic> session) {
    final l = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.removeDevice),
        content: Text(l.removeDeviceConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _removeSession(session['id'] as int);
            },
            child: Text(l.remove, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSizes.sm),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
