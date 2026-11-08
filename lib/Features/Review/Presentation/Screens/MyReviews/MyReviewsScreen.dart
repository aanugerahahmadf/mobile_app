import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Widgets/AppShimmer/AppShimmer.dart';
import '../../../../../Core/Widgets/AppEmptyState/AppEmptyState.dart';
import '../../../../../Core/Widgets/AppErrorState/AppErrorState.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import '../../../../../Core/Widgets/AppActionSheet/AppActionSheet.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../../Core/Widgets/MediaViewer/MediaViewer.dart';
import '../../../Data/Models/MyReviewModel/MyReviewModel.dart';
import '../../Providers/MyReviewsProvider/MyReviewsProvider.dart';
import '../../Widgets/CatalogRatingComments/CatalogRatingCommentsView.dart';
import '../../Widgets/ReviewPhotosGrid/ReviewPhotosGrid.dart';
import '../../Widgets/RatingSummary/RatingSummary.dart';

class MyReviewsScreen extends ConsumerStatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends ConsumerState<MyReviewsScreen> {
  bool _navigationBusy = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider) is AuthAuthenticated) {
      Future.microtask(
        () => ref.read(myReviewsProvider.notifier).fetchMyReviews(),
      );
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      ref.read(myReviewsProvider.notifier).loadMore();
    }
  }

  Future<void> _refresh() async {
    await ref.read(myReviewsProvider.notifier).fetchMyReviews(refresh: true);
  }

  Future<void> _deleteReview(MyReviewModel review) async {
    final l = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.delete),
        content: Text(l.deleteReviewConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l.delete,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await ref.read(myReviewsProvider.notifier).deleteReview(review.id);
      if (mounted) {
        AppSnackBar.show(context, l.reviewDeleted, type: SnackBarType.success);
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          l.failedDeleteReview,
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _editReview(MyReviewModel review) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditReviewSheet(
        review: review,
        onSave: (data, photoPaths, {removedPhotoUrls}) => ref
            .read(myReviewsProvider.notifier)
            .updateReview(
              review.id,
              data,
              photoPaths: photoPaths,
              removedPhotoUrls: removedPhotoUrls,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.myCatalogRatingComments),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(38),
            child: AppBreadcrumbs.global(),
          ),
        ),
        body: const GuestAuthPrompt(icon: Icons.rate_review_outlined),
      );
    }

    final state = ref.watch(myReviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.myCatalogRatingComments),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(38),
          child: AppBreadcrumbs.global(),
        ),
        actions: [
          IconButton(
            tooltip: l.writeRatingComment,
            icon: const Icon(Icons.rate_review_outlined),
            onPressed: _openOrders,
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.reviews.isEmpty
          ? AppErrorState(
              message: LocalizedError.of(l, state.error!),
              onRetry: () =>
                  ref.read(myReviewsProvider.notifier).fetchMyReviews(),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(l, state)),
                  if (state.reviews.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _isFilteredView(state)
                          ? AppEmptyState(
                              icon: Icons.filter_alt_off_outlined,
                              title: l.noResults,
                              actionLabel: l.clearAll,
                              onAction: _clearFilters,
                            )
                          : AppEmptyState(
                              icon: Icons.star_border,
                              title: l.noReviews,
                              subtitle: l.noReviewsYet,
                            ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.md,
                        0,
                        AppSizes.md,
                        AppSizes.md,
                      ),
                      sliver: SliverList.builder(
                        itemCount:
                            state.reviews.length + (state.loadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.reviews.length) {
                            return const Padding(
                              padding: EdgeInsets.all(AppSizes.md),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          return _buildReviewCard(l, state.reviews[index]);
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  bool _isFilteredView(MyReviewsState state) {
    return state.filterRating != null ||
        state.filterWithPhoto ||
        state.filterWithComment;
  }

  void _clearFilters() {
    final notifier = ref.read(myReviewsProvider.notifier)
      ..setFilterRating(null)
      ..setFilterWithPhoto(false)
      ..setFilterWithComment(false);
    notifier.fetchMyReviews(refresh: true);
  }

  Widget _buildHeader(AppLocalizations l, MyReviewsState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        0,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingSummary(
            average: state.summary.average,
            total: state.summary.total,
            withPhotoCount: state.summary.withMediaCount,
            distribution: state.summary.distribution
                .map(
                  (d) => {
                    'star': d.star,
                    'count': d.count,
                    'percentage': d.percentage,
                  },
                )
                .toList(),
            onStarTap: (star) {
              final notifier = ref.read(myReviewsProvider.notifier);
              notifier.setFilterRating(
                state.filterRating == star ? null : star,
              );
              notifier.fetchMyReviews();
            },
          ),
          const SizedBox(height: AppSizes.sm),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(child: _buildFilterChips(l, state)),
                const SizedBox(width: AppSizes.sm),
                _buildSortMenu(l, state),
              ],
            ),
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Text(
                LocalizedError.of(l, state.error!),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.errorColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Sama seperti section katalog: chip membawa jumlah dan chip bernilai nol
  /// tidak ditampilkan.
  Widget _buildFilterChips(AppLocalizations l, MyReviewsState state) {
    final summary = state.summary;
    final countsByStar = {
      for (final d in summary.distribution) d.star: d.count,
    };

    final filters = <({String label, bool selected, VoidCallback onTap})>[
      (
        label: '${l.all} (${summary.total})',
        selected:
            state.filterRating == null &&
            !state.filterWithPhoto &&
            !state.filterWithComment,
        onTap: _clearFilters,
      ),
      for (var star = 5; star >= 1; star--)
        if ((countsByStar[star] ?? 0) > 0)
          (
            label: '$star ★ (${countsByStar[star]})',
            selected: state.filterRating == star,
            onTap: () {
              final notifier = ref.read(myReviewsProvider.notifier);
              notifier.setFilterRating(
                state.filterRating == star ? null : star,
              );
              notifier.fetchMyReviews();
            },
          ),
      if (summary.withMediaCount > 0)
        (
          label: '${l.withPhoto} (${summary.withMediaCount})',
          selected: state.filterWithPhoto,
          onTap: () {
            final notifier = ref.read(myReviewsProvider.notifier);
            notifier.setFilterWithPhoto(!state.filterWithPhoto);
            notifier.fetchMyReviews();
          },
        ),
      if (summary.withCommentCount > 0)
        (
          label: '${l.withComment} (${summary.withCommentCount})',
          selected: state.filterWithComment,
          onTap: () {
            final notifier = ref.read(myReviewsProvider.notifier);
            notifier.setFilterWithComment(!state.filterWithComment);
            notifier.fetchMyReviews();
          },
        ),
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: filters.length,
      separatorBuilder: (_, _) => const SizedBox(width: 6),
      itemBuilder: (context, index) {
        final filter = filters[index];
        return FilterChip(
          label: Text(
            filter.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: filter.selected ? Colors.white : AppColors.textPrimary,
              fontWeight: filter.selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          selected: filter.selected,
          selectedColor: AppColors.primaryColor,
          backgroundColor: AppColors.surfaceColor,
          checkmarkColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onSelected: (_) => filter.onTap(),
        );
      },
    );
  }

  Widget _buildSortMenu(AppLocalizations l, MyReviewsState state) {
    final options = <(String, String)>[
      ('newest', l.sortNewest),
      ('oldest', l.sortOldest),
      ('highest', l.sortHighest),
      ('lowest', l.sortLowest),
      ('most_helpful', l.sortMostHelpful),
    ];
    final activeLabel = options
        .firstWhere(
          (o) => o.$1 == state.sort,
          orElse: () => ('newest', l.sortNewest),
        )
        .$2;

    return GestureDetector(
      onTap: () async {
        final value = await showAppActionSheet<String>(
          context,
          title: l.sort,
          actions: [
            for (final o in options) AppSheetAction(value: o.$1, label: o.$2),
          ],
        );
        if (value != null) {
          final notifier = ref.read(myReviewsProvider.notifier);
          notifier.setSort(value);
          notifier.fetchMyReviews();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                activeLabel,
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(AppLocalizations l, MyReviewModel review) {
    final image = Formatters.imageUrl(review.displayItemImage);
    final busy = ref.watch(myReviewsProvider).submitting;
    final sellerReply = review.sellerReply;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openItemReviews(review),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: image,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                const AppShimmer(width: 72, height: 72),
                            errorWidget: (_, _, _) => Container(
                              width: 72,
                              height: 72,
                              color: AppColors.secondaryColor,
                              child: const Icon(Icons.broken_image, size: 32),
                            ),
                          )
                        : Container(
                            width: 72,
                            height: 72,
                            color: AppColors.secondaryColor,
                            child: const Icon(Icons.inventory_2, size: 32),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.displayItemName.isEmpty
                              ? l.reviews
                              : review.displayItemName,
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: AppColors.warningColor,
                              ),
                            ),
                            if (review.isVerifiedPurchase) ...[
                              const SizedBox(width: 6),
                              _badge(
                                l.verifiedPurchase,
                                AppColors.successColor,
                              ),
                            ],
                            if (review.isAnonymous) ...[
                              const SizedBox(width: 6),
                              _badge(l.anonymous, AppColors.textSecondary),
                            ],
                          ],
                        ),
                        if (review.title?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            review.title!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (review.comment?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            review.comment!,
                            style: AppTextStyles.bodySmall,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (review.createdAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            Formatters.date(review.createdAt!),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (review.photoUrls.isNotEmpty) ...[
                const SizedBox(height: 8),
                ReviewPhotosGrid(urls: review.photoUrls),
              ],
              if (sellerReply != null && sellerReply.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildSellerReply(l, sellerReply),
              ],
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: busy ? null : () => _editReview(review),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l.edit),
                  ),
                  TextButton.icon(
                    onPressed: busy ? null : () => _deleteReview(review),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.errorColor,
                    ),
                    label: Text(
                      l.delete,
                      style: const TextStyle(color: AppColors.errorColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildSellerReply(AppLocalizations l, String reply) {
    return Container(
      width: double.infinity,
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
              Icon(Icons.storefront, size: 14, color: AppColors.primaryColor),
              const SizedBox(width: 4),
              Text(
                l.storeReply,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(reply, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Future<void> _openOrders() async {
    if (_navigationBusy || !mounted) return;
    _navigationBusy = true;
    try {
      await context.push('/orders');
    } finally {
      _navigationBusy = false;
    }
  }

  Future<void> _openItemReviews(MyReviewModel review) async {
    final catalogId = review.catalogId?.toString() ?? '';
    if (catalogId.isEmpty || !mounted) return;
    await CatalogRatingCommentsView.openSheet(
      context,
      catalogId: catalogId,
      title: review.displayItemName,
    );
  }
}

class _EditReviewSheet extends StatefulWidget {
  final MyReviewModel review;
  final Future<void> Function(
    Map<String, dynamic> data,
    List<String>? photoPaths, {
    List<String>? removedPhotoUrls,
  })
  onSave;

  const _EditReviewSheet({required this.review, required this.onSave});

  @override
  State<_EditReviewSheet> createState() => _EditReviewSheetState();
}

class _EditReviewSheetState extends State<_EditReviewSheet> {
  late final TextEditingController _commentController;
  late final TextEditingController _titleController;
  late int _rating;
  List<String> _newPhotos = [];
  final Set<String> _removedExistingUrls = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.review.rating;
    _commentController = TextEditingController(
      text: widget.review.comment ?? '',
    );
    _titleController = TextEditingController(text: widget.review.title ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final l = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l.camera),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l.takeVideo),
              onTap: () => Navigator.pop(context, 'camera_video'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l.gallery),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(l.file),
              onTap: () => Navigator.pop(context, 'file'),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    final remaining = 6 - _newPhotos.length - _existingVisibleCount;
    if (remaining <= 0) return;

    final picker = ImagePicker();
    final List<String> accepted = [];
    switch (choice) {
      case 'camera':
        final shot = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1280,
          imageQuality: 85,
        );
        if (shot != null) accepted.add(shot.path);
      case 'camera_video':
        final video = await picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(minutes: 5),
        );
        if (video != null) accepted.add(video.path);
      case 'gallery':
        final picked = await picker.pickMultipleMedia(limit: remaining);
        for (final p in picked) {
          if (accepted.length >= remaining) break;
          accepted.add(p.path);
        }
      case 'file':
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const [
            'jpg',
            'jpeg',
            'png',
            'webp',
            'gif',
            'heic',
            'mp4',
            'mov',
            'm4v',
            'webm',
            '3gp',
          ],
          allowMultiple: true,
        );
        for (final f in result?.files ?? <PlatformFile>[]) {
          if (accepted.length >= remaining) break;
          if (f.path != null) accepted.add(f.path!);
        }
    }
    if (accepted.isNotEmpty && mounted) {
      setState(() {
        _newPhotos = [..._newPhotos, ...accepted];
      });
    }
  }

  int get _existingVisibleCount {
    return widget.review.photoUrls
        .where((u) => !_removedExistingUrls.contains(u))
        .length;
  }

  void _removeNewPhoto(int index) {
    setState(() => _newPhotos = List.of(_newPhotos)..removeAt(index));
  }

  void _removeExistingPhoto(String url) {
    setState(() => _removedExistingUrls.add(url));
  }

  Widget _buildPhotoPicker(AppLocalizations l, List<String> existingPhotos) {
    final size = (MediaQuery.of(context).size.width - 48) / 3;
    final visibleExisting = existingPhotos
        .where((u) => !_removedExistingUrls.contains(u))
        .toList();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...visibleExisting.map(
          (u) => Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: u,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: size,
                    height: size,
                    color: AppColors.secondaryColor,
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: size,
                    height: size,
                    color: AppColors.secondaryColor,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: InkWell(
                  onTap: () => _removeExistingPhoto(u),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ..._newPhotos.asMap().entries.map(
          (e) => Stack(
            children: [
              LocalMediaThumb(path: e.value, width: size, height: size),
              Positioned(
                top: 2,
                right: 2,
                child: InkWell(
                  onTap: () => _removeNewPhoto(e.key),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_newPhotos.length + visibleExisting.length < 6)
          InkWell(
            onTap: _pickPhotos,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: AppColors.textTertiary),
                  const SizedBox(height: 4),
                  Text(l.uploadPhoto, style: AppTextStyles.labelSmall),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      await widget.onSave(
        {
          'rating': _rating,
          'title': _titleController.text.trim(),
          'comment': _commentController.text.trim(),
        },
        _newPhotos,
        removedPhotoUrls: _removedExistingUrls.toList(),
      );
      if (mounted) {
        AppSnackBar.show(context, l.reviewUpdated, type: SnackBarType.success);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          '${l.failedUpdateReview}: ${LocalizedError.of(l, e.toString())}',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.editReview, style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  icon: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.warningColor,
                    size: 28,
                  ),
                  onPressed: () => setState(() => _rating = i + 1),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l.reviewTitleHint,
                border: const OutlineInputBorder(),
              ),
              maxLength: 255,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => null,
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: l.writeYourReview,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.md),
            _buildPhotoPicker(l, widget.review.photoUrls),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
