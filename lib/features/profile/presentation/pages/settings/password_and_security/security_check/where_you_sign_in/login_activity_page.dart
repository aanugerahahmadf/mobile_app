import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../../../core/widgets/app_snackbar/app_snackbar.dart';

class LoginActivityPage extends ConsumerStatefulWidget {
  const LoginActivityPage({super.key});

  @override
  ConsumerState<LoginActivityPage> createState() => _LoginActivityPageState();
}

class _LoginActivityPageState extends ConsumerState<LoginActivityPage> {
  Map<String, dynamic>? _current;
  List<Map<String, dynamic>> _others = [];
  bool _loading = true;
  bool _removingAll = false;
  String? _error;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isAuthenticated) _fetchSessions();
    });
  }

  Future<void> _fetchSessions() async {
    if (!_isAuthenticated) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await DioClient.instance.get('/security/login-activity');
      final data = resp.data;
      if (data is Map<String, dynamic> && data['data'] is Map) {
        final sessionData = data['data'] as Map<String, dynamic>;
        setState(() {
          _current = sessionData['current'] as Map<String, dynamic>?;
          _others = List<Map<String, dynamic>>.from(
            sessionData['others'] ?? [],
          );
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

  Future<void> _removeSession(int id) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    try {
      await DioClient.instance.delete(ApiEndpoints.securityRemoveSession(id));
      if (mounted) {
        AppSnackBar.show(context, l.sessionRemoved, type: SnackBarType.success);
        _fetchSessions();
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

  /// Keluarkan semua sesi perangkat lain sekaligus.
  ///
  /// Padanan logoutOtherBrowserSessions() di panel Filament.
  ///
  /// [password] wajib dan diverifikasi server -- lihat catatan di
  /// [_showRemoveAllSessionsDialog]. Sesi perangkat ini sendiri tidak ikut
  /// dihapus -- itu sebabnya endpoint server menyisakan satu baris dengan id
  /// sesi pemanggil.
  Future<void> _removeAllOtherSessions(String password) async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    setState(() => _removingAll = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.securityRemoveAllOtherSessions,
        data: {'password': password},
      );
      if (mounted) {
        AppSnackBar.show(
          context,
          l.allSessionsRemoved,
          type: SnackBarType.success,
        );
        _fetchSessions();
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
      if (mounted) setState(() => _removingAll = false);
    }
  }

  /// Konfirmasi "Keluar dari Sesi Browser Lain" -- kata sandi WAJIB.
  ///
  /// Di Filament, `deleteBrowserSessions` punya `->requiresConfirmation()`
  /// dengan form berisi TextInput password, dan
  /// `logoutOtherBrowserSessions()` membandingkannya dengan
  /// `Hash::check($password, Auth::user()->password)` sebelum menghapus apa
  /// pun.
  ///
  /// Mobile sebelumnya hanya menampilkan dialog ya/tidak dan langsung
  /// menghapus. Itu menurunkan pemeriksaan yang ada sengaja di web: aksi
  /// yang memutus akses orang lain dari semua perangkat lain bisa memicu
  /// tanpa membuktikan siapa yang meminta.
  ///
  /// Verifikasi dilakukan di server -- password dikirim ke
  /// /security/sessions/remove-all dan dibandingkan di sana, bukan dicek di
  /// klien. Password tidak pernah disimpan di perangkat.
  Future<void> _showRemoveAllSessionsDialog() async {
    final l = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    var obscure = true;
    String? error;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l.logoutAllOtherSessions),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.logoutAllOtherSessionsConfirm,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                l.logoutAllOtherSessionsPasswordConfirm,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: passwordController,
                obscureText: obscure,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l.password,
                  errorText: error,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
                onSubmitted: (_) => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text.isEmpty) {
                  setState(() => error = l.requiredField);

                  return;
                }
                Navigator.of(ctx).pop(true);
              },
              child: Text(
                l.removeAll,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );

    final password = passwordController.text;
    passwordController.dispose();

    if (confirmed != true || password.isEmpty) return;

    await _removeAllOtherSessions(password);
  }

  String _formatLastActive(String? iso) {
    if (iso == null) return '';
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
      final time =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$day $monthName ${dt.year}, $time';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.whereYouLoggedIn)),
        body: const GuestAuthPrompt(icon: Icons.devices_outlined),
      );
    }

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
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
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
                  // --- SUBJUDUL HALAMAN ---
                  Text(
                    l.signInActivityPageSubtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppSizes.md),

                  // --- PERANGKAT INI ---
                  _sectionHeader(l.thisDevice.toUpperCase()),
                  if (_current != null)
                    Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.sm),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Icons.smartphone,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          _current!['device_name'] ?? l.currentDevice,
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_current!['platform'] != null)
                              Text(
                                _current!['platform'],
                                style: AppTextStyles.bodySmall,
                              ),
                            Text(
                              _formatLastActive(_current!['last_active_at']),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l.currentlyActive,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
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
                    )
                  else
                    Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.sm),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.smartphone,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          l.currentDevice,
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: Text(
                          l.noSessionData,
                          style: AppTextStyles.bodySmall,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSizes.lg),

                  // --- LOGIN PERANGKAT LAIN ---
                  _sectionHeader(l.otherDeviceLogins.toUpperCase()),
                  if (_others.isEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.devices_other,
                                size: 48,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: AppSizes.sm),
                              Text(
                                l.noOtherLogins,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ..._others.map(
                      (session) => Card(
                        margin: const EdgeInsets.only(bottom: AppSizes.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.withValues(
                              alpha: 0.1,
                            ),
                            child: const Icon(
                              Icons.devices_other,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            session['device_name'] ?? 'Unknown Device',
                            style: AppTextStyles.bodyMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (session['platform'] != null)
                                Text(
                                  session['platform'],
                                  style: AppTextStyles.bodySmall,
                                ),
                              if (session['ip_address'] != null)
                                Text(
                                  session['ip_address'],
                                  style: AppTextStyles.bodySmall,
                                ),
                              Text(
                                _formatLastActive(session['last_active_at']),
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
                            onPressed: () => _showRemoveDialog(session),
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
                      ),
                    ),

                  // -- Keluarkan semua sesi lain ---------------------
                  const SizedBox(height: AppSizes.sm),
                  OutlinedButton.icon(
                    onPressed: _removingAll
                        ? null
                        : _showRemoveAllSessionsDialog,
                    icon: _removingAll
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout, size: 18),
                    label: Text(l.logoutAllOtherSessions),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
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
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _removeSession(session['id'] as int);
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSizes.sm),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
