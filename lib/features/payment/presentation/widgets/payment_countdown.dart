import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class PaymentCountdown extends StatefulWidget {
  final DateTime? deadline;

  const PaymentCountdown({super.key, this.deadline});

  @override
  State<PaymentCountdown> createState() => _PaymentCountdownState();
}

class _PaymentCountdownState extends State<PaymentCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    final deadline = widget.deadline;
    if (deadline != null) {
      _update(deadline);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update(deadline));
    }
  }

  @override
  void didUpdateWidget(covariant PaymentCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) {
      _timer?.cancel();
      final deadline = widget.deadline;
      if (deadline != null) {
        _update(deadline);
        _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update(deadline));
      }
    }
  }

  void _update(DateTime deadline) {
    final remaining = deadline.difference(DateTime.now());
    final next = remaining.isNegative ? Duration.zero : remaining;
    if (mounted && next != _remaining) {
      setState(() => _remaining = next);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hasDeadline = widget.deadline != null && _remaining > Duration.zero;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 22, color: AppColors.primaryColor),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              hasDeadline ? l.paymentDeadline : l.payWithin24h,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
            ),
          ),
          if (hasDeadline)
            Text(
              _formatDuration(_remaining),
              style: GoogleFonts.inter(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}
