import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/review_repository_impl.dart';
import '../../domain/review_repository.dart';

class ReviewState {
  final List<Map<String, dynamic>> reviews;
  final bool loading;
  final bool submitting;
  final String? error;

  const ReviewState({
    this.reviews = const [],
    this.loading = false,
    this.submitting = false,
    this.error,
  });

  ReviewState copyWith({
    List<Map<String, dynamic>>? reviews,
    bool? loading,
    bool? submitting,
    String? error,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewRepository _repository;

  ReviewNotifier(this._repository) : super(const ReviewState());

  Future<void> fetchReviews(String packageId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reviews = await _repository.getPackageReviews(packageId);
      state = state.copyWith(reviews: reviews, loading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.error?.toString() ?? 'Gagal memuat ulasan',
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> fetchProductReviews(String productId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reviews = await _repository.getProductReviews(productId);
      state = state.copyWith(reviews: reviews, loading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.error?.toString() ?? 'Gagal memuat ulasan',
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> fetchItemReviews({String packageId = '', String productId = ''}) async {
    if (packageId.isNotEmpty) {
      await fetchReviews(packageId);
    } else if (productId.isNotEmpty) {
      await fetchProductReviews(productId);
    } else {
      state = state.copyWith(reviews: [], loading: false);
    }
  }

  Future<void> fetchUserReviews(String userId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reviews = await _repository.getUserReviews(userId);
      state = state.copyWith(reviews: reviews, loading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.error?.toString() ?? 'Gagal memuat ulasan',
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> createReview(Map<String, dynamic> data, {List<String>? photoPaths}) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final review = await _repository.createReview(data, photoPaths: photoPaths);
      state = state.copyWith(
        reviews: [...state.reviews, review],
        submitting: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        submitting: false,
        error: e.error?.toString() ?? 'Gagal mengirim ulasan',
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(submitting: false, error: e.toString());
      rethrow;
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
    } on DioException catch (e) {
      state = state.copyWith(
        submitting: false,
        error: e.error?.toString() ?? 'Gagal memperbarui ulasan',
      );
      rethrow;
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
    } on DioException catch (e) {
      state = state.copyWith(
        submitting: false,
        error: e.error?.toString() ?? 'Gagal menghapus ulasan',
      );
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
