import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../providers/voucher_provider.dart';
import '../../data/models/voucher_model.dart';
import '../../../../core/utils/formatters.dart';

class VoucherListPage extends ConsumerStatefulWidget {
  const VoucherListPage({super.key});

  @override
  ConsumerState<VoucherListPage> createState() => _VoucherListPageState();
}

class _VoucherListPageState extends ConsumerState<VoucherListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(voucherProvider.notifier).fetchVouchers());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(voucherProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.myVouchers)),
      body: state.loading
          ? ListView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: 4,
              itemBuilder: (_, _) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.md),
                child: AppShimmer(height: 140, borderRadius: AppSizes.cardRadius),
              ),
            )
          : state.error != null
              ? Center(child: Text(state.error!, style: AppTextStyles.bodyMedium))
              : state.vouchers.isEmpty
                  ? AppEmptyState(
                      icon: Icons.card_giftcard_outlined,
                      title: l.noVouchers,
                      subtitle: l.voucherEmpty,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(voucherProvider.notifier).fetchVouchers(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSizes.md),
                        itemCount: state.vouchers.length,
                        itemBuilder: (_, i) => _buildVoucherCard(state.vouchers[i], l),
                      ),
                    ),
    );
  }

  Widget _buildVoucherCard(VoucherModel voucher, AppLocalizations l) {
    final name = voucher.code;
    final desc = voucher.description ?? '';
    final discount = voucher.discountAmount.toInt();
    final isExpired = voucher.isExpired;

    final discountLabel = voucher.isPercentage
        ? '$discount% OFF'
        : Formatters.currency(discount);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        gradient: isExpired
            ? null
            : AppColors.primaryGradient,
        color: isExpired ? AppColors.secondaryColor : null,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: (isExpired ? Colors.black : AppColors.primaryColor).withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTextStyles.titleMedium.copyWith(
                          color: isExpired ? AppColors.textSecondary : Colors.white,
                          fontWeight: FontWeight.w600,
                        )),
                        const SizedBox(height: 4),
                        Text(desc, style: AppTextStyles.bodySmall.copyWith(
                          color: isExpired ? AppColors.textTertiary : AppColors.surfaceColor.withAlpha(179),
                        )),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (discount > 0) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceColor.withAlpha(51),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(discountLabel, style: AppTextStyles.labelSmall.copyWith(
                                  color: isExpired ? AppColors.textSecondary : Colors.white,
                                  fontWeight: FontWeight.w600,
                                )),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                name,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: isExpired ? AppColors.textTertiary : Colors.white60,
                                  letterSpacing: 1.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isExpired
                    ? Theme.of(context).colorScheme.surface.withAlpha(40)
                    : Colors.white.withAlpha(25),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.cardRadius),
                  bottomRight: Radius.circular(AppSizes.cardRadius),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isExpired ? null : () => context.push('/vouchers/${voucher.id}', extra: voucher.toJson()),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.cardRadius),
                    bottomRight: Radius.circular(AppSizes.cardRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      l.viewDetail,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isExpired ? AppColors.textTertiary : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
