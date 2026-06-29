import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/utils/formatters.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

class ProductCard extends ConsumerWidget {
  final Map<String, dynamic> item;
  final String type;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.item, required this.type, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Image URL resolution ─────────────────────────────────────────────
    final media = item['media'] as List? ?? [];
    final String rawImage;
    if (media.isNotEmpty && media[0] is Map) {
      final m = media[0] as Map;
      rawImage = (m['url'] as String? ?? '').isNotEmpty
          ? m['url'] as String
          : (m['original_url'] as String? ?? '');
    } else {
      rawImage = item['image_url'] as String? ?? item['image'] as String? ?? '';
    }
    final image = Formatters.imageUrl(rawImage);

    // ── Data parsing ─────────────────────────────────────────────────────
    final name = item['name'] as String? ?? '';
    final priceRaw = item['final_price'] ?? item['price'];
    final discountRaw = item['discount_price'];
    final originalPriceRaw = item['price'];

    final price = priceRaw is num
        ? priceRaw.toInt()
        : (priceRaw is String ? (double.tryParse(priceRaw)?.toInt() ?? 0) : 0);
    final discountPrice = discountRaw == null
        ? null
        : (discountRaw is num
            ? discountRaw.toInt()
            : (discountRaw is String ? double.tryParse(discountRaw)?.toInt() : null));
    final originalPrice = originalPriceRaw == null
        ? price
        : (originalPriceRaw is num
            ? originalPriceRaw.toInt()
            : (originalPriceRaw is String ? double.tryParse(originalPriceRaw)?.toInt() ?? price : price));
    final rating = (item['average_rating'] ?? item['rating'] as dynamic) is num
        ? ((item['average_rating'] ?? item['rating']) as num).toDouble()
        : null;

    // ── Discount calculation ─────────────────────────────────────────────
    // If discountPrice exists and is less than originalPrice, calculate % off
    final hasDiscount = discountPrice != null && originalPrice > 0 && discountPrice < originalPrice;
    final discountPct = hasDiscount
        ? ((originalPrice - discountPrice) / originalPrice * 100).round()
        : 0;

    // ── Wishlist / Favorite state ────────────────────────────────────────
    final wishlistItems = ref.watch(wishlistProvider).items;
    final id = item['id'];
    final isFavorite = wishlistItems.any((w) {
      if (type == 'packages') {
        return w['package_id']?.toString() == id?.toString();
      } else {
        return w['product_id']?.toString() == id?.toString();
      }
    }) || (item['is_wishlisted'] as bool? ?? false);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image section (larger flex = taller image) ───────────────
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product image
                  Image.network(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const AppShimmer(height: 150);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 36),
                      );
                    },
                  ),
                  // Top gradient overlay
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withAlpha(50), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  // Discount badge — only shown when real discount exists
                  if (hasDiscount)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.errorColor.withAlpha(70),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '-$discountPct%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  // Favorite button
                  Positioned(
                    bottom: 8, right: 8,
                    child: GestureDetector(
                      onTap: () {
                        if (type == 'packages') {
                          ref.read(wishlistProvider.notifier).toggle(packageId: id?.toString());
                        } else {
                          ref.read(wishlistProvider.notifier).toggle(productId: id?.toString());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppColors.errorColor : AppColors.textTertiary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Text info section ────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name
                    Text(
                      name,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Price row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Formatters.currency(price),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hasDiscount) ...[
                          Text(
                            Formatters.currency(originalPrice),
                            style: AppTextStyles.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 9,
                              color: AppColors.textTertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (rating != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 11, color: AppColors.warningColor),
                              const SizedBox(width: 2),
                              Text(
                                rating.toStringAsFixed(1),
                                style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
