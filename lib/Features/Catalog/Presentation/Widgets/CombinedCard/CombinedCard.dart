import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Widgets/AppShimmer/AppShimmer.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../Data/Models/ItemModel/ItemModel.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../Favorite/Presentation/Providers/FavoriteProvider/FavoriteProvider.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';

class CombinedCard extends ConsumerStatefulWidget {
  final ItemModel item;
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

class _CombinedCardState extends ConsumerState<CombinedCard>
    with SingleTickerProviderStateMixin {
  // ── 3D tilt state ───────────────────────────────────────────────────────
  double _rotX = 0.0;
  double _rotY = 0.0;
  double _scale = 1.0;
  Offset _glare = Offset.zero;
  late final AnimationController _springCtrl;
  late Animation<double> _springRotX, _springRotY, _springScale;

  static const double _maxTilt = 0.14; // ~8 degrees

  @override
  void initState() {
    super.initState();
    _springCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _initSpringAnims(0, 0, 1);
    _springCtrl.addListener(() {
      setState(() {
        _rotX = _springRotX.value;
        _rotY = _springRotY.value;
        _scale = _springScale.value;
        _glare = Offset(-_rotY / _maxTilt, -_rotX / _maxTilt);
      });
    });
  }

  void _initSpringAnims(double rx, double ry, double sc) {
    _springRotX = Tween<double>(
      begin: rx,
      end: 0,
    ).animate(CurvedAnimation(parent: _springCtrl, curve: Curves.easeOutCubic));
    _springRotY = Tween<double>(
      begin: ry,
      end: 0,
    ).animate(CurvedAnimation(parent: _springCtrl, curve: Curves.easeOutCubic));
    _springScale = Tween<double>(
      begin: sc,
      end: 1,
    ).animate(CurvedAnimation(parent: _springCtrl, curve: Curves.easeOutCubic));
  }

  void _tilt(Offset local, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final dx = ((local.dx - size.width / 2) / (size.width / 2)).clamp(
      -1.0,
      1.0,
    );
    final dy = ((local.dy - size.height / 2) / (size.height / 2)).clamp(
      -1.0,
      1.0,
    );
    setState(() {
      _rotX = -dy * _maxTilt;
      _rotY = dx * _maxTilt;
      _scale = 0.96;
      _glare = Offset(dx, dy);
    });
  }

  void _resetTilt() {
    _initSpringAnims(_rotX, _rotY, _scale);
    _springCtrl.forward(from: 0);
  }

  @override
  void dispose() {
    _springCtrl.dispose();
    super.dispose();
  }

  Color get _similarityColor {
    final val = widget.similarity ?? 0.0;
    if (val >= 0.8) return AppColors.successColor;
    if (val >= 0.6) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Image URL ──────────────────────────────────────────────────────────
    final image = widget.item.thumbnailUrl?.isNotEmpty == true
        ? widget.item.thumbnailUrl!
        : Formatters.imageUrl(widget.item.imageUrl ?? '');

    // ── Data ───────────────────────────────────────────────────────────────
    final name = widget.item.name;
    final tier = widget.item.startingTier;
    final originalPrice = tier?.price.toInt() ?? 0;
    final discountPrice = tier?.discountPrice?.toInt();
    final price = tier?.effectiveFinalPrice.toInt();
    final hasDiscount =
        discountPrice != null &&
        discountPrice > 0 &&
        originalPrice > 0 &&
        discountPrice < originalPrice;
    final discountPct = hasDiscount
        ? ((originalPrice - discountPrice) / originalPrice * 100).round()
        : 0;
    final rating = widget.item.averageRating;

    // ── Favorite ───────────────────────────────────────────────────────────
    final favoriteItems = ref.watch(favoriteProvider).items;
    final id = widget.item.id;
    final isFavorite =
        favoriteItems.any(
          (w) => w['catalog_id']?.toString() == id.toString(),
        ) ||
        widget.item.isFavoriteed;

    // ── Glass Colors & Sheen ───────────────────────────────────────────────
    final glassColor = isDark
        ? const Color(0x401E293B)
        : const Color(0xA8FFFFFF);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.70);
    final glassGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              Colors.white.withValues(alpha: 0.10),
              Colors.white.withValues(alpha: 0.02),
            ]
          : [
              Colors.white.withValues(alpha: 0.75),
              Colors.white.withValues(alpha: 0.35),
            ],
    );

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0014)
          ..scaleByDouble(_scale, _scale, 1.0, 1.0)
          ..rotateX(_rotX)
          ..rotateY(_rotY);

        return Listener(
          onPointerDown: (e) {
            _springCtrl.stop();
            HapticFeedback.selectionClick();
            _tilt(e.localPosition, size);
          },
          onPointerMove: (e) => _tilt(e.localPosition, size),
          onPointerUp: (_) => _resetTilt(),
          onPointerCancel: (_) => _resetTilt(),
          child: GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.45)
                          : const Color(0xFF1E3A5F).withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    if (isDark)
                      BoxShadow(
                        color: const Color(0xFFC9A94E).withValues(alpha: 0.08),
                        blurRadius: 16,
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: glassColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1.2),
                        gradient: glassGradient,
                      ),
                      child: Stack(
                        children: [
                          // Card content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Image ────────────────────────────────────
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        image,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        cacheWidth: 600,
                                        loadingBuilder: (ctx, child, prog) {
                                          if (prog == null) return child;
                                          return const AppShimmer(height: 150);
                                        },
                                        errorBuilder:
                                            (
                                              ctx,
                                              error,
                                              stackTrace,
                                            ) => Container(
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? const Color(0xFF1E293B)
                                                    : const Color(0xFFEEF2FF),
                                              ),
                                              child: Icon(
                                                Icons.local_florist_outlined,
                                                color: AppColors.textTertiary,
                                                size: 36,
                                              ),
                                            ),
                                      ),
                                    ),
                                    // Top gradient scrim
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 52,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withValues(
                                                alpha: 0.28,
                                              ),
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
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 6,
                                              sigmaY: 6,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.errorColor
                                                    .withValues(alpha: 0.85),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '-$discountPct%',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
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
                                            horizontal: 7,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _similarityColor.withValues(
                                              alpha: 0.90,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            '${(widget.similarity! * 100).toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    // Favorite button – glass circle
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (ref.read(authProvider)
                                              is! AuthAuthenticated) {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (_) =>
                                                  const GuestAuthPrompt(),
                                            );
                                            return;
                                          }
                                          ref
                                              .read(favoriteProvider.notifier)
                                              .toggle(catalogId: id.toString());
                                        },
                                        child: ClipOval(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10,
                                              sigmaY: 10,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.white.withValues(
                                                        alpha: 0.18,
                                                      )
                                                    : Colors.white.withValues(
                                                        alpha: 0.75,
                                                      ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                              child: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite
                                                    ? AppColors.errorColor
                                                    : (isDark
                                                          ? Colors.white70
                                                          : AppColors
                                                                .textTertiary),
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ── Text info ────────────────────────────────
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    9,
                                    5,
                                    9,
                                    5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            price == null
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.choosePackage
                                                : Formatters.currency(price),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryTextColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.stock}: ${widget.item.stock}',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w500,
                                              color: widget.item.stock > 0
                                                  ? AppColors.successColor
                                                  : AppColors.errorColor,
                                            ),
                                          ),
                                          if (hasDiscount)
                                            Text(
                                              Formatters.currency(
                                                originalPrice,
                                              ),
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: AppColors.textTertiary,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                      if (rating > 0)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              size: 11,
                                              color: AppColors.warningColor,
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

                          // ── Specular 3D glare overlay ─────────────────────
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: RadialGradient(
                                    center: Alignment(_glare.dx, _glare.dy),
                                    radius: 1.0,
                                    colors: [
                                      (isDark
                                              ? const Color(0xFFC9A94E)
                                              : Colors.white)
                                          .withValues(
                                            alpha: isDark ? 0.12 : 0.28,
                                          ),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
