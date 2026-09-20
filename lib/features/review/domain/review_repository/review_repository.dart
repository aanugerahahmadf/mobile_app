abstract class ReviewRepository {
  Future<Map<String, dynamic>> createReview(
    Map<String, dynamic> data, {
    List<String>? photoPaths,
  });
  Future<Map<String, dynamic>> getPackageReviews(
    String packageId, {
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    int page = 1,
  });
  Future<Map<String, dynamic>> getProductReviews(
    String productId, {
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    int page = 1,
  });
  Future<List<Map<String, dynamic>>> getMyReviews();
  Future<List<Map<String, dynamic>>> getUserReviews(String userId);
  Future<Map<String, dynamic>> updateReview(
    int id,
    Map<String, dynamic> data, {
    List<String>? photoPaths,
    List<String>? removedPhotoUrls,
  });
  Future<void> deleteReview(int id);
  Future<Map<String, dynamic>> getPackageRatingSummary(String packageId);
  Future<Map<String, dynamic>> getProductRatingSummary(String productId);
  Future<Map<String, dynamic>> voteHelpful(int reviewId);
  Future<Map<String, dynamic>> replyToReview(int reviewId, String comment);
  Future<void> deleteReply(int reviewId, int replyId);
}
