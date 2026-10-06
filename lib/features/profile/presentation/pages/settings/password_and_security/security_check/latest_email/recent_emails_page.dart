import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../../../../core/widgets/app_text_field/app_text_field.dart';
import '../../../../../../../../core/utils/validators/validators.dart';
import '../../../../../providers/profile_provider/profile_provider.dart';

/// Ganti email dengan verifikasi OTP, plus daftar email terbaru.
///
/// Dua bagian dalam satu halaman, sama seperti
/// `SecurityCheck\RecentEmails\RecentEmails` di backend: form "Ubah Email"
/// di atas, daftar "Email Terbaru" di bawah. Bagian latter saja yang sudah
/// ada sebelumnya -- form ganti emailnya belum, padahal di backend keduanya
/// hidup di halaman yang sama.
class RecentEmailsPage extends ConsumerStatefulWidget {
  const RecentEmailsPage({super.key});

  @override
  ConsumerState<RecentEmailsPage> createState() => _RecentEmailsPageState();
}

class _RecentEmailsPageState extends ConsumerState<RecentEmailsPage> {
  final _emailFormKey = GlobalKey<FormState>();

  /// Email yang sekarang terhubung -- hanya ditampilkan, tidak bisa diubah.
  final _currentEmailController = TextEditingController();

  /// Email baru yang sedang diketik pengguna.
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _otpController = TextEditingController();

  List<Map<String, dynamic>> _emails = [];
  bool _loading = true;
  String? _error;

  /// OTP sudah dikirim ke email baru -- form berpindah ke tahap verifikasi.
  bool _otpSent = false;
  bool _sendingOtp = false;
  bool _verifyingOtp = false;

  bool get _isAuthenticated => ref.read(authProvider) is AuthAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isAuthenticated) {
        _prefillCurrentEmail();
        _fetchEmails();
      }
    });
  }

  @override
  void dispose() {
    _currentEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Isi field email dengan email yang sekarang terhubung.
  ///
  /// Backend menandai field ini readOnly + dehydrated(false), jadi nilainya
  /// selalu milik server dan tidak ikut terkirim. Di sini diambil dari profil
  /// yang sudah termuat, dengan fallback ke akun terautentikasi supaya form
  /// tidak tampil kosong saat profil belum selesai di-load.
  void _prefillCurrentEmail() {
    if (_currentEmailController.text.trim().isNotEmpty) return;
    final fromProfile =
        ref.read(profileProvider).userData?['email'] as String?;
    final email = (fromProfile ?? '').trim();
    if (email.isNotEmpty) {
      _currentEmailController.text = email;
      return;
    }
    final auth = ref.read(authProvider);
    if (auth is AuthAuthenticated && auth.user.email.isNotEmpty) {
      _currentEmailController.text = auth.user.email;
    }
  }

  /// Tahap 1: kirim OTP ke email baru. Email belum berubah di sini.
  Future<void> _sendOtp() async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _sendingOtp = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.securityChangeEmailSendOtp,
        data: {
          'email': _newEmailController.text.trim(),
          'email_confirmation': _confirmEmailController.text.trim(),
        },
      );
      if (!mounted) return;
      setState(() {
        _otpSent = true;
        _otpController.clear();
      });
      AppSnackBar.show(
        context,
        l.emailOtpSent,
        type: SnackBarType.success,
      );
    } on DioException catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        _extractError(e) ?? l.failed,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _sendingOtp = false);
    }
  }

  /// Tahap 2: verifikasi OTP, baru email diganti.
  Future<void> _verifyOtp() async {
    if (!_isAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    final otp = _otpController.text.replaceAll(RegExp(r'\D'), '');
    if (otp.length != 6) {
      AppSnackBar.show(
        context,
        l.enter6DigitOtp,
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _verifyingOtp = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.securityChangeEmailVerifyOtp,
        data: {'otp': otp},
      );
      if (!mounted) return;
      setState(() {
        _otpSent = false;
        _otpController.clear();
        _newEmailController.clear();
        _confirmEmailController.clear();
      });
      AppSnackBar.show(
        context,
        l.emailChangedVerified,
        type: SnackBarType.success,
      );
      // Profil di-cache masih menyimpan email lama; tanpa refresh, form akan
      // lagi menampilkan email yang sudah tidak berlaku.
      _currentEmailController.clear();
      await ref.read(profileProvider.notifier).fetchProfile();
      await ref.read(authProvider.notifier).refreshUser();
      _prefillCurrentEmail();
      _fetchEmails();
    } on DioException catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        _extractError(e) ?? l.emailOtpInvalid,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _verifyingOtp = false);
    }
  }

  /// Ambil pesan error yang bisa ditampilkan ke pengguna.
  ///
  /// Memprioritaskan pesan field-level dari `errors` (mis. "Email sudah
  /// diambil"), karena itu yang bisa ditindaklanjuti; `message` top-level
  /// dipakai sebagai cadangan.
  static String? _extractError(Object e) {
    if (e is! DioException) return null;
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final first = errors[errors.keys.first];
        if (first is List && first.isNotEmpty) return '${first.first}';
      }
      final msg = data['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return null;
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
      // `email_changed`, bukan `email_change`. Bandingkan dengan
      // SecurityController::verifyEmailChangeOtp() dan
      // HandlesPasswordSecurity::verifyEmailChangeOtp() di backend, keduanya
      // menulis tipe `email_changed`. Versi lama mobile menulis
      // `email_change`, yang tidak pernah ada di server -- sehingga setiap
      // email perubahan email jatuh ke `default` dan tampil mentah sebagai
      // "email_changed_at:2026-...".
      case 'email_changed':
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
      case 'email_changed':
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

  /// Form "Ubah Email": bagian atas halaman, sebelum daftar email terbaru.
  Widget _buildChangeEmailForm(AppLocalizations l) {
    return Form(
      key: _emailFormKey,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.changeEmail, style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSizes.xs),
              Text(
                l.changeEmailDesc,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSizes.md),
              // Field read-only. TextFormField (bukan AppTextField) karena
              // butuh enabled: false dan helperText, yang tidak ada di sana.
              Text(l.currentEmail, style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSizes.xs),
              TextFormField(
                controller: _currentEmailController,
                readOnly: true,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  helperText: l.currentEmailDesc,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.dividerColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor.withAlpha(30),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              if (!_otpSent) ...[
                AppTextField(
                  label: l.newEmail,
                  controller: _newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSizes.sm),
                AppTextField(
                  label: l.confirmNewEmail,
                  controller: _confirmEmailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    if (v.trim() != _newEmailController.text.trim()) {
                      return AppLocalizations.of(context)!.emailMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.md),
                AppButton(
                  label: l.sendEmailOtp,
                  loading: _sendingOtp,
                  onPressed: _sendOtp,
                  type: ButtonType.primary,
                ),
              ] else ...[
                Text(l.otpCode, style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSizes.xs),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    helperText: l.enter6DigitOtp,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceColor,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: l.resendEmailOtp,
                        onPressed: _sendingOtp ? null : _sendOtp,
                        type: ButtonType.outline,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: AppButton(
                        label: l.verifyEmailOtp,
                        loading: _verifyingOtp,
                        onPressed: _verifyOtp,
                        type: ButtonType.primary,
                      ),
                    ),
                  ],
                ),
              ],
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
      // Daftar email terbaru adalah bagian pelengkap, bukan isi utama --
      // jadi kegagalannya tidakreplace seluruh halaman. Form ganti email
      // tidak bergantung pada daftar itu dan harus tetap bisa dipakai.
      body: RefreshIndicator(
        onRefresh: _fetchEmails,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            _buildChangeEmailForm(l),
            const SizedBox(height: AppSizes.lg),

            // ── Email terbaru ────────────────────────────────────────
            Text(l.recentEmailsListTitle, style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSizes.sm),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.xl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(_error!, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppSizes.md),
                    TextButton(
                      onPressed: _fetchEmails,
                      child: Text(l.retry),
                    ),
                  ],
                ),
              )
            else if (_emails.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.mark_email_read_outlined,
                      size: 48,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      l.noEmailsInPeriod,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ..._emails.map((email) {
                final type = email['type'] as String? ?? '';

                final IconData icon;
                final Color iconColor;
                switch (type) {
                  case 'password_change':
                    icon = Icons.lock_outline;
                    iconColor = AppColors.primaryColor;
                  case 'email_changed':
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

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: Card(
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
                  ),
                );
              }),
            const SizedBox(height: AppSizes.sm),
            Text(
              l.recentEmailsListDesc,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}
