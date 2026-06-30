import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/item_model.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

class CombinedCard extends ConsumerStatefulWidget {
  final ItemModel item;
  final String type;
  final double? similarity;
  final VoidCallback? onTap;

  const CombinedCard({
    super.key,
    required this.item,
    required this.type,
    this.similarity,
    this.onTap,
  });

  @override
  ConsumerState<CombinedCard> createState() => _CombinedCardState();
}

class _CombinedCardState extends ConsumerState<CombinedCard> {
  bool _isPressed = false;

  Color get _similarityColor {
    final val = widget.similarity ?? 0.0;
    if (val >= 0.8) return AppColors.successColor;
    if (val >= 0.6) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  @override
  Widget build(BuildContext context) {
    // ── Image URL resolution ─────────────────────────────────────────────
    final media = widget.item.media ?? [];
    // media[0]['url'] is already normalized by ItemModel.fromJson via Formatters.imageUrl()
    // Fallback chain: media url -> imageUrl field -> empty string
    final image = media.isNotEmpty && media[0] is Map
        ? (media[0]['url'] as String? ?? '').isNotEmpty
            ? (media[0]['url'] as String)
            : Formatters.imageUrl(widget.item.imageUrl ?? '')
        : Formatters.imageUrl(widget.item.imageUrl ?? '');

    // ── Data parsing ─────────────────────────────────────────────────────
    final name = widget.item.name;
    final originalPrice = widget.item.price.toInt();       // harga asli sebelum diskon
    final discountPrice = widget.item.discountPrice?.toInt(); // harga setelah diskon (null jika tidak ada)
    final price = widget.item.finalPrice.toInt();           // harga final yang ditampilkan
    
    // ── Discount calculation ─────────────────────────────────────────────
    final hasDiscount = discountPrice != null && originalPrice > 0 && discountPrice < originalPrice;
    final discountPct = hasDiscount
        ? ((originalPrice - discountPrice) / originalPrice * 100).round()
        : 0;
    final rating = widget.item.averageRating;

    // ── Wishlist / Favorite state ────────────────────────────────────────
    final wishlistItems = ref.watch(wishlistProvider).items;
    final id = widget.item.id;
    final isFavorite = wishlistItems.any((w) {
      if (widget.type == 'packages') {
        return w['package_id']?.toString() == id.toString();
      } else {
        return w['product_id']?.toString() == id.toString();
      }
    }) || widget.item.isWishlisted;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image section (larger flex = taller image) ───────────────
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
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
                          color: const Color(0xFFF5F5F5),
                          child: const Icon(Icons.image_outlined, color: Color(0xFFD0D0D0), size: 40),
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
                    // Discount badge
                    if (hasDiscount)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(6),
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
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    // Similarity badge
                    if (widget.similarity != null)
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _similarityColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${(widget.similarity! * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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
                          if (widget.type == 'packages') {
                            ref.read(wishlistProvider.notifier).toggle(packageId: id.toString());
                          } else {
                            ref.read(wishlistProvider.notifier).toggle(productId: id.toString());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
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
                      // Name
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Price and rating row/column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.currency(price),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (hasDiscount) ...[
                            Text(
                              Formatters.currency(originalPrice),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (rating > 0) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 13, color: AppColors.warningColor.withAlpha(200)),
                                const SizedBox(width: 2),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
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
      ),
    );
  }
}
