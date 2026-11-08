import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../../../Core/Widgets/AppActionSheet/AppActionSheet.dart';
import '../../../../../Core/Widgets/AppBottomSheet/AppBottomSheet.dart';
import '../../../../../Core/Widgets/AppEmptyState/AppEmptyState.dart';
import '../../../../../Core/Widgets/AppErrorState/AppErrorState.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../Data/Models/CatalogRatingCommentModel/CatalogRatingCommentModel.dart';
import '../../Providers/CatalogRatingCommentsProvider/CatalogRatingCommentsProvider.dart';
import '../RatingSummary/RatingSummary.dart';
import '../ReviewPhotosGrid/ReviewPhotosGrid.dart';

/// Section "Komentar Penilaian Katalog" untuk satu katalog.
///
/// Heading yang terlihat pengguna hanya `4.9 ★ Penilaian (123)`, meniru baris
/// "Penilaian Produk" pada PDP Shopee tanpa qualifier "Produk"/"Katalog":
/// section ini selalu berada di dalam satu katalog, jadi label agregatnya
/// cukup "Penilaian" (l10n `reviews`).
///
/// Ini bukan halaman atau destination route. Widget dipakai sebagai section di
/// dalam CatalogDetail (`inSheet: false`) dan sebagai isi
/// [AppBottomSheet.show] ketika pengguna memilih daftar penuh (`inSheet: true`).
class CatalogRatingCommentsView extends ConsumerStatefulWidget {
  final String? catalogId;
  final String title;
  final bool showWriteReview;
  final bool inSheet;
  final ScrollController? scrollController;

  const CatalogRatingCommentsView({
    super.key,
    this.catalogId,
    this.title = '',
    this.showWriteReview = true,
    this.inSheet = false,
    this.scrollController,
  });

  static Future<void> openSheet(
    BuildContext context, {
    required String? catalogId,
    required String title,
  }) {
    return AppBottomSheet.show<void>(
      context,
      _CatalogRatingCommentsSheet(catalogId: catalogId, title: title),
      title: title.isEmpty ? null : title,
      initial: 0.75,
    );
  }

  @override
  ConsumerState<CatalogRatingCommentsView> createState() =>
      _CatalogRatingCommentsViewState();
}

/// Sheet membuka instance sendiri di dalam `AppBottomSheet.show`, sehingga
/// scroll controller milik [DraggableScrollableSheet] bisa diteruskan ke
/// paginasi tanpa membongkar API sheet.
class _CatalogRatingCommentsSheet extends ConsumerStatefulWidget {
  final String? catalogId;
  final String title;

  const _CatalogRatingCommentsSheet({
    required this.catalogId,
    required this.title,
  });

  @override
  ConsumerState<_CatalogRatingCommentsSheet> createState() =>
      _CatalogRatingCommentsSheetState();
}

class _CatalogRatingCommentsSheetState
    extends ConsumerState<_CatalogRatingCommentsSheet> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CatalogRatingCommentsView(
      catalogId: widget.catalogId,
      title: widget.title,
      inSheet: true,
      scrollController: _controller,
    );
  }
}

class _CatalogRatingCommentsViewState
    extends ConsumerState<CatalogRatingCommentsView> {
  static const _embeddedPreviewCount = 2;

  bool _navigationBusy = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      _notifier().fetchCatalogRatingComments();
    });
    // Paginasi infinite scroll hanya untuk sheet. Section embedded memakai
    // scroll view milik CatalogDetail sehingga tidak boleh menambah listener
    // ke controller induk.
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  CatalogRatingCommentsNotifier _notifier() =>
      ref.read(catalogRatingCommentsProvider(widget.catalogId).notifier);

  void _onScroll() {
    final controller = widget.scrollController;
    if (controller == null || !controller.hasClients) return;
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 240) {
      _notifier().loadMore();
    }
  }

  bool _ensureAuthenticated() {
    if (ref.read(authProvider) is AuthAuthenticated) return true;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const GuestAuthPrompt(),
    );
    return false;
  }

  Future<void> _refresh() async {
    await _notifier().fetchCatalogRatingComments(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(catalogRatingCommentsProvider(widget.catalogId));

    // Material ancestor dibutuhkan TextField/InkWell di dalam header; widget
    // ini bisa dipakai tanpa Scaffold ketika host-nya bukan Material.
    return Material(
      type: MaterialType.transparency,
      child: !widget.inSheet ? _buildEmbedded(l, state) : _buildSheet(l, state),
    );
  }

  /// Daftar penuh di dalam bottom sheet: satu ListView dengan header di baris
  /// pertama agar filter chip, sort, dan paginasi memakai scroll sheet.
  Widget _buildSheet(AppLocalizations l, CatalogRatingCommentsState state) {
    if (state.loading && state.reviews.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null && state.reviews.isEmpty) {
      return AppErrorState(
        message: LocalizedError.of(l, state.error!),
        onRetry: () => _notifier().fetchCatalogRatingComments(),
      );
    }

    final children = <Widget>[
      _buildHeader(l, state),
      if (state.reviews.isEmpty)
        _buildEmptyState(l, state)
      else
        ...state.reviews.map((review) => _buildReviewCard(l, state, review)),
      if (state.loadingMore)
        const Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      if (state.error != null && state.reviews.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.sm),
          child: Text(
            LocalizedError.of(l, state.error!),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.errorColor,
            ),
          ),
        ),
    ];

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  /// Section yang ditanam di dalam scroll view CatalogDetail.
  Widget _buildEmbedded(AppLocalizations l, CatalogRatingCommentsState state) {
    if (state.loading && state.reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(l, state),
        if (state.reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.xs),
            child: Text(
              _isFilteredView(state) ? l.noResults : l.noReviews,
              style: AppTextStyles.bodySmall,
            ),
          )
        else ...[
          // Halaman detail hanya menampilkan cuplikan pendek; daftar penuh dan
          // paginasinya hidup di sheet "Lihat semua", seperti Shopee.
          ...state.reviews
              .take(_embeddedPreviewCount)
              .map((review) => _buildReviewCard(l, state, review)),
          // Shopee menaruh tautan daftar penuh di bawah cuplikan. Baris
          // heading di atas membuka sheet yang sama, jadi jumlahnya tidak boleh
          // dua-duanya hilang ketika katalog sudah punya penilaian.
          if (state.summary.total > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _openSheet,
                child: Text('${l.seeAll} (${state.summary.total})'),
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
      ],
    );
  }

  bool _isFilteredView(CatalogRatingCommentsState state) {
    return state.filterRating != null ||
        state.filterWithPhoto ||
        state.filterWithComment ||
        state.filterVerifiedOnly;
  }

  void _clearFilters() {
    final notifier = _notifier()
      ..setFilterRating(null)
      ..setFilterWithPhoto(false)
      ..setFilterWithComment(false)
      ..setFilterVerifiedOnly(false);
    notifier.fetchCatalogRatingComments(refresh: true);
  }

  /// Bedakan katalog yang belum punya penilaian dari filter yang hasilnya nol:
  /// marketplace menampilkan tombol "Bersihkan" pada kasus kedua, bukan
  /// "Jadilah yang pertama menilai".
  Widget _buildEmptyState(
    AppLocalizations l,
    CatalogRatingCommentsState state,
  ) {
    if (!_isFilteredView(state)) {
      return SizedBox(
        height: 240,
        child: AppEmptyState(
          icon: Icons.star_border,
          title: l.noReviews,
          subtitle: l.beFirstReview,
        ),
      );
    }
    return SizedBox(
      height: 280,
      child: AppEmptyState(
        icon: Icons.filter_alt_off_outlined,
        title: l.noResults,
        actionLabel: l.clearAll,
        onAction: _clearFilters,
      ),
    );
  }

  void _openSheet() => CatalogRatingCommentsView.openSheet(
    context,
    catalogId: widget.catalogId,
    title: widget.title,
  );

  /// Baris heading section, mengikuti PDP Shopee: `4.9 ★ Penilaian (123)`
  /// dengan chevron ketika section ini hidup di halaman detail.
  ///
  /// Namanya cukup "Penilaian" (`l10n reviews`). "Produk"/"Katalog" tidak
  /// dipakai karena section ini selalu berada di dalam satu katalog yang
  /// sedang dibuka, jadi qualifiers itu tidak menambah informasi.
  Widget _buildRatingHeading(
    AppLocalizations l,
    CatalogRatingCommentsState state,
  ) {
    final average = state.summary.average;
    final total = state.summary.total;
    final canOpenList = !widget.inSheet && total > 0;
    return InkWell(
      onTap: canOpenList ? _openSheet : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            if (average > 0) ...[
              Text(
                average.toStringAsFixed(1),
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 18, color: AppColors.warningColor),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                l.reviews,
                style: AppTextStyles.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (total > 0) ...[
              const SizedBox(width: 4),
              Text(
                '($total)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
            if (canOpenList)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l, CatalogRatingCommentsState state) {
    final horizontalPadding = widget.inSheet ? 0.0 : AppSizes.md;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildRatingHeading(l, state)),
              if (widget.showWriteReview)
                TextButton.icon(
                  onPressed: _openWriteReview,
                  icon: const Icon(Icons.rate_review_outlined, size: 18),
                  label: Text(l.writeRatingComment),
                ),
            ],
          ),
          RatingSummary(
            average: state.summary.average,
            total: state.summary.total,
            withPhotoCount: state.summary.withMediaCount,
            // Skor rata-rata sudah tampil di baris heading di atas.
            showAverage: false,
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
              final notifier = _notifier();
              notifier.setFilterRating(
                state.filterRating == star ? null : star,
              );
              notifier.fetchCatalogRatingComments(refresh: true);
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

  /// Chip filter dengan jumlah, seperti Shopee/Tokopedia/TikTok Shop: nol
  /// membuat chip hilang supaya baris filter tetap pendek, dan "Semua" selalu
  /// ada sebagai pilihan untuk melepas filter.
  Widget _buildFilterChips(
    AppLocalizations l,
    CatalogRatingCommentsState state,
  ) {
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
            !state.filterWithComment &&
            !state.filterVerifiedOnly,
        onTap: _clearFilters,
      ),
      for (var star = 5; star >= 1; star--)
        if ((countsByStar[star] ?? 0) > 0)
          (
            label: '$star ★ (${countsByStar[star]})',
            selected: state.filterRating == star,
            onTap: () {
              final notifier = _notifier();
              notifier.setFilterRating(
                state.filterRating == star ? null : star,
              );
              notifier.fetchCatalogRatingComments(refresh: true);
            },
          ),
      if (summary.withMediaCount > 0)
        (
          label: '${l.withPhoto} (${summary.withMediaCount})',
          selected: state.filterWithPhoto,
          onTap: () {
            final notifier = _notifier();
            notifier.setFilterWithPhoto(!state.filterWithPhoto);
            notifier.fetchCatalogRatingComments(refresh: true);
          },
        ),
      if (summary.withCommentCount > 0)
        (
          label: '${l.withComment} (${summary.withCommentCount})',
          selected: state.filterWithComment,
          onTap: () {
            final notifier = _notifier();
            notifier.setFilterWithComment(!state.filterWithComment);
            notifier.fetchCatalogRatingComments(refresh: true);
          },
        ),
      if (summary.verifiedCount > 0)
        (
          label: '${l.verifiedPurchase} (${summary.verifiedCount})',
          selected: state.filterVerifiedOnly,
          onTap: () {
            final notifier = _notifier();
            notifier.setFilterVerifiedOnly(!state.filterVerifiedOnly);
            notifier.fetchCatalogRatingComments(refresh: true);
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

  Widget _buildSortMenu(AppLocalizations l, CatalogRatingCommentsState state) {
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
          final notifier = _notifier();
          notifier.setSort(value);
          notifier.fetchCatalogRatingComments(refresh: true);
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
            // Shopee/TikTok Shop menampilkan opsi aktif, bukan label "Sort".
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

  Widget _buildReviewCard(
    AppLocalizations l,
    CatalogRatingCommentsState state,
    CatalogRatingCommentModel review,
  ) {
    final avatar = review.reviewerAvatar ?? '';
    final itemImage = Formatters.imageUrl(review.displayItemImage);
    final sellerReply = review.activeSellerReply;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      // Shopee/Tokopedia/TikTok Shop tidak punya destinasi "semua ulasan milik
      // satu penulis": kartu ulasan bukan affordance navigasi. Tap hanya hidup
      // pada media (viewer) dan tombol "Bermanfaat". Membuka profil pengulas
      // juga membocorkan riwayat pembelian lintas katalog miliknya.
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.secondaryColor,
                  backgroundImage: avatar.isNotEmpty
                      ? CachedNetworkImageProvider(avatar)
                      : null,
                  child: avatar.isEmpty
                      ? Text(
                          review.displayName.isEmpty
                              ? 'U'
                              : review.displayName[0].toUpperCase(),
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              review.displayName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (review.isAnonymous) ...[
                            const SizedBox(width: 6),
                            _badge(l.anonymous, AppColors.textSecondary),
                          ],
                          if (review.isVerifiedPurchase) ...[
                            const SizedBox(width: 6),
                            _badge(l.verifiedPurchase, AppColors.successColor),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: AppColors.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: itemImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: itemImage,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Container(
                            width: 52,
                            height: 52,
                            color: AppColors.secondaryColor,
                            child: const Icon(Icons.broken_image, size: 24),
                          ),
                        )
                      : Container(
                          width: 52,
                          height: 52,
                          color: AppColors.secondaryColor,
                          child: const Icon(Icons.inventory_2, size: 24),
                        ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.displayItemName.isEmpty
                            ? l.reviews
                            : review.displayItemName,
                        style: AppTextStyles.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (review.variation?.isNotEmpty == true)
                        Text(
                          review.variation!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (review.title?.isNotEmpty == true) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                review.title!,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (review.comment?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(review.comment!, style: AppTextStyles.bodySmall),
            ] else ...[
              // Rating tanpa komentar tetap ditampilkan, dengan baris abu-abu
              // seperti Shopee, bukan kartu yang tampak rusak.
              const SizedBox(height: 4),
              Text(
                l.ratingWithoutComment,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (review.photoUrls.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              ReviewPhotosGrid(urls: review.photoUrls),
            ],
            if (sellerReply != null && sellerReply.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              _buildSellerReply(l, sellerReply),
            ],
            const SizedBox(height: AppSizes.xs),
            Row(
              children: [
                Text(
                  review.createdAt == null
                      ? ''
                      : Formatters.timeAgo(review.createdAt!),
                  style: AppTextStyles.labelSmall,
                ),
                const Spacer(),
                _buildHelpfulButton(l, state, review),
              ],
            ),
          ],
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

  Widget _buildHelpfulButton(
    AppLocalizations l,
    CatalogRatingCommentsState state,
    CatalogRatingCommentModel review,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: state.voting
          ? null
          : () {
              if (!_ensureAuthenticated()) return;
              _notifier().voteHelpful(review.id);
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              review.isVoted ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: 16,
              color: review.isVoted
                  ? AppColors.primaryColor
                  : AppColors.textTertiary,
            ),
            if (review.helpfulCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '${review.helpfulCount}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: review.isVoted
                      ? AppColors.primaryColor
                      : AppColors.textTertiary,
                ),
              ),
            ],
            const SizedBox(width: 4),
            Text(
              l.helpful,
              style: AppTextStyles.bodySmall.copyWith(
                color: review.isVoted
                    ? AppColors.primaryColor
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWriteReview() async {
    if (!_ensureAuthenticated()) return;
    if (_navigationBusy || !mounted) return;
    final catalogId = widget.catalogId;
    if (catalogId == null || catalogId.isEmpty) return;
    _navigationBusy = true;
    try {
      await context.push(
        '/write-review',
        extra: {'catalog_id': catalogId, 'name': widget.title},
      );
    } finally {
      _navigationBusy = false;
    }
  }
}
