import 'package:flutter/material.dart';
import '../../Constants/AppColors/AppColors.dart';
import '../AppGlass3DCard/AppGlass3DCard.dart';
import '../../Constants/AppTextStyles/AppTextStyles.dart';
import '../AppShimmer/AppShimmer.dart';

class AppCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String? badge;
  final double? rating;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const AppCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.badge,
    this.rating,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlass3DCard(
      borderRadius: 16,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const AppShimmer(height: 150);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.shimmerBase,
                        child: Icon(Icons.broken_image, color: AppColors.textTertiary),
                      );
                    },
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.errorColor : Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(price, style: AppTextStyles.priceSmall),
                if (rating != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 12, color: AppColors.warningColor),
                      const SizedBox(width: 3),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: AppTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
