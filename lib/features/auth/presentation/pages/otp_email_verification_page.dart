import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../widgets/auth_modals.dart';
class OtpEmailVerificationPage extends StatefulWidget {
  final String? email;
  final String purpose;

  const OtpEmailVerificationPage({super.key, this.email, this.purpose = 'verify_email'});

  @override
  State<OtpEmailVerificationPage> createState() => _OtpEmailVerificationPageState();
}

class _OtpEmailVerificationPageState extends State<OtpEmailVerificationPage> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 60;
  Timer? _resendTimer;
  bool _verifying = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
      }
      setState(() => _resendSeconds--);
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _onVerify() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      AppSnackBar.show(context, 'Masukkan 6 digit kode OTP', type: SnackBarType.error);
      return;
    }

    setState(() => _verifying = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.verifyOtp,
        data: {
          'email': widget.email,
          'otp': otp,
          'purpose': widget.purpose,
        },
      );

      if (mounted) {
        AppSnackBar.show(context, 'Email berhasil diverifikasi', type: SnackBarType.success);
        if (widget.purpose == 'google_register' || widget.purpose == 'verify_email') {
          context.pushReplacement('/edit-profile');
        } else {
          showSignInSheet(context);
        }
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Gagal memverifikasi OTP';
      if (mounted) {
        AppSnackBar.show(context, msg, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _onResend() async {
    if (_resendSeconds > 0 || _sending) return;

    setState(() => _sending = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.sendOtp,
        data: {'email': widget.email, 'purpose': widget.purpose},
      );

      if (mounted) {
        AppSnackBar.show(context, 'Kode OTP telah dikirim ulang', type: SnackBarType.success);
        _startResendTimer();
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Gagal mengirim ulang OTP';
      if (mounted) {
        AppSnackBar.show(context, msg, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Verifikasi Email', style: AppTextStyles.headlineMedium),
            SizedBox(height: AppSizes.xs),
            Text(
              widget.email != null
                  ? 'Masukkan kode OTP yang telah dikirim ke ${widget.email!}'
                  : 'Masukkan kode OTP yang telah dikirim ke email Anda',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSizes.xl),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextFormField(
                      controller: _otpControllers[i],
                      focusNode: _otpFocusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.titleLarge,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.secondaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (v) => _onOtpChanged(i, v),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: AppSizes.xl),
            AppButton(
              label: 'Verifikasi',
              loading: _verifying,
              onPressed: _onVerify,
            ),
            SizedBox(height: AppSizes.md),
            Center(
              child: TextButton(
                onPressed: _resendSeconds > 0 || _sending ? null : _onResend,
                child: Text(
                  _sending
                      ? 'Mengirim...'
                      : _resendSeconds > 0
                          ? '${'Kirim Ulang'} ($_resendSeconds)'
                          : 'Kirim Ulang',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _resendSeconds > 0 ? AppColors.textSecondary : AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
