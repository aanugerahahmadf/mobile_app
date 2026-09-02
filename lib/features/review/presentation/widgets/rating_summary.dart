import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class RatingSummary extends StatelessWidget {
  final double average;
  final int total;
  final int withPhotoCount;
  final List<Map<String, dynamic>> distribution;
  final ValueChanged<int>? onStarTap;

  const RatingSummary({
    super.key,
    required this.average,
    required this.total,
    required this.distribution,
    this.withPhotoCount = 0,
    this.onStarTap,
  });

  factory RatingSummary.fromMap(Map<String, dynamic> data, {ValueChanged<int>? onStarTap}) {
    return RatingSummary(
      average: (data['average'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toInt() ?? 0,
      withPhotoCount: (data['with_photo_count'] as num?)?.toInt() ?? 0,
      distribution: (data['distribution'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      onStarTap: onStarTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAverageScore(l),
          const SizedBox(width: AppSizes.lg),
          Expanded(child: _buildBars(l)),
        ],
      ),
    );
  }

  Widget _buildAverageScore(AppLocalizations l) {
    return Column(
      children: [
        Text(
          average.toStringAsFixed(1),
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.warningColor,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            if (i < average.floor()) {
              return Icon(Icons.star, size: 14, color: AppColors.warningColor);
            } else if (i < average) {
              return Icon(Icons.star_half, size: 14, color: AppColors.warningColor);
            }
            return Icon(Icons.star_border, size: 14, color: AppColors.warningColor);
          }),
        ),
        const SizedBox(height: 2),
        Text(
          '$total ${l.reviews.toLowerCase()}',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildBars(AppLocalizations l) {
    if (distribution.isEmpty) return const SizedBox.shrink();
    return Column(
      children: distribution.map((d) {
        final star = d['star'] as int;
        final count = d['count'] as int;
        final pct = (d['percentage'] as num?)?.toDouble() ?? 0;
        final isTappable = onStarTap != null;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: InkWell(
            onTap: isTappable ? () => onStarTap!(star) : null,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    child: Text(
                      '$star',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isTappable ? AppColors.primaryColor : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 12, color: AppColors.warningColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.dividerColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isTappable ? AppColors.primaryColor : AppColors.warningColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$count (${pct.round()}%)',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
