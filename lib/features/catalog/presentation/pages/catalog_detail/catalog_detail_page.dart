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
import '../../../../review/presentation/widgets/review_photos_grid/review_photos_grid.dart';
import '../../providers/catalog_provider.dart';

class CatalogDetailPage extends ConsumerStatefulWidget {
  final String type;
  final String id;
  const CatalogDetailPage({super.key, required this.type, required this.id});

  @override
  ConsumerState<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends ConsumerState<CatalogDetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _descExpanded = false;
  bool _loading = true;
  bool _cartLoading = false;
  bool _favLoading = false;
  String? _error;
  Map<String, dynamic>? _data;
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
    super.dispose();
  }

  Future<void> _fetchDetail() async {
    final dataNotFoundMsg = AppLocalizations.of(context)!.dataNotFound;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = widget.type == 'packages'
          ? await repo.getPackageDetail(widget.id)
          : await repo.getProductDetail(widget.id);
      _data = res['data'] as Map<String, dynamic>?;
      if (_data == null) throw Exception(dataNotFoundMsg);
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
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
            productId: widget.type == 'products' ? widget.id : null,
            packageId: widget.type == 'packages' ? widget.id : null,
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
          if (widget.type == 'packages')
            'package_id': widget.id
          else
            'product_id': widget.id,
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
            'type': widget.type == 'packages' ? 'package' : 'product',
            'item_id': widget.id,
            'item_name': _data!['name'] as String? ?? '',
            'item_price': _data!['price'],
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
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(),
      );
      return;
    }
    context.push('/checkout', extra: {'type': widget.type, 'id': widget.id});
  }

  void _shareItem() {
    final name = _data?['name'] as String? ?? '';
    final price = _data?['final_price'] ?? _data?['price'] ?? '';
    final link =
        'https://wedding-organizer.app/detail/${widget.type}/${widget.id}';
    Share.share(
      '$name\n${Formatters.currency(price is num ? price.toInt() : 0)}\n$link',
    );
  }

  void _reportItem() {
    if (_data == null) return;
    final l = AppLocalizations.of(context)!;
    final name = _data?['name'] as String? ?? '';
    final isPackage =
        widget.type == 'packages' || (_data?['type'] as String?) == 'package';
    final imageUrl = Formatters.itemMediaUrls(_data).firstOrNull ?? '';
    openReportChat(
      context,
      ref,
      category: isPackage ? 'package' : 'product',
      itemName: name,
      details: isPackage ? l.packageLabel : l.productLabel,
      itemContext: {
        'type': isPackage ? 'package' : 'product',
        'item_id': widget.id,
        'name': name,
        'price': _data!['price'],
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

  Widget _buildContent() {
    final l = AppLocalizations.of(context)!;
    final item = _data!;
    final imageUrls = Formatters.itemMediaUrls(item);
    final name = item['name'] as String? ?? '';
    final description = item['description'] as String? ?? '';
    final priceRaw = item['final_price'] ?? item['price'];
    final discountRaw = item['discount_price'];
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
          if (imageUrls.isNotEmpty) _buildImageSlider(imageUrls),
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
                if (reviews.isNotEmpty) ...[
                  SizedBox(height: AppSizes.md),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.reviews, style: AppTextStyles.titleMedium),
                      InkWell(
                        onTap: _openAllReviews,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            '${reviews.length}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.sm),
                  ...reviews.map(
                    (r) =>
                        _buildReviewCard(r, onTap: () => _openUserReviews(r)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: imageUrls.length,
                itemBuilder: (_, i) {
                  return Image.network(
                    imageUrls[i],
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                    '${_currentPage + 1}/${imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (imageUrls.length > 1)
                Positioned(
                  bottom: AppSizes.md,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imageUrls.length,
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
        if (imageUrls.length > 1) ...[
          const SizedBox(height: AppSizes.sm),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              itemCount: imageUrls.length,
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
                        imageUrls[i],
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
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
    final isPackage = widget.type == 'packages' || item['type'] == 'package';
    context.push(
      '/item-reviews',
      extra: {
        'title': item['name'] as String? ?? '',
        'package_id': isPackage ? widget.id : '',
        'product_id': isPackage ? '' : widget.id,
        'reviews':
            (item['reviews'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      },
    );
  }

  void _openUserReviews(Map<String, dynamic> r) {
    final userId = r['user_id']?.toString();
    if (userId == null || userId.isEmpty) {
      _openAllReviews();
      return;
    }
    context.push(
      '/user-reviews',
      extra: {'user_id': userId, 'user_name': _reviewUserName(r)},
    );
  }

  String _reviewUserName(Map<String, dynamic> r) {
    final flat = r['user_name'] as String?;
    if (flat != null && flat.isNotEmpty) return flat;
    final user = r['user'] as Map<String, dynamic>?;
    return (user?['full_name'] as String?) ?? '';
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
