import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../core/widgets/app_empty_state/app_empty_state.dart';
import '../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../core/widgets/app_action_sheet/app_action_sheet.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../providers/review_provider/review_provider.dart';
import '../../widgets/review_photos_grid/review_photos_grid.dart';
import '../../widgets/rating_summary/rating_summary.dart';

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
  bool _navigationBusy = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _useSeed =
        widget.packageId.isEmpty &&
        widget.productId.isEmpty &&
        widget.reviews.isNotEmpty;
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
    super.dispose();
  }

  void _onScroll() {
    if (_useSeed) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(reviewProvider.notifier)
          .loadMore(packageId: widget.packageId, productId: widget.productId);
    }
  }

  Future<void> _openUserReviews(Map<String, dynamic> r) async {
    final userId = r['user_id']?.toString();
    if (userId == null || userId.isEmpty || _navigationBusy || !mounted) return;
    _navigationBusy = true;
    try {
      await context.push(
        '/user-reviews',
        extra: {'user_id': userId, 'user_name': _userName(r)},
      );
    } finally {
      _navigationBusy = false;
    }
  }

  Future<void> _openWriteReview() async {
    if (_navigationBusy || !mounted) return;
    if (ref.read(authProvider) is! AuthAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const GuestAuthPrompt(),
      );
      return;
    }
    _navigationBusy = true;
    try {
      await context.push(
        '/write-review',
        extra: {
          'package_id': widget.packageId,
          'product_id': widget.productId,
          'name': widget.title,
        },
      );
    } finally {
      _navigationBusy = false;
    }
  }

  void _onStarBarTap(int star) {
    final notifier = ref.read(reviewProvider.notifier);
    notifier.setFilterRating(star);
    notifier.fetchItemReviews(
      packageId: widget.packageId,
      productId: widget.productId,
    );
    notifier.fetchRatingSummary(
      packageId: widget.packageId,
      productId: widget.productId,
    );
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(reviewProvider);
    final reviews = _useSeed ? widget.reviews : state.reviews;
    final hasTarget =
        widget.packageId.isNotEmpty || widget.productId.isNotEmpty;

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
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                0,
                AppSizes.md,
                AppSizes.sm,
              ),
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
                ? Center(
                    child: Text(
                      LocalizedError.of(l, state.error!),
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
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
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.md,
                        0,
                        AppSizes.md,
                        AppSizes.md,
                      ),
                      itemCount: reviews.length + (state.loadingMore ? 1 : 0),
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: AppColors.dividerColor.withAlpha(100),
                      ),
                      itemBuilder: (context, index) {
                        if (index >= reviews.length) {
                          return const Padding(
                            padding: EdgeInsets.all(AppSizes.md),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        final r = reviews[index];
                        return _buildReviewCard(
                          l,
                          r,
                          onTap: () => _openUserReviews(r),
                        );
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
              ref
                  .read(reviewProvider.notifier)
                  .setFilterRating(tab['value'] as int?);
            }
            _refresh();
          },
        );
      },
    );
  }

  Widget _buildSortMenu(AppLocalizations l, ReviewState state) {
    return GestureDetector(
      onTap: () async {
        final value = await showAppActionSheet<String>(
          context,
          title: l.sort,
          actions: [
            AppSheetAction(value: 'newest', label: l.sortNewest),
            AppSheetAction(value: 'oldest', label: l.sortOldest),
            AppSheetAction(value: 'highest', label: l.sortHighest),
            AppSheetAction(value: 'lowest', label: l.sortLowest),
            AppSheetAction(value: 'most_helpful', label: l.sortMostHelpful),
          ],
        );
        if (value != null) {
          ref.read(reviewProvider.notifier).setSort(value);
          _refresh();
        }
      },
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

  Widget _buildReviewCard(
    AppLocalizations l,
    Map<String, dynamic> r, {
    VoidCallback? onTap,
  }) {
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
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryColor,
                          ),
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
                            return Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warningColor,
                            );
                          }
                          return Icon(
                            Icons.star_border,
                            size: 14,
                            color: AppColors.warningColor,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: AppSizes.xs),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
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
              Text(
                userName,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
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

  Widget _buildHelpfulButton(
    AppLocalizations l,
    Map<String, dynamic> r,
    bool isVoted,
    int helpfulCount,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (ref.read(authProvider) is! AuthAuthenticated) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const GuestAuthPrompt(),
          );
          return;
        }
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
                  color: isVoted
                      ? AppColors.primaryColor
                      : AppColors.textTertiary,
                ),
              ),
            ],
            const SizedBox(width: 4),
            Text(
              l.helpful,
              style: AppTextStyles.bodySmall.copyWith(
                color: isVoted
                    ? AppColors.primaryColor
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
