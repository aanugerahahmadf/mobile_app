import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../../core/widgets/app_error_state/app_error_state.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../chat/presentation/providers/chat_provider.dart';
import '../../../../chat/presentation/utils/cs_chat_launcher/cs_chat_launcher.dart';
import '../../../../chat/presentation/utils/cs_guest_chat/cs_guest_chat.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../cart/presentation/providers/cart_provider/cart_provider.dart';
import '../../../../review/presentation/providers/review_provider/review_provider.dart';
import '../../../../review/presentation/widgets/review_photos_grid/review_photos_grid.dart';
import '../../../data/models/tier_model/tier_model.dart';
import '../../widgets/tier_selector/tier_selector.dart';
import '../../providers/catalog_provider.dart';

class CatalogDetailPage extends ConsumerStatefulWidget {
  final String id;
  const CatalogDetailPage({super.key, required this.id});

  @override
  ConsumerState<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends ConsumerState<CatalogDetailPage> {
  final PageController _pageController = PageController();
  final TextEditingController _reviewController = TextEditingController();
  int _currentPage = 0;
  bool _descExpanded = false;
  bool _loading = true;
  bool _cartLoading = false;
  bool _favLoading = false;
  bool _reviewSubmitting = false;
  int _reviewRating = 5;
  String? _error;
  Map<String, dynamic>? _data;
  TierModel? _selectedTier;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _fetchDetail();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  /// Tier/varian dari entitas katalog ini. Backend menyertakan `tiers`
  /// pada respons detail `/api/catalog/{id}`.
  List<TierModel> get _tiers {
    final raw = _data?['tiers'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(TierModel.fromJson)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Katalog ini pada dasarnya paket (bukan katalog)? Backend tidak
  /// mengirim field `type` pada entitas katalog, jadi kita andalkan
  /// `resource_type` untuk membedakan paket dari katalog.
  bool get _isPackageItem {
    final data = _data;
    if (data == null) return false;
    return data['type'] == 'package' || data['resource_type'] == 'package';
  }

  Future<void> _fetchDetail() async {
    final dataNotFoundMsg = AppLocalizations.of(context)!.dataNotFound;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = await repo.getCatalogDetail(widget.id);
      _data = res['data'] as Map<String, dynamic>?;
      if (_data == null) throw Exception(dataNotFoundMsg);
      // Default tier = tier pertama (yg sort_order terkecil).
      final tiers = _tiers;
      _selectedTier = tiers.isNotEmpty ? tiers.first : null;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  void _selectTier(TierModel? tier) {
    setState(() => _selectedTier = tier);
  }

  Future<void> _addToCart() async {
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(),
      );
      return;
    }
    final l = AppLocalizations.of(context)!;
    setState(() => _cartLoading = true);
    try {
      final ok = await ref
          .read(cartProvider.notifier)
           .addItem(
            // Catalog is the parent product; the selected package tier is a
            // real packages row and must travel as package_id. Never send a
            // tier id as catalog_id: that silently points at another catalog.
            catalogId: widget.id,
            packageId: _selectedTier?.id.toString(),
          );
      if (mounted) {
        if (ok) {
          AppSnackBar.show(context, l.addedSuccess, type: SnackBarType.success);
        } else {
          AppSnackBar.show(context, l.addFailed, type: SnackBarType.error);
        }
      }
    } finally {
      if (mounted) setState(() => _cartLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(),
      );
      return;
    }
    final l = AppLocalizations.of(context)!;
    setState(() => _favLoading = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.wishlistToggle,
        data: {
          'catalog_id': widget.id,
        },
      );
      if (mounted) {
        AppSnackBar.show(context, l.updatedSuccess, type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, l.updateFailed, type: SnackBarType.error);
      }
    }
    if (mounted) setState(() => _favLoading = false);
  }

  Future<void> _messageAdmin() async {
    final l = AppLocalizations.of(context)!;
    if (_data == null) return;
    final auth = ref.read(authProvider);
    final notifier = ref.read(chatProvider.notifier);
    try {
      final imageUrl = Formatters.itemMediaUrls(_data).firstOrNull ?? '';
      int inboxId;
      if (auth is AuthAuthenticated) {
        inboxId = await notifier.startConversation(
          itemContext: {
            'type': 'catalog',
            'item_id': widget.id,
            'item_name': _data!['name'] as String? ?? '',
            'item_price': _selectedTier?.effectiveFinalPrice ?? _data!['price'],
            'item_image': imageUrl,
          },
        );
      } else {
        final guestId = await getOrCreateGuestId();
        inboxId = await notifier.startGuestConversation(guestId: guestId);
        if (mounted) {
          context.push('/chat/$inboxId', extra: {'guestId': guestId});
        }
        return;
      }
      if (mounted) {
        context.push('/chat/$inboxId');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, l.failed, type: SnackBarType.error);
      }
    }
  }

  void _buyNow() {
    final l = AppLocalizations.of(context)!;
    if (_tiers.isNotEmpty && _selectedTier == null) {
      AppSnackBar.show(
        context,
        l.choosePackageFirst,
        type: SnackBarType.warning,
      );
      return;
    }
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(),
      );
      return;
    }
    context.push(
      '/checkout',
      extra: {
        'type': _isPackageItem ? 'packages' : 'catalogs',
        'id': widget.id,
        'tier_id': _selectedTier?.id,
      },
    );
  }

  void _shareItem() {
    final name = _data?['name'] as String? ?? '';
    final price = _selectedTier?.effectiveFinalPrice ??
        _data?['final_price'] ??
        _data?['finalPrice'] ??
        0;
    final link = 'https://weddingflowerdecorations.app/catalog/${widget.id}';
    Share.share(
      '$name\n${Formatters.currency(price is num ? price.toInt() : 0)}\n$link',
    );
  }

  void _reportItem() {
    if (_data == null) return;
    final l = AppLocalizations.of(context)!;
    final name = _data?['name'] as String? ?? '';
    final isPackage = _isPackageItem;
    final imageUrl = Formatters.itemMediaUrls(_data).firstOrNull ?? '';
    openReportChat(
      context,
      ref,
      category: isPackage ? 'package' : 'catalog',
      itemName: name,
      details: isPackage ? l.packageLabel : l.catalogLabel,
      itemContext: {
        'type': isPackage ? 'package' : 'catalog',
        'item_id': widget.id,
        'name': name,
        'price': _selectedTier?.effectiveFinalPrice ?? _data!['price'],
        'image': imageUrl,
      },
    );
  }

  void _reportReview(Map<String, dynamic> r) {
    openReportChat(
      context,
      ref,
      category: 'review',
      itemName: _reviewUserName(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareItem),
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: l.report,
            onPressed: _reportItem,
          ),
        ],
      ),
      body: _loading
          ? _buildShimmer()
          : _error != null
          ? AppErrorState(
              message: LocalizedError.of(l, _error!),
              onRetry: _fetchDetail,
            )
          : _buildContent(),
      bottomNavigationBar: _loading || _error != null
          ? null
          : _buildBottomBar(),
    );
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmer(height: 300),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmer(height: 24, width: 200),
                SizedBox(height: AppSizes.sm),
                const AppShimmer(height: 20, width: 100),
                SizedBox(height: AppSizes.md),
                const AppShimmer(height: 16),
                SizedBox(height: AppSizes.sm),
                const AppShimmer(height: 16),
                SizedBox(height: AppSizes.sm),
                const AppShimmer(height: 16, width: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Foto galeri dari `gallery_urls` (backend sudah mengirim varian `url`
  /// ~1024px dan `thumb` ~320px). Fallback ke `Formatters.itemMediaUrls`
  /// supaya respons lama tanpa `gallery_urls` tetap tampil.
  List<Map<String, dynamic>> get _gallery {
    final raw = _data?['gallery_urls'];
    if (raw is List && raw.isNotEmpty) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return Formatters.itemMediaUrls(
      _data,
    ).map((u) => <String, dynamic>{'url': u, 'thumb': u}).toList();
  }

  Widget _buildContent() {
    final l = AppLocalizations.of(context)!;
    final item = _data!;
    final gallery = _gallery;
    final name = item['name'] as String? ?? '';
    final description = item['description'] as String? ?? '';
    // Harga mengikuti tier terpilih; tanpa tier memakai harga katalog.
    final tier = _selectedTier;
    final priceRaw = tier != null
        ? tier.effectiveFinalPrice
        : (item['final_price'] ?? item['finalPrice'] ?? item['price']);
    final discountRaw = tier?.hasDiscount == true
        ? tier!.discountPrice
        : (item['discount_price'] ?? item['discountPrice']);
    final price = priceRaw is num
        ? priceRaw.toInt()
        : (priceRaw is String ? (double.tryParse(priceRaw)?.toInt() ?? 0) : 0);
    final discountPrice = discountRaw == null
        ? null
        : (discountRaw is num
              ? discountRaw.toInt()
              : (discountRaw is String
                    ? double.tryParse(discountRaw)?.toInt()
                    : null));
    final rating = (item['average_rating'] ?? item['rating'] as dynamic) is num
        ? ((item['average_rating'] ?? item['rating']) as num).toDouble()
        : null;
    final features = (item['features'] as List?)?.cast<String>() ?? [];
    final reviews =
        (item['reviews'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (gallery.isNotEmpty) _buildImageSlider(gallery),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.headlineMedium),
                SizedBox(height: AppSizes.xs),
                _buildRatingBadge(rating, discountPrice),
                SizedBox(height: AppSizes.sm),
                _buildPriceRow(price, discountPrice),
                SizedBox(height: AppSizes.md),
                const Divider(),
                Text(l.description, style: AppTextStyles.titleMedium),
                SizedBox(height: AppSizes.sm),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium,
                  maxLines: _descExpanded ? null : 3,
                  overflow: _descExpanded ? null : TextOverflow.ellipsis,
                ),
                if (description.length > 150)
                  GestureDetector(
                    onTap: () => setState(() => _descExpanded = !_descExpanded),
                    child: Text(
                      _descExpanded ? l.showLess : l.showMore,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                if (features.isNotEmpty) ...[
                  SizedBox(height: AppSizes.md),
                  const Divider(),
                  Text('Fitur', style: AppTextStyles.titleMedium),
                  SizedBox(height: AppSizes.sm),
                  ...features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 18,
                            color: AppColors.successColor,
                          ),
                          SizedBox(width: AppSizes.sm),
                          Text(f, style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: AppSizes.md),
                const Divider(),
                _buildInlineReviewComposer(),
                SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Text(l.reviews, style: AppTextStyles.titleMedium),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _openWriteReview,
                      icon: const Icon(Icons.rate_review_outlined, size: 18),
                      label: Text(l.writeReview),
                    ),
                    if (reviews.isNotEmpty)
                      TextButton(
                        onPressed: _openAllReviews,
                        child: Text('${reviews.length}'),
                      ),
                  ],
                ),
                if (reviews.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xs),
                    child: Text(
                      l.beFirstReview,
                      style: AppTextStyles.bodySmall,
                    ),
                  )
                else ...[
                  SizedBox(height: AppSizes.sm),
                  ...reviews.map(
                    (r) =>
                        _buildReviewCard(r, onTap: () => _openUserReviews(r)),
                  ),
                ],
                // Selector tier diletakkan paling akhir, tepat di atas baris
                // tombol aksi (Order now / Add to Cart / Chat / Favorites).
                if (_tiers.isNotEmpty) ...[
                  SizedBox(height: AppSizes.md),
                  const Divider(),
                  TierSelector(
                    tiers: _tiers,
                    selected: _selectedTier,
                    onChanged: _selectTier,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(List<Map<String, dynamic>> gallery) {
    // Hero 300px tinggi full-lebar -> decode ~1080px, bukan gambar asli.
    const heroCacheWidth = 1080;
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: gallery.length,
                itemBuilder: (_, i) {
                  return Image.network(
                    '${gallery[i]['url'] ?? ''}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: heroCacheWidth,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const AppShimmer(height: 300);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.dividerColor,
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.textTertiary,
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentPage + 1}/${gallery.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (gallery.length > 1)
                Positioned(
                  bottom: AppSizes.md,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      gallery.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.primaryColor
                              : Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (gallery.length > 1) ...[
          const SizedBox(height: AppSizes.sm),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              itemCount: gallery.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  setState(() => _currentPage = i);
                  _pageController.jumpToPage(i);
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        // Strip thumbnail memakai varian `thumb` (~320px WebP),
                        // bukan gambar penuh.
                        '${gallery[i]['thumb'] ?? gallery[i]['url'] ?? ''}',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        cacheWidth: 160,
                        errorBuilder: (_, _, _) => Container(
                          width: 64,
                          height: 64,
                          color: AppColors.dividerColor,
                          child: Icon(
                            Icons.broken_image,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    if (_currentPage == i)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingBadge(num? rating, int? discountPrice) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        if (rating != null) ...[
          const Icon(Icons.star, size: 18, color: AppColors.warningColor),
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1), style: AppTextStyles.bodyMedium),
          SizedBox(width: AppSizes.md),
        ],
        if (discountPrice != null && discountPrice > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.errorColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l.discount,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRow(int price, int? discountPrice) {
    return Row(
      children: [
        Text(
          Formatters.currency(price),
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryTextColor,
          ),
        ),
        if (discountPrice != null && discountPrice > 0) ...[
          SizedBox(width: AppSizes.sm),
          Text(
            Formatters.currency(discountPrice),
            style: AppTextStyles.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  void _openAllReviews() {
    final item = _data;
    if (item == null) return;
    final isPackage = _isPackageItem;
    context.push(
      '/item-reviews',
      extra: {
        'title': item['name'] as String? ?? '',
        'package_id': isPackage ? widget.id : '',
        'catalog_id': isPackage ? '' : widget.id,
        'reviews':
            (item['reviews'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      },
    );
  }

  Future<void> _openWriteReview() async {
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(icon: Icons.rate_review_outlined),
      );
      return;
    }

    final item = _data;
    if (item == null) return;
    final isPackage = _isPackageItem;
    final submitted = await context.push<bool>(
      '/write-review',
      extra: {
        'package_id': isPackage ? widget.id : '',
        'catalog_id': isPackage ? '' : widget.id,
        'name': item['name'] as String? ?? '',
      },
    );
    if (submitted == true && mounted) await _fetchDetail();
  }

  Future<void> _submitInlineReview() async {
    if (_reviewSubmitting) return;
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(icon: Icons.rate_review_outlined),
      );
      return;
    }

    final l = AppLocalizations.of(context)!;
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) {
      AppSnackBar.show(context, l.writeYourReview, type: SnackBarType.warning);
      return;
    }

    final item = _data;
    if (item == null) return;
    final isPackage = _isPackageItem;
    setState(() => _reviewSubmitting = true);
    try {
      await ref.read(reviewProvider.notifier).createReview({
        if (isPackage) 'package_id': widget.id else 'catalog_id': widget.id,
        'rating': _reviewRating,
        'comment': comment,
      });
      if (!mounted) return;
      _reviewController.clear();
      AppSnackBar.show(context, l.reviewSubmitted, type: SnackBarType.success);
      await _fetchDetail();
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          '${l.reviewFailed}: ${LocalizedError.of(l, e.toString())}',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _reviewSubmitting = false);
    }
  }

  Widget _buildInlineReviewComposer() {
    final l = AppLocalizations.of(context)!;
    final signedIn = ref.watch(authProvider) is AuthAuthenticated;
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.writeReview, style: AppTextStyles.titleSmall),
          SizedBox(height: AppSizes.xs),
          Row(
            children: List.generate(
              5,
              (index) => IconButton(
                tooltip: '${index + 1}',
                visualDensity: VisualDensity.compact,
                onPressed: signedIn
                    ? () => setState(() => _reviewRating = index + 1)
                    : _submitInlineReview,
                icon: Icon(
                  index < _reviewRating ? Icons.star : Icons.star_border,
                  color: AppColors.warningColor,
                ),
              ),
            ),
          ),
          TextField(
            controller: _reviewController,
            minLines: 2,
            maxLines: 4,
            enabled: signedIn && !_reviewSubmitting,
            decoration: InputDecoration(
              hintText: signedIn ? l.writeYourReview : l.writeReview,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: l.submitReview,
              loading: _reviewSubmitting,
              onPressed: _submitInlineReview,
              type: ButtonType.primary,
              width: 150,
              height: 42,
            ),
          ),
        ],
      ),
    );
  }

  void _openUserReviews(Map<String, dynamic> r) {
    final userId = _reviewUserId(r);
    if (userId == null || userId.isEmpty) {
      _openAllReviews();
      return;
    }
    context.push(
      '/user-reviews',
      extra: {'user_id': userId, 'user_name': _reviewUserName(r)},
    );
  }

  String? _reviewUserId(Map<String, dynamic> r) {
    final directId = (r['user_id'] ?? r['reviewer_id'])?.toString();
    if (directId != null && directId.isNotEmpty) return directId;
    final user = r['user'];
    if (user is Map<String, dynamic>) {
      final nestedId = (user['id'] ?? user['uuid'])?.toString();
      if (nestedId != null && nestedId.isNotEmpty) return nestedId;
    }
    return null;
  }

  String _reviewUserName(Map<String, dynamic> r) {
    final flat = r['user_name'] as String?;
    if (flat != null && flat.isNotEmpty) return flat;
    final user = r['user'] as Map<String, dynamic>?;
    return (user?['full_name'] ?? user?['name'] ?? '') as String;
  }

  String? _reviewAvatar(Map<String, dynamic> r) {
    final flat = r['avatar'] as String?;
    if (flat != null && flat.isNotEmpty) return flat;
    final user = r['user'] as Map<String, dynamic>?;
    return (user?['avatar_url'] as String?) ?? '';
  }

  Widget _buildReviewCard(Map<String, dynamic> r, {VoidCallback? onTap}) {
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    final userName = _reviewUserName(r);
    final avatar = _reviewAvatar(r);
    final reviewPhotos = reviewPhotoUrls(r);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: avatar != null && avatar.isNotEmpty
                        ? CachedNetworkImageProvider(avatar)
                        : null,
                    child: avatar == null || avatar.isEmpty
                        ? Text((userName.isEmpty ? 'U' : userName)[0])
                        : null,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(userName, style: AppTextStyles.bodyMedium),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 14,
                        color: i < rating
                            ? AppColors.warningColor
                            : AppColors.dividerColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.flag_outlined,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    tooltip: AppLocalizations.of(context)!.report,
                    onPressed: () => _reportReview(r),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              if (r['comment'] != null) ...[
                const SizedBox(height: 4),
                Text(r['comment'] as String, style: AppTextStyles.bodySmall),
              ],
              if (reviewPhotos.isNotEmpty) ...[
                const SizedBox(height: 6),
                ReviewPhotosGrid(urls: reviewPhotos, itemHeight: 140),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: _favLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.favorite_border),
              color: AppColors.errorColor,
              onPressed: _favLoading ? null : _toggleFavorite,
            ),
            IconButton(
              icon: _cartLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.shopping_cart_outlined),
              onPressed: _cartLoading ? null : _addToCart,
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: _messageAdmin,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(label: l.checkout, onPressed: _buyNow),
            ),
          ],
        ),
      ),
    );
  }
}
