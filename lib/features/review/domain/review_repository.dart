abstract class ReviewRepository {
  Future<Map<String, dynamic>> createReview(Map<String, dynamic> data, {List<String>? photoPaths});
  Future<List<Map<String, dynamic>>> getPackageReviews(String packageId);
  Future<List<Map<String, dynamic>>> getProductReviews(String productId);
  Future<List<Map<String, dynamic>>> getMyReviews();
  Future<List<Map<String, dynamic>>> getUserReviews(String userId);
  Future<Map<String, dynamic>> updateReview(int id, Map<String, dynamic> data, {List<String>? photoPaths});
  Future<void> deleteReview(int id);
}
