import '../../../../../Core/Errors/AppErrorCodes/AppErrorCodes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Data/Models/CatalogRatingCommentModel/CatalogRatingCommentModel.dart';
import '../../../Data/Models/ReviewPage/ReviewPage.dart';
import '../../../Data/ReviewRepositoryImpl/ReviewRepositoryImpl.dart';
import '../../../Domain/ReviewRepository/ReviewRepository.dart';

class CatalogRatingCommentsState {
  final List<CatalogRatingCommentModel> reviews;
  final ReviewSummaryModel summary;
  final ReviewPaginationModel pagination;
  final bool loading;
  final bool loadingMore;
  final bool voting;
  final String? error;
  final String sort;
  final int? filterRating;
  final bool filterWithPhoto;
  final bool filterWithComment;
  final bool filterVerifiedOnly;

  const CatalogRatingCommentsState({
    this.reviews = const [],
    this.summary = const ReviewSummaryModel(),
    this.pagination = const ReviewPaginationModel(),
    this.loading = false,
    this.loadingMore = false,
    this.voting = false,
    this.error,
    this.sort = 'newest',
    this.filterRating,
    this.filterWithPhoto = false,
    this.filterWithComment = false,
    this.filterVerifiedOnly = false,
  });

  bool get hasMore => pagination.hasMorePages;

  CatalogRatingCommentsState copyWith({
    List<CatalogRatingCommentModel>? reviews,
    ReviewSummaryModel? summary,
    ReviewPaginationModel? pagination,
    bool? loading,
    bool? loadingMore,
    bool? voting,
    String? error,
    bool clearError = false,
    String? sort,
    int? filterRating,
    bool clearFilterRating = false,
    bool? filterWithPhoto,
    bool? filterWithComment,
    bool? filterVerifiedOnly,
  }) {
    return CatalogRatingCommentsState(
      reviews: reviews ?? this.reviews,
      summary: summary ?? this.summary,
      pagination: pagination ?? this.pagination,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      voting: voting ?? this.voting,
      error: clearError ? null : (error ?? this.error),
      sort: sort ?? this.sort,
      filterRating: clearFilterRating
          ? null
          : (filterRating ?? this.filterRating),
      filterWithPhoto: filterWithPhoto ?? this.filterWithPhoto,
      filterWithComment: filterWithComment ?? this.filterWithComment,
      filterVerifiedOnly: filterVerifiedOnly ?? this.filterVerifiedOnly,
    );
  }
}

class CatalogRatingCommentsNotifier
    extends StateNotifier<CatalogRatingCommentsState> {
  final ReviewRepository _repository;
  final int? _catalogId;

  CatalogRatingCommentsNotifier(this._repository, {String? catalogId})
    : _catalogId = int.tryParse(catalogId ?? ''),
      super(const CatalogRatingCommentsState());

  Future<void> fetchCatalogRatingComments({bool refresh = false}) async {
    // Halaman detail dan sheet "Lihat semua" memakai provider yang sama.
    // Kondisi default yang sudah terisi tidak diambil ulang; filter chip,
    // sort, dan refresh manual selalu memicu request.
    final isDefaultView =
        state.sort == 'newest' &&
        state.filterRating == null &&
        !state.filterWithPhoto &&
        !state.filterWithComment &&
        !state.filterVerifiedOnly;
    if (!refresh && isDefaultView && state.reviews.isNotEmpty) {
      return;
    }
    state = state.copyWith(
      loading: !refresh && state.reviews.isEmpty,
      clearError: true,
    );
    try {
      final page = await _repository.getCatalogRatingComments(
        sort: state.sort,
        rating: state.filterRating,
        withPhoto: state.filterWithPhoto,
        withComment: state.filterWithComment,
        verifiedOnly: state.filterVerifiedOnly,
        catalogId: _catalogId,
      );
      state = state.copyWith(
        reviews: page.items,
        summary: page.summary,
        pagination: page.pagination,
        loading: false,
        loadingMore: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        error: e.error?.toString() ?? e.message ?? AppErrorCodes.failedLoadReviews,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    state = state.copyWith(loadingMore: true, clearError: true);
    try {
      final page = await _repository.getCatalogRatingComments(
        sort: state.sort,
        rating: state.filterRating,
        withPhoto: state.filterWithPhoto,
        withComment: state.filterWithComment,
        verifiedOnly: state.filterVerifiedOnly,
        catalogId: _catalogId,
        page: state.pagination.currentPage + 1,
      );
      state = state.copyWith(
        reviews: [...state.reviews, ...page.items],
        summary: page.summary,
        pagination: page.pagination,
        loadingMore: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loadingMore: false,
        error: e.error?.toString() ?? e.message ?? AppErrorCodes.failedLoadReviews,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e.toString());
    }
  }

  void setFilterRating(int? rating) {
    state = state.copyWith(
      filterRating: rating,
      clearFilterRating: rating == null,
    );
  }

  void setFilterWithPhoto(bool value) {
    state = state.copyWith(filterWithPhoto: value);
  }

  void setFilterWithComment(bool value) {
    state = state.copyWith(filterWithComment: value);
  }

  void setFilterVerifiedOnly(bool value) {
    state = state.copyWith(filterVerifiedOnly: value);
  }

  void setSort(String sort) {
    state = state.copyWith(sort: sort);
  }

  Future<void> voteHelpful(int reviewId) async {
    if (state.voting) return;
    state = state.copyWith(voting: true, clearError: true);
    try {
      final result = await _repository.voteHelpful(reviewId);
      final isVoted = result['is_voted'] == true;
      final helpfulCount = (result['helpful_count'] as num?)?.toInt() ?? 0;
      state = state.copyWith(
        reviews: [
          for (final review in state.reviews)
            if (review.id == reviewId)
              review.copyWith(isVoted: isVoted, helpfulCount: helpfulCount)
            else
              review,
        ],
        voting: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        voting: false,
        error: e.error?.toString() ?? e.message ?? AppErrorCodes.failedProcessVote,
      );
    } catch (e) {
      state = state.copyWith(voting: false, error: e.toString());
    }
  }
}

/// Provider per katalog. Kunci `catalogId` menjaga state ulasan satu produk
/// tidak bocor ke produk lain saat pengguna berpindah halaman.
final catalogRatingCommentsProvider =
    StateNotifierProvider.family<
      CatalogRatingCommentsNotifier,
      CatalogRatingCommentsState,
      String?
    >((ref, catalogId) {
      return CatalogRatingCommentsNotifier(
        ReviewRepositoryImpl(),
        catalogId: catalogId,
      );
    });
