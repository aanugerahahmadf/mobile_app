import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../chat/presentation/providers/chat_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/catalog_provider.dart';

class CatalogDetailPage extends ConsumerStatefulWidget {
  final String type;
  final String id;
  const CatalogDetailPage({
    super.key,
    required this.type,
    required this.id,
  });

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

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchDetail() async {
    setState(() { _loading = true; _error = null; });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = widget.type == 'packages'
          ? await repo.getPackageDetail(widget.id)
          : await repo.getProductDetail(widget.id);
      _data = res['data'] as Map<String, dynamic>?;
      if (_data == null) throw Exception('Data tidak ditemukan');
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addToCart() async {
    setState(() => _cartLoading = true);
    try {
      final ok = await ref.read(cartProvider.notifier).addItem(
        productId: widget.type == 'products' ? widget.id : null,
        packageId: widget.type == 'packages' ? widget.id : null,
      );
      if (mounted) {
        if (ok) {
          AppSnackBar.show(context, 'Ditambahkan ke keranjang', type: SnackBarType.success);
        } else {
          AppSnackBar.show(context, 'Gagal menambahkan ke keranjang', type: SnackBarType.error);
        }
      }
    } finally {
      if (mounted) setState(() => _cartLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _favLoading = true);
    try {
      await DioClient.instance.post(ApiEndpoints.wishlistToggle, data: {
        if (widget.type == 'packages') 'package_id': widget.id else 'product_id': widget.id,
      });
      if (mounted) AppSnackBar.show(context, 'Berhasil diperbarui', type: SnackBarType.success);
    } catch (e) {
      if (mounted) AppSnackBar.show(context, 'Gagal memperbarui favorit', type: SnackBarType.error);
    }
    if (mounted) setState(() => _favLoading = false);
  }

  Future<void> _messageAdmin() async {
    if (_data == null) return;
    try {
      final media = (_data!['media'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final imageUrl = media.isNotEmpty ? (media[0]['url'] as String? ?? '') : (_data!['image'] as String? ?? '');
      final inboxId = await ref.read(chatProvider.notifier).startConversation(itemContext: {
        'type': widget.type == 'packages' ? 'package' : 'product',
        'item_id': widget.id,
        'item_name': _data!['name'] as String? ?? '',
        'item_price': _data!['price'],
        'item_image': imageUrl,
      });
      if (mounted) {
        context.go('/chat/$inboxId');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, 'Gagal memulai percakapan', type: SnackBarType.error);
      }
    }
  }

  void _buyNow() {
    context.push('/checkout', extra: {'type': widget.type, 'id': widget.id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading
          ? _buildShimmer()
          : _error != null
              ? AppErrorState(message: _error!, onRetry: _fetchDetail)
              : _buildContent(),
      bottomNavigationBar: _loading || _error != null ? null : _buildBottomBar(),
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
    final item = _data!;
    final media = (item['media'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final name = item['name'] as String? ?? '';
    final description = item['description'] as String? ?? '';
    final priceRaw = item['final_price'] ?? item['price'];
    final discountRaw = item['discount_price'];
    final price = priceRaw is num ? priceRaw.toInt() : (priceRaw is String ? (double.tryParse(priceRaw)?.toInt() ?? 0) : 0);
    final discountPrice = discountRaw == null ? null : (discountRaw is num ? discountRaw.toInt() : (discountRaw is String ? double.tryParse(discountRaw)?.toInt() : null));
    final rating = (item['average_rating'] ?? item['rating'] as dynamic) is num ? ((item['average_rating'] ?? item['rating']) as num).toDouble() : null;
    final features = (item['features'] as List?)?.cast<String>() ?? [];
    final reviews = (item['reviews'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (media.isNotEmpty) _buildImageSlider(media),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.headlineMedium),
                SizedBox(height: AppSizes.sm),
                _buildRatingBadge(rating, discountPrice),
                SizedBox(height: AppSizes.sm),
                _buildPriceRow(price, discountPrice),
                SizedBox(height: AppSizes.md),
                const Divider(),
                Text('Deskripsi', style: AppTextStyles.titleMedium),
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
                      _descExpanded ? 'Lebih sedikit' : 'Selengkapnya',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                if (features.isNotEmpty) ...[
                  SizedBox(height: AppSizes.md),
                  const Divider(),
                  Text('Fitur', style: AppTextStyles.titleMedium),
                  SizedBox(height: AppSizes.sm),
                  ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 18, color: AppColors.successColor),
                        SizedBox(width: AppSizes.sm),
                        Text(f, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )),
                ],
                if (reviews.isNotEmpty) ...[
                  SizedBox(height: AppSizes.md),
                  const Divider(),
                  Text('Ulasan', style: AppTextStyles.titleMedium),
                  SizedBox(height: AppSizes.sm),
                  ...reviews.map((r) => _buildReviewCard(r)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(List<Map<String, dynamic>> media) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: media.length,
            itemBuilder: (_, i) {
              final rawSrc = media[i]['url'] as String? ?? media[i]['original_url'] as String? ?? '';
              final imageSrc = Formatters.imageUrl(rawSrc);
              return Image.network(
                imageSrc,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const AppShimmer(height: 300);
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: AppSizes.md, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(media.length, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i ? AppColors.primaryColor : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(num? rating, int? discountPrice) {
    return Row(
      children: [
        if (rating != null) ...[
          const Icon(Icons.star, size: 18, color: AppColors.warningColor),
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1), style: AppTextStyles.bodyMedium),
          SizedBox(width: AppSizes.md),
        ],
        if (discountPrice != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.errorColor, borderRadius: BorderRadius.circular(8)),
            child: Text('Diskon', style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
      ],
    );
  }

  Widget _buildPriceRow(int price, int? discountPrice) {
    return Row(
      children: [
        Text(Formatters.currency(price), style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryColor)),
        if (discountPrice != null) ...[
          SizedBox(width: AppSizes.sm),
          Text(Formatters.currency(discountPrice), style: AppTextStyles.bodySmall.copyWith(decoration: TextDecoration.lineThrough)),
        ],
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> r) {
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: r['avatar'] != null ? CachedNetworkImageProvider(r['avatar'] as String) : null,
                  child: r['avatar'] == null ? Text((r['user_name'] as String? ?? 'U')[0]) : null,
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(child: Text(r['user_name'] as String? ?? '', style: AppTextStyles.bodyMedium)),
                Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < rating ? AppColors.warningColor : Colors.grey[300]))),
              ],
            ),
            if (r['comment'] != null) ...[
              const SizedBox(height: 4),
              Text(r['comment'] as String, style: AppTextStyles.bodySmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: _favLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.favorite_border),
              color: AppColors.errorColor,
              onPressed: _favLoading ? null : _toggleFavorite,
            ),
            IconButton(
              icon: _cartLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.shopping_cart_outlined),
              onPressed: _cartLoading ? null : _addToCart,
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: _messageAdmin,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                label: 'Checkout',
                onPressed: _buyNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
