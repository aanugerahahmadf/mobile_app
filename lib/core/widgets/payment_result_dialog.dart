import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../utils/formatters.dart';
import 'app_button.dart';

class PaymentResultConfig {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool success;
  final String orderId;

  final String? transactionId;
  final String? paymentMethod;
  final String? vaNumber;
  final int? grossAmount;
  final String? transactionTime;

  const PaymentResultConfig({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.success,
    required this.orderId,
    this.transactionId,
    this.paymentMethod,
    this.vaNumber,
    this.grossAmount,
    this.transactionTime,
  });
}

Future<void> showPaymentResultDialog(BuildContext context, PaymentResultConfig cfg) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _PaymentResultContent(config: cfg),
  );
}

class _PaymentResultContent extends StatelessWidget {
  final PaymentResultConfig config;
  const _PaymentResultContent({required this.config});

  void _shareGmail(BuildContext ctx) {
    final sl = AppLocalizations.of(ctx)!;
    final subject = Uri.encodeComponent('${sl.invoice} #${config.orderId}');
    final body = Uri.encodeComponent(_shareText(sl));
    launchUrl(Uri.parse('mailto:?subject=$subject&body=$body'), mode: LaunchMode.externalApplication);
  }

  void _shareMessages(BuildContext ctx) {
    final sl = AppLocalizations.of(ctx)!;
    launchUrl(Uri.parse('sms:?body=${Uri.encodeComponent(_shareText(sl))}'), mode: LaunchMode.externalApplication);
  }

  void _shareWhatsapp(BuildContext ctx) {
    final sl = AppLocalizations.of(ctx)!;
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(_shareText(sl))}'), mode: LaunchMode.externalApplication);
  }

  String _shareText(AppLocalizations l) {
    final buf = StringBuffer()
      ..writeln('━─━━─━ ${l.invoice} ━─━━─━')
      ..writeln('${l.viewOrder} #${config.orderId}')
      ..writeln('${l.tryAgain}: ${config.title}');
    if (config.transactionId != null) {
      buf.writeln('${l.transactionId}: ${config.transactionId!}');
    }
    if (config.paymentMethod != null) {
      buf.writeln('${l.method}: ${config.paymentMethod!}');
    }
    if (config.vaNumber != null) {
      buf.writeln('${l.vaNumber}: ${config.vaNumber}');
    }
    if (config.grossAmount != null) {
      buf.writeln('${l.total}: ${Formatters.currency(config.grossAmount!)}');
    }
    if (config.transactionTime != null) {
      buf.writeln('${l.time}: ${Formatters.dateTime(config.transactionTime!)}');
    }
    buf.writeln('━─━━─━━─━━─━━─━');
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: config.color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, size: 52, color: config.color),
          ),
          const SizedBox(height: 16),
          Text(config.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(config.message,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            textAlign: TextAlign.center,
          ),

          if (config.success && config.transactionId != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.invoice,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  _receiptRow(l.transactionId, config.transactionId ?? '-'),
                  if (config.paymentMethod != null)
                    _receiptRow(l.method, _methodLabel(config.paymentMethod!, l)),
                  if (config.vaNumber != null)
                    _receiptRow(l.vaNumber, config.vaNumber!),
                  if (config.grossAmount != null)
                    _receiptRow(l.total, Formatters.currency(config.grossAmount!)),
                  if (config.transactionTime != null)
                    _receiptRow(l.paymentTime, Formatters.dateTime(config.transactionTime!)),
                ],
              ),
            ),
          ],

          if (config.success) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(l.shareInvoice, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _shareButton(Icons.email_rounded, const Color(0xFFEA4335), l.sendViaGmail, () => _shareGmail(context)),
                      _shareButton(Icons.chat_bubble_rounded, const Color(0xFF34B7F1), l.sendViaSms, () => _shareMessages(context)),
                      _shareButton(Icons.chat_outlined, const Color(0xFF25D366), l.whatsapp, () => _shareWhatsapp(context)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actions: [
        if (config.success) ...[
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l.viewOrder,
              onPressed: () {
                context.pop();
                if (context.canPop()) context.pop();
                context.push('/order/${config.orderId}');
              },
            ),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                  child: AppButton(
                    label: l.back,
                  onPressed: () {
                    context.pop();
                    if (context.canPop()) context.pop();
                    context.push('/order/${config.orderId}');
                  },
                  type: ButtonType.outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: l.tryAgain,
                  onPressed: () {
                    context.pop();
                    context.push('/payment/${config.orderId}');
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  String _methodLabel(String method, AppLocalizations l) {
    switch (method) {
      case 'bank_transfer': return l.transferBank;
      case 'qris': return l.qris;
      case 'gopay': return l.gopay;
      case 'shopeepay': return l.shopeepay;
      case 'echannel': return l.mandiriBill;
      case 'cstore': return l.convenienceStore;
      default: return method;
    }
  }

  Widget _shareButton(IconData icon, Color color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color.withAlpha(200)),
          ),
        ],
      ),
    );
  }
}
