import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../api/api_endpoints/api_endpoints.dart';
import '../../api/dio_client/dio_client.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_sizes/app_sizes.dart';
import '../../constants/app_text_styles/app_text_styles.dart';
import '../../widgets/app_button/app_button.dart';
import '../../widgets/app_snackbar/app_snackbar.dart';

/// Metode verifikasi yang bisa dipilih saat setup 2FA.
///
/// Nilainya sama persis dengan nilai `type` yang diterima
/// `SecurityController::setupTwoFactor()` dan nilai enum
/// `TwoFactorAuthType` di backend.
enum TwoFactorSetupType {
  email('email'),
  authenticator('totp'),
  none('none');

  const TwoFactorSetupType(this.wireValue);

  final String wireValue;
}

/// Alur setup 2FA -- padanan `TwoFactorySetup` dari paket multi-2fa.
///
/// Dipakai oleh DUA halaman, persis seperti dua turunannya di backend:
///
///   Two Factor Auth   (Auth\TwoFactorAuth)   -> selesai ke Home
///   Two Factor Setup  (TwoFactorySetup)      -> selesai ke daftar Keamanan
///
/// Isinya sama persis di keduanya -- pilih metode, verifikasi, lihat kode
/// cadangan -- supaya tidak mungkin terlihat berbeda. Yang berbeda hanya
/// [onFinished], yaitu tempat kedua halaman ingin pergi setelah selesai.
///
/// Menggabungkan keduanya ke satu widget, bukan menyalin logikanya ke dua
/// halaman, penting karena yang berbeda cuma tujuan akhir: begitu salah
/// satu diperbaiki dan yang lain tidak, keduanya akan terlihat berbeda
/// persis di bagian yang paling sulit dan paling jarang diuji.
class TwoFactorSetupFlow extends StatefulWidget {
  /// Metode yang sekarang aktif, untuk mematikan pilihan yang sudah dipakai.
  final String? currentType;

  /// Dipanggil setelah 2FA tersimpan (atau dinonaktifkan).
  final VoidCallback onFinished;

  /// Kode cadangan yang baru dibuat, untuk ditampilkan sekali saja.
  final void Function(List<String> codes) onBackupCodes;

  const TwoFactorSetupFlow({
    super.key,
    this.currentType,
    required this.onFinished,
    required this.onBackupCodes,
  });

  @override
  State<TwoFactorSetupFlow> createState() => _TwoFactorSetupFlowState();
}

class _TwoFactorSetupFlowState extends State<TwoFactorSetupFlow> {
  /// Sumber kebenaran untuk isi field kode.
  final _codeController = TextEditingController();

  /// Metode yang sedang dipilih, belum diverifikasi.
  TwoFactorSetupType? _selected;

  /// Metode yang sedang diverifikasi -- tampil sebagai layar kedua.
  TwoFactorSetupType? _verifying;

  String _secret = '';
  String _email = '';
  bool _busy = false;

  bool get _isVerifying => _verifying != null;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _resetCode() => _codeController.clear();

  /// Metode yang sudah pernah dipakai tidak boleh dipilih ulang.
  ///
  /// Sama dengan `disableOptionWhen()` di Filament: server juga akan
  /// menolak dengan "sudah pernah diverifikasi", tapi disabling di sini
  /// membuat alasan itu terlihat SEBELUM pengguna menekan tombol, bukan
  /// sesudah gagal.
  bool _isUsed(TwoFactorSetupType type) =>
      type != TwoFactorSetupType.none &&
      widget.currentType == type.wireValue;

  Future<void> _choose(TwoFactorSetupType type) async {
    final l = AppLocalizations.of(context)!;
    setState(() {
      _busy = true;
      _resetCode();
      _secret = '';
    });

    try {
      final response = await DioClient.instance.post(
        ApiEndpoints.securityTwoFactorSetup,
        data: {'type': type.wireValue},
      );
      if (!mounted) return;

      final data =
          (response.data as Map<String, dynamic>?)?['data']
              as Map<String, dynamic>? ??
          {};

      if (type == TwoFactorSetupType.none) {
        // Matikan 2FA: tidak ada yang perlu diverifikasi.
        AppSnackBar.show(
          context,
          l.twoFactorDisabled,
          type: SnackBarType.success,
        );
        widget.onFinished();
        return;
      }

      setState(() {
        _secret = data['secret'] as String? ?? '';
        _email = data['email'] as String? ?? '';
        _verifying = type;
        _selected = type;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        _message(e) ?? l.failed,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final l = AppLocalizations.of(context)!;
    final type = _verifying;
    if (type == null || _busy) return;

    final code = _codeController.text.trim();
    if (code.isEmpty) {
      AppSnackBar.show(context, l.twoFactorNeedCode, type: SnackBarType.warning);
      return;
    }

    setState(() => _busy = true);
    try {
      final response = await DioClient.instance.post(
        ApiEndpoints.securityTwoFactorSetupVerify,
        data: {'type': type.wireValue, 'code': code},
      );
      if (!mounted) return;

      final data =
          (response.data as Map<String, dynamic>?)?['data']
              as Map<String, dynamic>? ??
          {};

      AppSnackBar.show(
        context,
        l.twoFactorSetupEnabled,
        type: SnackBarType.success,
      );

      final codes = (data['backup_codes'] as List?)
              ?.map((e) => '$e')
              .toList() ??
          const <String>[];
      if (codes.isNotEmpty) widget.onBackupCodes(codes);

      widget.onFinished();
    } on DioException catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        _message(e) ?? l.twoFactorWrongCodeBody,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    final l = AppLocalizations.of(context)!;
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await DioClient.instance.post(ApiEndpoints.securityTwoFactorSetupResend);
      if (!mounted) return;
      AppSnackBar.show(
        context,
        l.twoFactorSetupOtpResent,
        type: SnackBarType.success,
      );
    } on DioException catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        _message(e) ?? l.failed,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Kembali dari layar verifikasi ke layar pemilihan metode.
  ///
  /// Hanya mengubah tampilan -- TIDAK membatalkan apa pun di server, karena
  /// pada tahap ini belum ada yang tersimpan. Secret TOTP yang sudah
  /// dibangkitkan tidak dibuang; ia akan diganti kalau pengguna memilih
  /// tipe lain.
  void _back() {
    setState(() {
      _verifying = null;
      _resetCode();
      _secret = '';
    });
  }

  static String? _message(Object e) {
    if (e is! DioException) return null;
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _isVerifying ? _buildVerify(l) : _buildChoose(l);
  }

  // ── Layar 1: pilih metode ──────────────────────────────────────────
  Widget _buildChoose(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final type in TwoFactorSetupType.values) ...[
          _typeCard(l, type),
          const SizedBox(height: AppSizes.sm),
        ],
        const SizedBox(height: AppSizes.sm),
        if (_busy)
          const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }

  Widget _typeCard(AppLocalizations l, TwoFactorSetupType type) {
    final used = _isUsed(type);
    final selected = _selected == type;

    final (icon, title, desc) = switch (type) {
      TwoFactorSetupType.email => (
        Icons.mail_outline,
        l.twoFactorMethodEmail,
        l.twoFactorSetupEmailDesc,
      ),
      TwoFactorSetupType.authenticator => (
        Icons.phonelink_lock_outlined,
        l.twoFactorMethodAuthenticator,
        l.twoFactorSetupAuthenticatorDesc,
      ),
      TwoFactorSetupType.none => (
        Icons.lock_open_outlined,
        l.twoFactorSetupNone,
        l.twoFactorSetupNoneDesc,
      ),
    };

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? AppColors.primaryColor : AppColors.dividerColor,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        enabled: !used && !_busy,
        leading: Icon(
          icon,
          color: used ? AppColors.textTertiary : AppColors.primaryColor,
        ),
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(
          used ? l.twoFactorSetupAlreadyUsed : desc,
          style: AppTextStyles.bodySmall,
        ),
        trailing: used
            ? Icon(Icons.check_circle, color: Colors.green, size: 20)
            : Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: used || _busy ? null : () => _choose(type),
      ),
    );
  }

  // ── Layar 2: verifikasi ────────────────────────────────────────────
  Widget _buildVerify(AppLocalizations l) {
    final type = _verifying!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          type == TwoFactorSetupType.authenticator
              ? l.twoFactorAuthenticatorHint
              : l.twoFactorEmailHint,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.lg),

        // Secret TOTP ditampilkan sebagai teks, bukan QR saja. Kode manual
        // tetap jalan kalau kamera tidak ada, layarnya terlalu kecil,
        // atau aplikasinya ada di perangkat lain -- sama seperti
        // HandlesTwoFactorAuthenticator::manualSecret().
        if (type == TwoFactorSetupType.authenticator && _secret.isNotEmpty) ...[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.twoFactorSetupManualSecret,
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  SelectableText(
                    _secret,
                    style: TextStyle(fontFamily: 'InstrumentSans', 
                      fontSize: 14,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _secret));
                      AppSnackBar.show(
                        context,
                        l.copied,
                        type: SnackBarType.success,
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(l.copySecret),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],

        if (type == TwoFactorSetupType.email && _email.isNotEmpty) ...[
          Text(
            _email,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
        ],

        TextField(
          controller: _codeController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          style: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            hintText: 'XXXXXX',
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Controller yang jadi sumber kebenaran; dipakai langsung saat
          // verifikasi, jadi kode yang diketik selalu ikut terkirim.
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSizes.lg),

        AppButton(
          label: l.verify,
          loading: _busy,
          onPressed: _verify,
          type: ButtonType.primary,
        ),
        const SizedBox(height: AppSizes.sm),

        if (type == TwoFactorSetupType.email)
          TextButton(
            onPressed: _busy ? null : _resend,
            child: Text(l.twoFactorResendCode),
          ),
        TextButton(
          onPressed: _busy ? null : _back,
          child: Text(l.cancel),
        ),
      ],
    );
  }
}