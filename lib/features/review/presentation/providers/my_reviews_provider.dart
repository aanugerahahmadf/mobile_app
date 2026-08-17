import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/review_repository_impl.dart';
import '../../domain/review_repository.dart';

class MyReviewsState {
  final List<Map<String, dynamic>> reviews;
  final bool loading;
  final bool submitting;
  final String? error;

  const MyReviewsState({
    this.reviews = const [],
    this.loading = false,
    this.submitting = false,
    this.error,
  });

  MyReviewsState copyWith({
    List<Map<String, dynamic>>? reviews,
    bool? loading,
    bool? submitting,
    String? error,
  }) {
    return MyReviewsState(
      reviews: reviews ?? this.reviews,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }
}

class MyReviewsNotifier extends StateNotifier<MyReviewsState> {
  final ReviewRepository _repository;
  MyReviewsNotifier(this._repository) : super(const MyReviewsState());

  Future<void> fetchMyReviews() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reviews = await _repository.getMyReviews();
      state = state.copyWith(reviews: reviews, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> updateReview(int id, Map<String, dynamic> data, {List<String>? photoPaths}) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final updated = await _repository.updateReview(id, data, photoPaths: photoPaths);
      state = state.copyWith(
        reviews: [
          for (final r in state.reviews)
            if ((r['id'] as num?)?.toInt() == id) updated else r,
        ],
        submitting: false,
      );
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteReview(int id) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      await _repository.deleteReview(id);
      state = state.copyWith(
        reviews: state.reviews.where((r) => (r['id'] as num?)?.toInt() != id).toList(),
        submitting: false,
      );
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
    }
  }
}

final myReviewsProvider = StateNotifierProvider<MyReviewsNotifier, MyReviewsState>((ref) {
  return MyReviewsNotifier(ReviewRepositoryImpl());
});
