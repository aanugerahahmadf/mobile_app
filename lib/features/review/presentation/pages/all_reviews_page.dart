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
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/review_photos_grid.dart';
import '../widgets/rating_summary.dart';

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
  final _scrollController = ScrollController();
  final _replyControllers = <int, TextEditingController>{};

  bool get _isAdmin {
    final auth = ref.read(authProvider);
    if (auth is AuthAuthenticated) {
      return auth.user.roles.contains('super_admin') || auth.user.roles.contains('admin');
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _useSeed = widget.packageId.isEmpty && widget.productId.isEmpty && widget.reviews.isNotEmpty;
    if (!_useSeed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(reviewProvider.notifier);
        notifier.resetForItem();
        notifier.fetchItemReviews(
          packageId: widget.packageId,
          productId: widget.productId,
        );
        notifier.fetchRatingSummary(
          packageId: widget.packageId,
          productId: widget.productId,
        );
      });
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final c in _replyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_useSeed) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(reviewProvider.notifier).loadMore(
        packageId: widget.packageId,
        productId: widget.productId,
      );
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

  void _onStarBarTap(int star) {
    final notifier = ref.read(reviewProvider.notifier);
    notifier.setFilterRating(star);
    notifier.fetchItemReviews(packageId: widget.packageId, productId: widget.productId);
    notifier.fetchRatingSummary(packageId: widget.packageId, productId: widget.productId);
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

  Future<void> _refresh() async {
    final notifier = ref.read(reviewProvider.notifier);
    await notifier.fetchItemReviews(
      packageId: widget.packageId,
      productId: widget.productId,
    );
    await notifier.fetchRatingSummary(
      packageId: widget.packageId,
      productId: widget.productId,
    );
  }

  Future<void> _submitReply(int reviewId) async {
    final l = AppLocalizations.of(context)!;
    final controller = _replyControllers[reviewId];
    final text = controller?.text.trim() ?? '';
    if (text.isEmpty) return;

    try {
      await ref.read(reviewProvider.notifier).replyToReview(reviewId, text);
      controller?.clear();
      if (mounted) AppSnackBar.show(context, l.replySent, type: SnackBarType.success);
    } catch (e) {
      if (mounted) AppSnackBar.show(context, l.failed, type: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(reviewProvider);
    final reviews = _useSeed ? widget.reviews : state.reviews;
    final hasTarget = widget.packageId.isNotEmpty || widget.productId.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(hasTarget ? '${state.total} ${l.reviews}' : l.reviews),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (!_useSeed && state.ratingSummary != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.sm),
              child: RatingSummary.fromMap(
                state.ratingSummary!,
                onStarTap: _onStarBarTap,
              ),
            ),
          ],
          if (hasTarget) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: AppButton(
                label: l.writeReview,
                icon: Icons.rate_review_outlined,
                onPressed: _openWriteReview,
                type: ButtonType.outline,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
          ],
          if (!_useSeed) ...[
            _buildFilterBar(l, state),
            const SizedBox(height: AppSizes.sm),
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
                            onRefresh: _refresh,
                            child: ListView.separated(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.md),
                              itemCount: reviews.length + (state.loadingMore ? 1 : 0),
                              separatorBuilder: (_, _) => Divider(
                                height: 1,
                                color: AppColors.dividerColor.withAlpha(100),
                              ),
                              itemBuilder: (context, index) {
                                if (index >= reviews.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(AppSizes.md),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  );
                                }
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

  Widget _buildFilterBar(AppLocalizations l, ReviewState state) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          Expanded(child: _buildRatingTabs(l, state)),
          const SizedBox(width: AppSizes.sm),
          _buildSortMenu(l, state),
        ],
      ),
    );
  }

  Widget _buildRatingTabs(AppLocalizations l, ReviewState state) {
    final tabs = <Map<String, dynamic>>[
      {'label': l.all, 'value': null},
      {'label': '5', 'value': 5},
      {'label': '4', 'value': 4},
      {'label': '3', 'value': 3},
      {'label': '2', 'value': 2},
      {'label': '1', 'value': 1},
      {'label': l.withPhoto, 'value': 'photo'},
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: tabs.length,
      separatorBuilder: (_, _) => const SizedBox(width: 6),
      itemBuilder: (context, index) {
        final tab = tabs[index];
        final isPhoto = tab['value'] == 'photo';
        final isSelected = isPhoto
            ? state.filterWithPhoto
            : state.filterRating == tab['value'];

        return FilterChip(
          label: Text(
            tab['label'] as String,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.primaryColor,
          backgroundColor: AppColors.surfaceColor,
          checkmarkColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onSelected: (selected) {
            if (isPhoto) {
              ref.read(reviewProvider.notifier).setFilterWithPhoto(selected);
            } else {
              ref.read(reviewProvider.notifier).setFilterRating(tab['value'] as int?);
            }
            _refresh();
          },
        );
      },
    );
  }

  Widget _buildSortMenu(AppLocalizations l, ReviewState state) {
    return PopupMenuButton<String>(
      initialValue: state.sort,
      onSelected: (value) {
        ref.read(reviewProvider.notifier).setSort(value);
        _refresh();
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'newest', child: Text(l.sortNewest)),
        PopupMenuItem(value: 'oldest', child: Text(l.sortOldest)),
        PopupMenuItem(value: 'highest', child: Text(l.sortHighest)),
        PopupMenuItem(value: 'lowest', child: Text(l.sortLowest)),
        PopupMenuItem(value: 'most_helpful', child: Text(l.sortMostHelpful)),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(l.sort, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(AppLocalizations l, Map<String, dynamic> r, {VoidCallback? onTap}) {
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    final userName = _userName(r);
    final avatar = _avatar(r);
    final title = r['title'] as String? ?? '';
    final comment = r['comment'] as String? ?? '';
    final time = r['created_at'] as String? ?? '';
    final reviewPhotos = reviewPhotoUrls(r);
    final isVoted = r['is_voted'] as bool? ?? false;
    final helpfulCount = (r['helpful_count'] as num?)?.toInt() ?? 0;
    final replies = (r['replies'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final reviewId = (r['id'] as num?)?.toInt();
    final replyController = reviewId != null
        ? _replyControllers.putIfAbsent(reviewId, () => TextEditingController())
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: InkWell(
        onTap: onTap,
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
                      Text(userName, style: AppTextStyles.bodyMedium),
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
            if (replies.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              ...replies.map((reply) => _buildReplyCard(l, reply)),
            ],
            const SizedBox(height: AppSizes.xs),
            Row(
              children: [
                Text(Formatters.timeAgo(time), style: AppTextStyles.labelSmall),
                const Spacer(),
                _buildHelpfulButton(l, r, isVoted, helpfulCount),
              ],
            ),
            if (_isAdmin && reviewId != null) ...[
              const SizedBox(height: AppSizes.sm),
              _buildReplyInput(l, reviewId, replyController!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReplyCard(AppLocalizations l, Map<String, dynamic> reply) {
    final userName = reply['user'] is Map
        ? (reply['user']['full_name'] as String?) ?? 'Admin'
        : 'Admin';
    final comment = reply['comment'] as String? ?? '';
    final time = reply['created_at'] as String? ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSizes.xs),
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield, size: 14, color: AppColors.primaryColor),
              const SizedBox(width: 4),
              Text(userName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
              if (time.isNotEmpty) ...[
                const Spacer(),
                Text(Formatters.timeAgo(time), style: AppTextStyles.labelSmall),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(comment, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildReplyInput(AppLocalizations l, int reviewId, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: l.writeReply,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              style: AppTextStyles.bodySmall,
              maxLines: null,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, size: 18, color: AppColors.primaryColor),
            onPressed: () => _submitReply(reviewId),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpfulButton(AppLocalizations l, Map<String, dynamic> r, bool isVoted, int helpfulCount) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        final reviewId = (r['id'] as num?)?.toInt();
        if (reviewId != null) {
          ref.read(reviewProvider.notifier).voteHelpful(reviewId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVoted ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: 16,
              color: isVoted ? AppColors.primaryColor : AppColors.textTertiary,
            ),
            if (helpfulCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '$helpfulCount',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isVoted ? AppColors.primaryColor : AppColors.textTertiary,
                ),
              ),
            ],
            const SizedBox(width: 4),
            Text(
              l.helpful,
              style: AppTextStyles.bodySmall.copyWith(
                color: isVoted ? AppColors.primaryColor : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
