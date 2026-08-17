import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../api/api_endpoints.dart';
import '../api/dio_client.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// Inline WhatsApp OTP verifier.
///
/// Render this BELOW a WhatsApp number [TextFormField]. It automatically sends
/// an OTP to the entered number (debounced) and auto-verifies once 6 digits
/// are typed. Use [onVerifiedChanged] to know the verification state so the
/// parent can block saving until the number is verified.
class WhatsappOtpVerifier extends StatefulWidget {
  const WhatsappOtpVerifier({
    super.key,
    required this.numberController,
    required this.countryCode,
    required this.onVerifiedChanged,
    this.initialFullNumber = '',
    this.minDigits = 9,
  });

  final TextEditingController numberController;
  final String countryCode;

  /// Called with `true` when OTP is verified, `false` when unverified.
  final ValueChanged<bool> onVerifiedChanged;

  /// Full number that is already considered verified (e.g. saved profile
  /// whatsapp). If the current number equals this, it is treated as verified
  /// without sending another OTP.
  final String initialFullNumber;

  final int minDigits;

  @override
  State<WhatsappOtpVerifier> createState() => _WhatsappOtpVerifierState();
}

enum _OtpStatus { idle, sending, sent, verifying, verified, error }

class _WhatsappOtpVerifierState extends State<WhatsappOtpVerifier> {
  static const int _otpTtlSeconds = 300;

  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  _OtpStatus _status = _OtpStatus.idle;
  String _errorMessage = '';
  int _expirySeconds = 0;
  Timer? _expiryTimer;
  Timer? _debounce;
  String _lastSentFull = '';
  String _verifiedFull = '';
  String? _initialNormalized;

  bool get _verified => _status == _OtpStatus.verified && _isValid;

  String get _digits => widget.numberController.text.replaceAll(RegExp(r'\D'), '');

  String get _fullNumber {
    final code = widget.countryCode.replaceAll(RegExp(r'\D'), '');
    return '$code$_digits';
  }

  String _normalize(String value) {
    var v = value.replaceAll(RegExp(r'\D'), '');
    if (v.startsWith('0')) v = '62${v.substring(1)}';
    return v;
  }

  bool get _isValid => _digits.length >= widget.minDigits;

  @override
  void initState() {
    super.initState();
    _initialNormalized = _normalize(widget.initialFullNumber);
    widget.numberController.addListener(_onNumberChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluate());
  }

  @override
  void didUpdateWidget(covariant WhatsappOtpVerifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryCode != widget.countryCode ||
        oldWidget.initialFullNumber != widget.initialFullNumber) {
      _initialNormalized = _normalize(widget.initialFullNumber);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _evaluate();
      });
    }
  }

  @override
  void dispose() {
    widget.numberController.removeListener(_onNumberChanged);
    _otpController.dispose();
    _otpFocusNode.dispose();
    _expiryTimer?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  void _onNumberChanged() {
    _debounce?.cancel();
    if (!_isValid) {
      // Nomor kosong/belum valid -> langsung sembunyikan form & reset state
      // tanpa menunggu debounce agar tidak pernah tampil tanpa nomor terisi.
      _evaluate();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _evaluate();
    });
  }

  void _evaluate() {
    if (!mounted) return;
    final full = _fullNumber;
    final normalized = _normalize(full);
    final matchesInitial = _initialNormalized != null &&
        _initialNormalized!.isNotEmpty &&
        normalized == _initialNormalized;

    // Number changed after being verified -> reset to unverified
    if (_verifiedFull.isNotEmpty && _verifiedFull != normalized) {
      _resetToUnverified();
    }

    if (!_isValid) {
      if (_status != _OtpStatus.idle || _verifiedFull.isNotEmpty) {
        _resetToUnverified();
      }
      return;
    }

    if (matchesInitial) {
      _expiryTimer?.cancel();
      if (_status != _OtpStatus.verified) {
        setState(() => _status = _OtpStatus.verified);
        _verifiedFull = normalized;
        _otpController.clear();
        widget.onVerifiedChanged(true);
      }
      return;
    }

    if (_status == _OtpStatus.sending) return;

    if (normalized != _normalize(_lastSentFull)) {
      _sendOtp();
    } else if (_status == _OtpStatus.sent && _expiryTimer == null) {
      // Nomor sama dengan yang terakhir dikirim tapi countdown mati
      // (mis. sempat direset) -> nyalakan ulang tanpa mengirim ulang.
      _startExpiryTimer();
    }
  }

  void _resetToUnverified() {
    _expiryTimer?.cancel();
    _expirySeconds = 0;
    _otpController.clear();
    _verifiedFull = '';
    setState(() => _status = _OtpStatus.idle);
    widget.onVerifiedChanged(false);
  }

  Future<void> _sendOtp() async {
    if (!_isValid) return;
    final l = AppLocalizations.of(context)!;
    final full = _fullNumber;
    setState(() => _status = _OtpStatus.sending);
    try {
      await DioClient.instance.post(
        ApiEndpoints.sendOtp,
        data: {'whatsapp': full, 'purpose': 'verify_whatsapp'},
      );
      if (!mounted) return;
      _lastSentFull = full;
      _otpController.clear();
      setState(() => _status = _OtpStatus.sent);
      _startExpiryTimer();
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? l.failedSendVerificationCode;
      if (!mounted) return;
      setState(() {
        _status = _OtpStatus.error;
        _errorMessage = msg;
      });
    }
  }

  /// 5-minute validity window. When it reaches zero the OTP is automatically
  /// resent and the window restarts.
  Future<void> _startExpiryTimer() async {
    _expirySeconds = _otpTtlSeconds;
    _expiryTimer?.cancel();
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_expirySeconds <= 0) {
        timer.cancel();
        _onExpired();
        return;
      }
      if (mounted) setState(() => _expirySeconds--);
    });
  }

  Future<void> _onExpired() async {
    if (!_isValid || _status == _OtpStatus.sending || _status == _OtpStatus.verifying) {
      return;
    }
    await _sendOtp();
  }

  String _formatCountdown(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onVerify() async {
    final l = AppLocalizations.of(context)!;
    final otp = _otpController.text.replaceAll(RegExp(r'\D'), '');
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.enter6DigitOtp), backgroundColor: AppColors.errorColor),
      );
      return;
    }
    setState(() => _status = _OtpStatus.verifying);
    try {
      await DioClient.instance.post(
        ApiEndpoints.verifyOtp,
        data: {'whatsapp': _fullNumber, 'otp': otp, 'purpose': 'verify_whatsapp'},
      );
      if (!mounted) return;
      _expiryTimer?.cancel();
      setState(() {
        _status = _OtpStatus.verified;
        _verifiedFull = _normalize(_fullNumber);
        _otpController.clear();
      });
      widget.onVerifiedChanged(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.whatsappVerified), backgroundColor: AppColors.successColor),
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? l.failedVerifyOtp;
      if (!mounted) return;
      setState(() {
        _status = _OtpStatus.error;
        _errorMessage = msg;
      });
    }
  }

  Future<void> _onResend() async {
    if (_status == _OtpStatus.sending || _status == _OtpStatus.verifying) return;
    await _sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (!_isValid && !_verified) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_verified)
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.successColor, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.whatsappVerified,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        else ...[
          Text(
            '${l.whatsappOtpSentTo} ${widget.countryCode} $_digits',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  enabled: _status != _OtpStatus.sending && _status != _OtpStatus.verifying,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 6),
                  decoration: InputDecoration(
                    hintText: '------',
                    hintStyle: GoogleFonts.inter(letterSpacing: 6, color: AppColors.textTertiary),
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.secondaryColor.withAlpha(40),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.replaceAll(RegExp(r'\D'), '').length == 6) _onVerify();
                  },
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              if (_status == _OtpStatus.sending || _status == _OtpStatus.verifying)
                SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor))
              else
                GestureDetector(
                  onTap: _onResend,
                  child: Text(
                    l.resendOtp,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (_status == _OtpStatus.sent && _expirySeconds > 0) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              l.otpExpiresIn(_formatCountdown(_expirySeconds)),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
          if (_status == _OtpStatus.error) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              _errorMessage,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorColor),
            ),
          ],
        ],
        const SizedBox(height: AppSizes.xs),
      ],
    );
  }
}
