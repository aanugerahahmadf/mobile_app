import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/widgets/app_blur_backdrop/app_blur_backdrop.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../data/models/item_model/item_model.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../wishlist/presentation/providers/wishlist_provider/wishlist_provider.dart';
import '../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';

class CombinedCard extends ConsumerStatefulWidget {
  final ItemModel item;

  /// Sumber daya wishlist yang dipakai saat toggle. Katalog kini satu
  /// entitas dan API menggunakan field `catalog_id`.
  final String type;
  final double? similarity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CombinedCard({
    super.key,
    required this.item,
    this.type = 'catalog',
    this.similarity,
    this.onTap,
    this.onLongPress,
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
    // `thumbnail_url` (WebP ~320px) dipakai untuk kartu grid 2 kolom;
    // `image_url` (~1024px) hanya fallback supaya kartu tidak pernah kosong.
    final image = widget.item.thumbnailUrl?.isNotEmpty == true
        ? widget.item.thumbnailUrl!
        : Formatters.imageUrl(widget.item.imageUrl ?? '');

    // ── Data parsing ─────────────────────────────────────────────────────
    final name = widget.item.name;
    // Packages are tiers of a catalog. Never display the catalog base price
    // when tier packages are available; use the cheapest available tier.
    final tier = widget.item.startingTier;
    final originalPrice = (tier?.price ?? widget.item.price).toInt();
    final discountPrice = (tier?.discountPrice ?? widget.item.discountPrice)
        ?.toInt();
    final price = (tier?.effectiveFinalPrice ?? widget.item.displayPrice).toInt();

    // ── Discount calculation ─────────────────────────────────────────────
    final hasDiscount =
        discountPrice != null &&
        discountPrice > 0 &&
        originalPrice > 0 &&
        discountPrice < originalPrice;
    final discountPct = hasDiscount
        ? ((originalPrice - discountPrice) / originalPrice * 100).round()
        : 0;
    final rating = widget.item.averageRating;

    // ── Wishlist / Favorite state ────────────────────────────────────────
    final wishlistItems = ref.watch(wishlistProvider).items;
    final id = widget.item.id;
    final isFavorite =
        wishlistItems.any((w) {
          return w['catalog_id']?.toString() == id.toString();
        }) ||
        widget.item.isWishlisted;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AppBlurBackdrop(
          borderRadius: 2,
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
                      // Kartu grid ~180px logical pada 2 kolom; decode
                      // 2.5x supaya tetap tajam di layar retina tanpa
                      // memuat gambar 1024px penuh ke memory.
                      cacheWidth: 600,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const AppShimmer(height: 150);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceColor,
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.textTertiary,
                            size: 40,
                          ),
                        );
                      },
                    ),
                    // Top gradient overlay
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha(50),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Discount badge
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(4),
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    // Similarity badge
                    if (widget.similarity != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _similarityColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${(widget.similarity! * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    // Favorite button
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          if (ref.read(authProvider) is! AuthAuthenticated) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const GuestAuthPrompt(),
                            );
                            return;
                          }
                          ref
                              .read(wishlistProvider.notifier)
                              .toggle(catalogId: id.toString());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
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
                            color: isFavorite
                                ? AppColors.errorColor
                                : AppColors.textTertiary,
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
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Formatters.currency(price),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (hasDiscount)
                            Text(
                              Formatters.currency(originalPrice),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                      if (rating > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 11,
                              color: AppColors.warningColor.withAlpha(200),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
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
