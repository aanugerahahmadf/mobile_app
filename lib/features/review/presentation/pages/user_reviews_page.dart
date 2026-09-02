import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../data/review_repository_impl.dart';
import '../widgets/review_photos_grid.dart';

class UserReviewsPage extends StatefulWidget {
  final String userId;
  final String userName;

  const UserReviewsPage({
    super.key,
    required this.userId,
    this.userName = '',
  });

  @override
  State<UserReviewsPage> createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage> {
  final _repository = ReviewRepositoryImpl();
  List<Map<String, dynamic>> _reviews = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final reviews = await _repository.getUserReviews(widget.userId);
      if (mounted) setState(() { _reviews = reviews; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName.isNotEmpty ? widget.userName : l.reviews),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? AppErrorState(
                  message: LocalizedError.of(l, _error!),
                  onRetry: _fetch,
                )
              : _reviews.isEmpty
                  ? AppEmptyState(
                      title: l.noReviews,
                      subtitle: l.beFirstReview,
                      icon: Icons.star_outline,
                    )
                  : RefreshIndicator(
                      onRefresh: _fetch,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppSizes.md),
                        itemCount: _reviews.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: AppColors.dividerColor.withAlpha(100),
                        ),
                        itemBuilder: (context, index) => _buildReviewCard(l, _reviews[index]),
                      ),
                    ),
    );
  }

  Widget _buildReviewCard(AppLocalizations l, Map<String, dynamic> r) {
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    final title = r['title'] as String? ?? '';
    final comment = r['comment'] as String? ?? '';
    final time = r['created_at'] as String? ?? '';
    final flatName = r['user_name'] as String?;
    final user = r['user'] as Map<String, dynamic>?;
    final userName = (flatName != null && flatName.isNotEmpty)
        ? flatName
        : ((user?['full_name'] as String?) ?? '');
    final flatAvatar = r['avatar'] as String?;
    final avatar = (flatAvatar != null && flatAvatar.isNotEmpty)
        ? flatAvatar
        : (user?['avatar_url'] as String?);
    final itemName = _itemName(r);
    final reviewPhotos = reviewPhotoUrls(r);
    final helpfulCount = (r['helpful_count'] as num?)?.toInt() ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userName.isNotEmpty) Text(userName, style: AppTextStyles.bodyMedium),
                    Row(
                      children: List.generate(5, (i) {
                        if (i < rating) {
                          return Icon(Icons.star, size: 14, color: AppColors.warningColor);
                        }
                        return Icon(Icons.star_border, size: 14, color: AppColors.warningColor);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (itemName.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xs),
            Text(itemName, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryColor)),
          ],
          if (title.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xs),
            Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
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
          Row(
            children: [
              Text(Formatters.timeAgo(time), style: AppTextStyles.labelSmall),
              const Spacer(),
              if (helpfulCount > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.thumb_up, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '$helpfulCount',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
            ],
          ),
        ],
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
