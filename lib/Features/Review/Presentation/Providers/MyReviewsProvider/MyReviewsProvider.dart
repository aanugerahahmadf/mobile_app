import '../../../../../Core/Errors/AppErrorCodes/AppErrorCodes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Data/Models/MyReviewModel/MyReviewModel.dart';
import '../../../Data/Models/ReviewPage/ReviewPage.dart';
import '../../../Data/ReviewRepositoryImpl/ReviewRepositoryImpl.dart';
import '../../../Domain/ReviewRepository/ReviewRepository.dart';

class MyReviewsState {
  final List<MyReviewModel> reviews;
  final ReviewSummaryModel summary;
  final ReviewPaginationModel pagination;
  final bool loading;
  final bool loadingMore;
  final bool submitting;
  final String? error;
  final String sort;
  final int? filterRating;
  final bool filterWithPhoto;
  final bool filterWithComment;

  const MyReviewsState({
    this.reviews = const [],
    this.summary = const ReviewSummaryModel(),
    this.pagination = const ReviewPaginationModel(),
    this.loading = false,
    this.loadingMore = false,
    this.submitting = false,
    this.error,
    this.sort = 'newest',
    this.filterRating,
    this.filterWithPhoto = false,
    this.filterWithComment = false,
  });

  bool get hasMore => pagination.hasMorePages;

  MyReviewsState copyWith({
    List<MyReviewModel>? reviews,
    ReviewSummaryModel? summary,
    ReviewPaginationModel? pagination,
    bool? loading,
    bool? loadingMore,
    bool? submitting,
    String? error,
    bool clearError = false,
    String? sort,
    int? filterRating,
    bool clearFilterRating = false,
    bool? filterWithPhoto,
    bool? filterWithComment,
  }) {
    return MyReviewsState(
      reviews: reviews ?? this.reviews,
      summary: summary ?? this.summary,
      pagination: pagination ?? this.pagination,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      sort: sort ?? this.sort,
      filterRating: clearFilterRating
          ? null
          : (filterRating ?? this.filterRating),
      filterWithPhoto: filterWithPhoto ?? this.filterWithPhoto,
      filterWithComment: filterWithComment ?? this.filterWithComment,
    );
  }
}

class MyReviewsNotifier extends StateNotifier<MyReviewsState> {
  final ReviewRepository _repository;

  MyReviewsNotifier(this._repository) : super(const MyReviewsState());

  Future<void> fetchMyReviews({bool refresh = false}) async {
    state = state.copyWith(
      loading: !refresh && state.reviews.isEmpty,
      clearError: true,
    );
    try {
      final page = await _repository.getMyReviews(
        sort: state.sort,
        rating: state.filterRating,
        withPhoto: state.filterWithPhoto,
        withComment: state.filterWithComment,
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
      final page = await _repository.getMyReviews(
        sort: state.sort,
        rating: state.filterRating,
        withPhoto: state.filterWithPhoto,
        withComment: state.filterWithComment,
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

  void setSort(String sort) {
    state = state.copyWith(sort: sort);
  }

  Future<void> updateReview(
    int id,
    Map<String, dynamic> data, {
    List<String>? photoPaths,
    List<String>? removedPhotoUrls,
  }) async {
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final updated = await _repository.updateReview(
        id,
        data,
        photoPaths: photoPaths,
        removedPhotoUrls: removedPhotoUrls,
      );
      final model = MyReviewModel.fromJson(updated);
      state = state.copyWith(
        reviews: [
          for (final r in state.reviews)
            if (r.id == id) model else r,
        ],
        submitting: false,
      );
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
        reviews: state.reviews.where((r) => r.id != id).toList(),
        submitting: false,
      );
      await fetchMyReviews(refresh: true);
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
    }
  }
}

final myReviewsProvider =
    StateNotifierProvider<MyReviewsNotifier, MyReviewsState>((ref) {
      return MyReviewsNotifier(ReviewRepositoryImpl());
    });
