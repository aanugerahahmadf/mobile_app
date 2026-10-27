import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../data/models/tier_model/tier_model.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryColor : AppColors.dividerColor,
          ),
        ),
        child: Text(
          tier.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.textSecondary,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Text(tier.name, style: AppTextStyles.titleSmall)),
              Text(
                Formatters.currency(price.toInt()),
                style: AppTextStyles.price.copyWith(
                  color: AppColors.primaryTextColor,
                ),
              ),
              if (tier.hasDiscount) ...[
                const SizedBox(width: AppSizes.sm),
                Text(
                  Formatters.currency(tier.price.toInt()),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            l.startingFrom,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: AppSizes.sm),
            Text(
              description,
              key: const Key('tier_description'),
              style: AppTextStyles.bodyMedium,
            ),
          ],
          if (tier.features != null && tier.features!.isNotEmpty) ...[
            SizedBox(height: AppSizes.md),
            Text(l.packageDescription, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.xs),
            ...tier.features!.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.successColor,
                    ),
                    SizedBox(width: AppSizes.sm),
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
