import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/review_repository_impl.dart';
import '../../domain/review_repository.dart';

class ReviewState {
  final List<Map<String, dynamic>> reviews;
  final bool loading;
  final bool loadingMore;
  final bool submitting;
  final String? error;
  final Map<String, dynamic>? ratingSummary;
  final String sort;
  final int? filterRating;
  final bool filterWithPhoto;
  final int currentPage;
  final int lastPage;
  final int total;

  const ReviewState({
    this.reviews = const [],
    this.loading = false,
    this.loadingMore = false,
    this.submitting = false,
    this.error,
    this.ratingSummary,
    this.sort = 'newest',
    this.filterRating,
    this.filterWithPhoto = false,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  ReviewState copyWith({
    List<Map<String, dynamic>>? reviews,
    bool? loading,
    bool? loadingMore,
    bool? submitting,
    String? error,
    Map<String, dynamic>? ratingSummary,
    String? sort,
    int? filterRating,
    bool? filterWithPhoto,
    bool clearFilterRating = false,
    int? currentPage,
    int? lastPage,
    int? total,
    bool clearError = false,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      ratingSummary: ratingSummary ?? this.ratingSummary,
      sort: sort ?? this.sort,
      filterRating: clearFilterRating ? null : (filterRating ?? this.filterRating),
      filterWithPhoto: filterWithPhoto ?? this.filterWithPhoto,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewRepository _repository;

  ReviewNotifier(this._repository) : super(const ReviewState());

  void resetForItem() {
    state = const ReviewState();
  }

  // ── Fetch first page ────────────────────────────────────────────────
  Future<void> fetchItemReviews({String packageId = '', String productId = ''}) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final result = packageId.isNotEmpty
          ? await _repository.getPackageReviews(packageId, sort: state.sort, rating: state.filterRating, withPhoto: state.filterWithPhoto)
          : productId.isNotEmpty
              ? await _repository.getProductReviews(productId, sort: state.sort, rating: state.filterRating, withPhoto: state.filterWithPhoto)
              : null;

      if (result == null) {
        state = state.copyWith(reviews: [], loading: false);
        return;
      }

      final pagination = result['pagination'] as Map<String, dynamic>?;
      state = state.copyWith(
        reviews: result['reviews'],
        loading: false,
        currentPage: pagination?['current_page'] as int? ?? 1,
        lastPage: pagination?['last_page'] as int? ?? 1,
        total: pagination?['total'] as int? ?? 0,
      );
    } on DioException catch (e) {
      state = state.copyWith(loading: false, error: e.error?.toString() ?? 'Gagal memuat ulasan');
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ── Load more (next page) ───────────────────────────────────────────
  Future<void> loadMore({String packageId = '', String productId = ''}) async {
    if (state.loadingMore || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final result = packageId.isNotEmpty
          ? await _repository.getPackageReviews(packageId, sort: state.sort, rating: state.filterRating, withPhoto: state.filterWithPhoto, page: nextPage)
          : productId.isNotEmpty
              ? await _repository.getProductReviews(productId, sort: state.sort, rating: state.filterRating, withPhoto: state.filterWithPhoto, page: nextPage)
              : null;

      if (result == null) {
        state = state.copyWith(loadingMore: false);
        return;
      }

      final newReviews = result['reviews'] as List<Map<String, dynamic>>;
      final pagination = result['pagination'] as Map<String, dynamic>?;
      state = state.copyWith(
        reviews: [...state.reviews, ...newReviews],
        loadingMore: false,
        currentPage: pagination?['current_page'] as int? ?? nextPage,
        lastPage: pagination?['last_page'] as int? ?? state.lastPage,
        total: pagination?['total'] as int? ?? state.total,
      );
    } on DioException catch (e) {
      state = state.copyWith(loadingMore: false, error: e.error?.toString() ?? 'Gagal memuat ulasan');
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e.toString());
    }
  }

  // ── Rating summary ──────────────────────────────────────────────────
  Future<void> fetchRatingSummary({String packageId = '', String productId = ''}) async {
    try {
      Map<String, dynamic>? summary;
      if (packageId.isNotEmpty) {
        summary = await _repository.getPackageRatingSummary(packageId);
      } else if (productId.isNotEmpty) {
        summary = await _repository.getProductRatingSummary(productId);
      }
      if (summary != null) state = state.copyWith(ratingSummary: summary);
    } catch (_) {}
  }

  // ── Filters ─────────────────────────────────────────────────────────
  void setSort(String sort) => state = state.copyWith(sort: sort);

  void setFilterRating(int? rating) {
    if (rating == state.filterRating) {
      state = state.copyWith(clearFilterRating: true);
    } else {
      state = state.copyWith(filterRating: rating);
    }
  }

  void setFilterWithPhoto(bool value) => state = state.copyWith(filterWithPhoto: value);

  // ── Helpful vote (optimistic) ───────────────────────────────────────
  Future<void> voteHelpful(int reviewId) async {
    final previous = state.reviews;
    final isCurrentlyVoted = state.reviews
        .where((r) => (r['id'] as num?)?.toInt() == reviewId)
        .map((r) => r['is_voted'] as bool? ?? false)
        .firstOrNull ?? false;
    final currentCount = state.reviews
        .where((r) => (r['id'] as num?)?.toInt() == reviewId)
        .map((r) => (r['helpful_count'] as num?)?.toInt() ?? 0)
        .firstOrNull ?? 0;

    state = state.copyWith(
      reviews: [
        for (final r in state.reviews)
          if ((r['id'] as num?)?.toInt() == reviewId)
            {...r, 'is_voted': !isCurrentlyVoted, 'helpful_count': currentCount + (isCurrentlyVoted ? -1 : 1)}
          else
            r,
      ],
    );

    try {
      final result = await _repository.voteHelpful(reviewId);
      final isVoted = result['is_voted'] as bool;
      final helpfulCount = result['helpful_count'] as int;
      state = state.copyWith(
        reviews: [
          for (final r in state.reviews)
            if ((r['id'] as num?)?.toInt() == reviewId)
              {...r, 'is_voted': isVoted, 'helpful_count': helpfulCount}
            else
              r,
        ],
      );
    } catch (_) {
      state = state.copyWith(reviews: previous);
    }
  }

  // ── Reply ───────────────────────────────────────────────────────────
  Future<void> replyToReview(int reviewId, String comment) async {
    try {
      final reply = await _repository.replyToReview(reviewId, comment);
      state = state.copyWith(
        reviews: [
          for (final r in state.reviews)
            if ((r['id'] as num?)?.toInt() == reviewId)
              {
                ...r,
                'replies': [
                  ...((r['replies'] as List?)?.cast<Map<String, dynamic>>() ?? []),
                  reply,
                ],
              }
            else
              r,
        ],
      );
    } catch (_) {
      rethrow;
    }
  }

  // ── CRUD ────────────────────────────────────────────────────────────
  Future<void> createReview(Map<String, dynamic> data, {List<String>? photoPaths}) async {
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final review = await _repository.createReview(data, photoPaths: photoPaths);
      state = state.copyWith(
        reviews: [review, ...state.reviews],
        submitting: false,
        total: state.total + 1,
      );
    } on DioException catch (e) {
      state = state.copyWith(submitting: false, error: e.error?.toString() ?? 'Gagal mengirim ulasan');
      rethrow;
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateReview(int id, Map<String, dynamic> data, {List<String>? photoPaths}) async {
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final updated = await _repository.updateReview(id, data, photoPaths: photoPaths);
      state = state.copyWith(
        reviews: [
          for (final r in state.reviews)
            if ((r['id'] as num?)?.toInt() == id) updated else r,
        ],
        submitting: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(submitting: false, error: e.error?.toString() ?? 'Gagal memperbarui ulasan');
      rethrow;
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteReview(int id) async {
    state = state.copyWith(submitting: true, clearError: true);
    try {
      await _repository.deleteReview(id);
      state = state.copyWith(
        reviews: state.reviews.where((r) => (r['id'] as num?)?.toInt() != id).toList(),
        submitting: false,
        total: state.total - 1,
      );
    } on DioException catch (e) {
      state = state.copyWith(submitting: false, error: e.error?.toString() ?? 'Gagal menghapus ulasan');
      rethrow;
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
    }
  }
}

final reviewProvider = StateNotifierProvider<ReviewNotifier, ReviewState>((ref) {
  return ReviewNotifier(ReviewRepositoryImpl());
});
