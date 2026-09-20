import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/review/presentation/providers/review_provider/review_provider.dart';
import 'package:mobile_app/features/review/domain/review_repository/review_repository.dart';

class _DelayedReviewRepository implements ReviewRepository {
  int createCalls = 0;
  final Completer<void> release = Completer<void>();

  @override
  Future<Map<String, dynamic>> createReview(
    Map<String, dynamic> data, {
    List<String>? photoPaths,
  }) async {
    createCalls++;
    await release.future;
    return {'id': createCalls, ...data};
  }

  @override
  Future<Map<String, dynamic>> getPackageReviews(
    String packageId, {
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    int page = 1,
  }) async => {
    'reviews': [],
    'pagination': {'current_page': 1, 'last_page': 1, 'total': 0},
  };

  @override
  Future<Map<String, dynamic>> getProductReviews(
    String productId, {
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    int page = 1,
  }) async => {
    'reviews': [],
    'pagination': {'current_page': 1, 'last_page': 1, 'total': 0},
  };

  @override
  Future<List<Map<String, dynamic>>> getMyReviews() async => [];

  @override
  Future<List<Map<String, dynamic>>> getUserReviews(String userId) async => [];

  @override
  Future<Map<String, dynamic>> updateReview(
    int id,
    Map<String, dynamic> data, {
    List<String>? photoPaths,
    List<String>? removedPhotoUrls,
  }) async => {'id': id, ...data};

  @override
  Future<void> deleteReview(int id) async {}

  @override
  Future<Map<String, dynamic>> getPackageRatingSummary(
    String packageId,
  ) async => {};

  @override
  Future<Map<String, dynamic>> getProductRatingSummary(
    String productId,
  ) async => {};

  @override
  Future<Map<String, dynamic>> voteHelpful(int reviewId) async => {};

  @override
  Future<Map<String, dynamic>> replyToReview(
    int reviewId,
    String comment,
  ) async => {};

  @override
  Future<void> deleteReply(int reviewId, int replyId) async {}
}

void main() {
  test(
    'review submission cannot create duplicate requests while loading',
    () async {
      final repository = _DelayedReviewRepository();
      final notifier = ReviewNotifier(repository);

      final first = notifier.createReview({'comment': 'Bagus'});
      final second = notifier.createReview({'comment': 'Duplikat'});
      expect(notifier.state.submitting, isTrue);

      // The provider-level guard must allow only the first concurrent call.
      expect(repository.createCalls, 1);
      repository.release.complete();
      await Future.wait([first, second]);
      expect(repository.createCalls, 1);
      expect(notifier.state.submitting, isFalse);
    },
  );
}
