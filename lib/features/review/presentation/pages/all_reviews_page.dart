import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../providers/review_provider.dart';
import '../widgets/review_photos_grid.dart';

class AllReviewsPage extends ConsumerStatefulWidget {
  final String packageId;
  final String productId;
  final String title;
  final List<Map<String, dynamic>> reviews;

  const AllReviewsPage({
    super.key,
    this.packageId = '',
    this.productId = '',
    this.title = '',
    this.reviews = const [],
  });

  @override
  ConsumerState<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends ConsumerState<AllReviewsPage> {
  bool _useSeed = false;

  @override
  void initState() {
    super.initState();
    _useSeed = widget.packageId.isEmpty && widget.productId.isEmpty && widget.reviews.isNotEmpty;
    if (!_useSeed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(reviewProvider.notifier)
            .fetchItemReviews(packageId: widget.packageId, productId: widget.productId);
      });
    }
  }

  void _openUserReviews(Map<String, dynamic> r) {
    final userId = r['user_id']?.toString();
    if (userId == null || userId.isEmpty) return;
    context.push('/user-reviews', extra: {
      'user_id': userId,
      'user_name': _userName(r),
    });
  }

  void _openWriteReview() {
    context.push('/write-review', extra: {
      'package_id': widget.packageId,
      'product_id': widget.productId,
      'name': widget.title,
    });
  }

  String _userName(Map<String, dynamic> r) {
    final flat = r['user_name'] as String?;
    if (flat != null && flat.isNotEmpty) return flat;
    final user = r['user'] as Map<String, dynamic>?;
    return (user?['full_name'] as String?) ?? 'Pengguna';
  }

  String? _avatar(Map<String, dynamic> r) {
    final flat = r['avatar'] as String?;
    if (flat != null && flat.isNotEmpty) return flat;
    final user = r['user'] as Map<String, dynamic>?;
    return (user?['avatar_url'] as String?) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(reviewProvider);
    final reviews = _useSeed ? widget.reviews : state.reviews;
    final hasTarget = widget.packageId.isNotEmpty || widget.productId.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.reviews),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (hasTarget) ...[
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: AppButton(
                label: l.writeReview,
                icon: Icons.rate_review_outlined,
                onPressed: _openWriteReview,
                type: ButtonType.outline,
              ),
            ),
          ],
          Expanded(
            child: !_useSeed && state.loading
                ? const Center(child: CircularProgressIndicator())
                : !_useSeed && state.error != null
                    ? Center(child: Text(LocalizedError.of(l, state.error!), style: AppTextStyles.bodyMedium))
                    : reviews.isEmpty
                        ? AppEmptyState(
                            title: l.noReviews,
                            subtitle: l.beFirstReview,
                            icon: Icons.star_outline,
                          )
                        : RefreshIndicator(
                            onRefresh: _useSeed
                                ? () async {}
                                : () => ref.read(reviewProvider.notifier)
                                    .fetchItemReviews(packageId: widget.packageId, productId: widget.productId),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.md),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final r = reviews[index];
                                return _buildReviewCard(l, r, onTap: () => _openUserReviews(r));
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(AppLocalizations l, Map<String, dynamic> r, {VoidCallback? onTap}) {
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    final userName = _userName(r);
    final avatar = _avatar(r);
    final comment = r['comment'] as String? ?? '';
    final time = r['created_at'] as String? ?? '';
    final reviewPhotos = reviewPhotoUrls(r);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondaryColor,
                    backgroundImage: avatar != null && avatar.isNotEmpty
                        ? CachedNetworkImageProvider(avatar)
                        : null,
                    child: avatar == null || avatar.isEmpty
                        ? Text(
                            userName.isEmpty ? 'U' : userName[0].toUpperCase(),
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor),
                          )
                        : null,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(child: Text(userName, style: AppTextStyles.bodyMedium)),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 14,
                        color: i < rating ? AppColors.warningColor : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              if (comment.isNotEmpty) ...[
                const SizedBox(height: AppSizes.sm),
                Text(comment, style: AppTextStyles.bodySmall),
              ],
              if (reviewPhotos.isNotEmpty) ...[
                const SizedBox(height: AppSizes.sm),
                ReviewPhotosGrid(urls: reviewPhotos),
              ],
              const SizedBox(height: AppSizes.xs),
              Text(Formatters.timeAgo(time), style: AppTextStyles.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
