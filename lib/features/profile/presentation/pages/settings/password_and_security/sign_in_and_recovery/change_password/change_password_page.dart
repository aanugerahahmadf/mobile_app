import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import '../../../../../providers/profile_provider/profile_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _saving = false;
  bool _logoutOthers = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _lastUpdatedText(AppLocalizations l) {
    final userData = ref.read(profileProvider).userData;
    if (userData == null) return null;
    final raw = userData['updated_at'] as String?;
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw).toLocal();
      const idLocale = 'id_ID';
      final dayName = DateFormat.EEEE(idLocale).format(dt);
      final monthName = DateFormat.MMMM(idLocale).format(dt);
      final year = DateFormat.y(idLocale).format(dt);
      return '${l.lastUpdated} $dayName, ${dt.day} $monthName $year';
    } catch (_) {
      return null;
    }
  }

  Future<void> _changePassword() async {
    if (ref.read(authProvider) is! AuthAuthenticated) return;
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final response = await DioClient.instance.post(
        ApiEndpoints.changePassword,
        data: {
          'current_password': _currentPasswordController.text,
          'new_password': _newPasswordController.text,
          'new_password_confirmation': _confirmPasswordController.text,
          'logout_others': _logoutOthers,
        },
      );

      if (!mounted) return;

      // Server membalas berapa perangkat yang ikut dikeluarkan, jadi
      // checkbox-nya bisa mengonfirmasi dirinya alih-alih diam saja.
      // Field `data` tidak ada di respons lama -- abaikan kalau null.
      final loggedOut = _loggedOutCount(response.data);

      AppSnackBar.show(
        context,
        loggedOut > 0
            ? '${l.passwordChanged} $loggedOut ${l.otherDevicesLoggedOut}'
            : l.passwordChanged,
        type: SnackBarType.success,
      );
      Navigator.of(context).pop();
    } on DioException catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        _extractError(e) ?? l.failed,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Berapa perangkat lain yang ikut dikeluarkan, dari respons server.
///
/// 0 kalau server tidak mengirim field-nya --respons lama tidak
/// membalas jumlah, dan checkbox tetap berfungsi, hanya tidak bisa
/// menampilkan hitungannya.
static int _loggedOutCount(Object? body) {
  if (body is! Map<String, dynamic>) return 0;
  final data = body['data'];
  if (data is! Map<String, dynamic>) return 0;
  final count = data['logged_out_other_devices'];
  return count is num ? count.toInt() : 0;
}

/// Ambil pesan error yang bisa ditampilkan ke pengguna.
  ///
  /// Memprioritaskan pesan per-field dari `errors` (mis. "Kata sandi saat ini
  /// salah"), karena itu yang bisa ditindaklanjuti; `message` top-level
  /// dipakai sebagai cadangan.
  ///
  /// Versi lama menelusuri `e.toString()` dan mencocokkan kata
  /// "password" di dalamnya. Untuk DioException teks itu selalu berupa
  /// "DioException [bad response]: ...", jadi setiap error yang involve
  /// kata sandi -- termasuk yang tidak berkaitan dengan kata sandi lama --
  /// akan ditampilkan sebagai "Kata sandi saat ini salah" padahal
  /// penyebabnya lain.
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (ref.watch(authProvider) is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.changePassword)),
        body: const GuestAuthPrompt(icon: Icons.lock_outline),
      );
    }
    final lastUpdated = _lastUpdatedText(l);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.changePassword),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // ── Subjudul halaman ─────────────────────────────────────
            Text(
              l.changePasswordPageSubtitle,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppSizes.md),

            // ── Kata Sandi Saat Ini (diperbarui ...) ────────────────
            Text(l.currentPassword, style: AppTextStyles.bodySmall),
            if (lastUpdated != null) ...[
              const SizedBox(height: 2),
              Text(
                lastUpdated,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.xs),
            TextFormField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                hintText: l.currentPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? l.requiredField : null,
            ),
            const SizedBox(height: AppSizes.lg),

            // ── Kata Sandi Baru ─────────────────────────────────────
            Text(l.newPassword, style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSizes.xs),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                hintText: l.newPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return l.requiredField;
                if (v.length < 12) return l.passwordMin12Chars;
                if (v == _currentPasswordController.text) {
                  return l.newPasswordSameAsOld;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.lg),

            // ── Tulis Ulang Kata Sandi Baru ─────────────────────────
            Text(l.confirmNewPassword, style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSizes.xs),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                hintText: l.confirmNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return l.requiredField;
                if (v != _newPasswordController.text) return l.passwordMismatch;
                return null;
              },
            ),
            const SizedBox(height: AppSizes.lg),

            // ── Lupa kata Sandi Anda? ───────────────────────────────
            Center(
              child: TextButton(
                onPressed: () => showForgotPasswordSheet(context),
                child: Text(
                  l.forgotPasswordQuestion,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // ── Logout dari perangkat lain ──────────────────────────
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                ),
                value: _logoutOthers,
                onChanged: (v) => setState(() => _logoutOthers = v ?? false),
                title: Text(
                  l.logoutOtherDevices,
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  l.logoutOtherDevicesDesc,
                  style: AppTextStyles.bodySmall,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // ── Tombol Ubah Kata Sandi ──────────────────────────────
            AppButton(
              label: l.changePassword,
              loading: _saving,
              onPressed: _changePassword,
              type: ButtonType.primary,
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
