import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../providers/review_provider.dart';
import '../widgets/review_photos_grid.dart';

class UserReviewsPage extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const UserReviewsPage({
    super.key,
    required this.userId,
    this.userName = '',
  });

  @override
  ConsumerState<UserReviewsPage> createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends ConsumerState<UserReviewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewProvider.notifier).fetchUserReviews(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(reviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName.isNotEmpty ? widget.userName : l.reviews),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(LocalizedError.of(l, state.error!), style: AppTextStyles.bodyMedium))
              : state.reviews.isEmpty
                  ? AppEmptyState(
                      title: l.noReviews,
                      subtitle: l.beFirstReview,
                      icon: Icons.star_outline,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(reviewProvider.notifier).fetchUserReviews(widget.userId),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSizes.md),
                        itemCount: state.reviews.length,
                        itemBuilder: (context, index) {
                          return _buildReviewCard(l, state.reviews[index]);
                        },
                      ),
                    ),
    );
  }

  Widget _buildReviewCard(AppLocalizations l, Map<String, dynamic> r) {
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    final flatName = r['user_name'] as String?;
    final user = r['user'] as Map<String, dynamic>?;
    final userName = (flatName != null && flatName.isNotEmpty)
        ? flatName
        : ((user?['full_name'] as String?) ?? 'Pengguna');
    final comment = r['comment'] as String? ?? '';
    final time = r['created_at'] as String? ?? '';
    final flatAvatar = r['avatar'] as String?;
    final avatar = (flatAvatar != null && flatAvatar.isNotEmpty)
        ? flatAvatar
        : (user?['avatar_url'] as String?);
    final itemName = _itemName(r);
    final reviewPhotos = reviewPhotoUrls(r);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
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
                          userName[0].toUpperCase(),
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
            if (itemName.isNotEmpty) ...[
              const SizedBox(height: AppSizes.xs),
              Text(itemName, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryColor)),
            ],
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
    );
  }

  String _itemName(Map<String, dynamic> r) {
    final package = r['package'] as Map<String, dynamic>?;
    if (package != null && package['name'] != null) {
      return package['name'] as String;
    }
    final product = r['product'] as Map<String, dynamic>?;
    if (product != null && product['name'] != null) {
      return product['name'] as String;
    }
    return '';
  }
}
