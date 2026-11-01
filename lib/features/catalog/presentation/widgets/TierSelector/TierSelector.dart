import 'package:flutter/material.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../Data/Models/TierModel/TierModel.dart';

/// Pemilih tier (varian) untuk satu entitas katalog.
///
/// Tier ditampilkan sebagai pill yang bisa di-scroll horizontal; detail
/// tier terpilih (deskripsi, harga, daftar fitur) tampil di bawahnya.
/// Kalau daftar tier kosong, widget ini tidak merender apa pun supaya
/// halaman detail tetap bersih untuk katalog tanpa tier.
class TierSelector extends StatelessWidget {
  final List<TierModel> tiers;
  final TierModel? selected;
  final ValueChanged<TierModel?> onChanged;

  const TierSelector({
    super.key,
    required this.tiers,
    required this.onChanged,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    if (tiers.isEmpty) return const SizedBox.shrink();

    final l = AppLocalizations.of(context)!;
    final active = selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.selectPackage, style: AppTextStyles.titleMedium),
        SizedBox(height: AppSizes.sm),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tiers.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xs + 4),
            itemBuilder: (_, i) {
              final tier = tiers[i];
              return _TierPill(
                tier: tier,
                selected: tier.id == active?.id,
                onTap: () => onChanged(tier),
              );
            },
          ),
        ),
        if (active != null) ...[
          SizedBox(height: AppSizes.md),
          _TierDetail(tier: active),
        ],
      ],
    );
  }
}

class _TierPill extends StatelessWidget {
  final TierModel tier;
  final bool selected;
  final VoidCallback onTap;

  const _TierPill({
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                  ? AppColors.primaryColor.withValues(alpha: 0.15)
                  : AppColors.primaryColor.withValues(alpha: 0.10))
              : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.dividerColor.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          tier.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? (isDark
                    ? AppColors.primaryColor.withValues(alpha: 0.9)
                    : AppColors.primaryColor)
                : (isDark ? AppColors.textSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _TierDetail extends StatelessWidget {
  final TierModel tier;

  const _TierDetail({required this.tier});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final price = tier.effectiveFinalPrice;
    final description = tier.description?.trim() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama tier sebagai heading besar, terpisah dari harga.
          Text(
            tier.name,
            key: const Key('tier_name'),
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: AppSizes.sm),
            Text(
              description,
              key: const Key('tier_description'),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: AppSizes.sm),
          // Harga aktual tier, bukan "starting from".
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(price.toInt()),
                key: const Key('tier_price'),
                style: AppTextStyles.price.copyWith(
                  color: AppColors.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (tier.hasDiscount) ...[
                const SizedBox(width: AppSizes.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    Formatters.currency(tier.price.toInt()),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            '${l.stock}: ${tier.stock}',
            key: const Key('tier_stock'),
            style: AppTextStyles.bodySmall.copyWith(
              color: tier.stock > 0
                  ? AppColors.successColor
                  : AppColors.errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Daftar fitur dengan checkmark, tanpa heading "Package Description".
          if (tier.features != null && tier.features!.isNotEmpty) ...[
            SizedBox(height: AppSizes.md),
            ...tier.features!.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.successColor,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(child: Text(f, style: AppTextStyles.bodySmall)),
                  ],
                ),
              ),
            ),
          ],
          if (tier.stock <= 0) ...[
            SizedBox(height: AppSizes.sm),
            Text(
              l.noPackageAvailable,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
