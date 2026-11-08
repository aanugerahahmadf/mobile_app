import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Errors/AppErrorCodes/AppErrorCodes.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../Providers/AuthProvider/AuthProvider.dart';

class OtpEmailVerificationScreen extends ConsumerStatefulWidget {
  final String? email;
  final String purpose;

  const OtpEmailVerificationScreen({
    super.key,
    this.email,
    this.purpose = 'verify_email',
  });

  @override
  ConsumerState<OtpEmailVerificationScreen> createState() =>
      _OtpEmailVerificationPageState();
}

class _OtpEmailVerificationPageState extends ConsumerState<OtpEmailVerificationScreen> {
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
    final l = AppLocalizations.of(context)!;
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      AppSnackBar.show(context, l.enter6DigitOtp, type: SnackBarType.error);
      return;
    }

    setState(() => _verifying = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.verifyOtp,
        data: {'email': widget.email, 'otp': otp, 'purpose': widget.purpose},
      );

      if (mounted) {
        ref.read(authProvider.notifier).markOtpVerified();
        AppSnackBar.show(
          context,
          l.verificationCodeSent,
          type: SnackBarType.success,
        );
        // OtpEmailVerificationPrompt::verify() di backend: setelah OTP valid,
        // akun yang profilnya belum lengkap diarahkan ke CompleteProfile.
        // CompleteProfile sendiri yang meneruskan ke SecurityQuestion, jadi
        // kedua hop itu tidak digabung di sini.
        if (widget.purpose == 'google_register') {
          context.pushReplacement('/complete-profile');
        } else if (widget.purpose == 'verify_email') {
          context.pushReplacement('/edit-profile');
        } else if (widget.purpose == 'verify_email_security') {
          // Dari CompleteProfile: email berubah, setelah OTP valid lanjut
          // ke Security Question.
          context.pushReplacement('/security-question');
        } else {
          // Kembali ke Landing screen, bukan modal Sign In.
          context.go('/landing');
        }
      }
    } on DioException catch (e) {
      final rawMsg = e.response?.data?['message'] as String? ?? AppErrorCodes.anErrorOccurred;
      final msg = LocalizedError.of(l, rawMsg);
      if (mounted) {
        AppSnackBar.show(context, msg, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _onResend() async {
    final l = AppLocalizations.of(context)!;
    if (_resendSeconds > 0 || _sending) return;

    setState(() => _sending = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.sendOtp,
        data: {'email': widget.email, 'purpose': widget.purpose},
      );

      if (mounted) {
        AppSnackBar.show(
          context,
          l.verificationCodeSent,
          type: SnackBarType.success,
        );
        _startResendTimer();
      }
    } on DioException catch (e) {
      final rawMsg = e.response?.data?['message'] as String? ?? AppErrorCodes.anErrorOccurred;
      final msg = LocalizedError.of(l, rawMsg);
      if (mounted) {
        AppSnackBar.show(context, msg, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
            Text(l.verify, style: AppTextStyles.headlineMedium),
            SizedBox(height: AppSizes.xs),
            Text(
              widget.email != null
                  ? '${l.enterOtpSentTo} ${widget.email!}'
                  : '${l.enterOtpSentTo} ${l.email}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
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
                          borderSide: BorderSide(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
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
              label: l.verify,
              loading: _verifying,
              onPressed: _onVerify,
            ),
            SizedBox(height: AppSizes.md),
            Center(
              child: TextButton(
                onPressed: _resendSeconds > 0 || _sending ? null : _onResend,
                child: Text(
                  _sending
                      ? l.sending
                      : _resendSeconds > 0
                      ? '${l.resendOtp} ($_resendSeconds)'
                      : l.resendOtp,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _resendSeconds > 0
                        ? AppColors.textSecondary
                        : AppColors.primaryColor,
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
