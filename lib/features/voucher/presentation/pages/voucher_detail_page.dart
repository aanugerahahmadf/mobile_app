import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/voucher_provider.dart';
import '../../data/models/voucher_model.dart';

class VoucherDetailPage extends ConsumerWidget {
  final VoucherModel voucher;
  const VoucherDetailPage({super.key, required this.voucher});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final title = (voucher.name != null && voucher.name!.isNotEmpty) ? voucher.name! : 'Voucher';
    final isExpired = voucher.isExpired;
    final isClaimed = voucher.isClaimed;

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF57C00), Color(0xFFFF9800)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.discount_rounded, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  if (isClaimed && voucher.code != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(voucher.code!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: voucher.code!));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.copied)));
                          },
                          child: const Icon(Icons.copy, color: Colors.white70, size: 22),
                        ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '**** **** **** ****',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 3),
                      ),
                    ),
                  ],
                  if (voucher.description != null) ...[
                    const SizedBox(height: 6),
                    Text(voucher.description!,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  children: [
                    _infoRow(Icons.local_offer, l.discount, voucher.isPercentage
                        ? '${voucher.discountAmount}%'
                        : Formatters.currency(voucher.discountAmount.toInt())),
                    const Divider(),
                    _infoRow(Icons.shopping_bag, l.minPurchase, Formatters.currency(voucher.minPurchase.toInt())),
                    const Divider(),
                    _infoRow(Icons.access_time, l.validUntil, voucher.expiresAt ?? '-'),
                    if (voucher.maxUses != null) ...[
                      const Divider(),
                      _infoRow(Icons.repeat, l.tryAgain, '${voucher.maxUses}'),
                    ],
                    const Divider(),
                    _infoRow(Icons.info_outline, l.tryAgain, voucher.isActive ? l.active : l.inactive),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              label: isExpired ? l.expired : (isClaimed ? l.use : l.claim),
              onPressed: (isExpired || isClaimed) ? null : () => _claimVoucher(context, ref),
              type: ButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _claimVoucher(BuildContext context, WidgetRef ref) async {
    final sl = AppLocalizations.of(context)!;
    final success = await ref.read(voucherProvider.notifier).claimVoucher(voucher.id.toString());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? sl.voucherClaimed : sl.failedUseVoucher),
        backgroundColor: success ? AppColors.successColor : AppColors.errorColor,
      ));
      if (success) context.pop();
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Flexible(
            child: Text(value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
