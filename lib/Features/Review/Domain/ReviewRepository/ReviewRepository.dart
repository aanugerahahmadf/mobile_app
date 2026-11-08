import '../../Data/Models/CatalogRatingCommentModel/CatalogRatingCommentModel.dart';
import '../../Data/Models/MyReviewModel/MyReviewModel.dart';
import '../../Data/Models/ReviewPage/ReviewPage.dart';

abstract class ReviewRepository {
  Future<Map<String, dynamic>> createReview(
    Map<String, dynamic> data, {
    List<String>? photoPaths,
  });
  Future<Map<String, dynamic>> getCatalogReviews(
    String catalogId, {
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    int page = 1,
  });

  /// "Komentar Penilaian Katalog Saya" — hanya milik pengguna yang login.
  Future<ReviewPage<MyReviewModel>> getMyReviews({
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    bool withComment = false,
    String search = '',
    int page = 1,
    int perPage = 10,
  });

  /// "Komentar Penilaian Katalog" — seluruh komentar penilaian satu katalog.
  /// `search` tetap dilayani server, tapi tidak dipakai UI: menyaring lewat
  /// chip, seperti marketplace pada umumnya.
  Future<ReviewPage<CatalogRatingCommentModel>> getCatalogRatingComments({
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    bool withComment = false,
    bool verifiedOnly = false,
    String search = '',
    int? catalogId,
    int page = 1,
    int perPage = 10,
  });

  Future<List<Map<String, dynamic>>> getUserReviews(String userId);
  Future<Map<String, dynamic>> updateReview(
    int id,
    Map<String, dynamic> data, {
    List<String>? photoPaths,
    List<String>? removedPhotoUrls,
  });
  Future<void> deleteReview(int id);
  Future<Map<String, dynamic>> getCatalogRatingSummary(String catalogId);
  Future<Map<String, dynamic>> voteHelpful(int reviewId);
  Future<Map<String, dynamic>> replyToReview(int reviewId, String comment);
  Future<void> deleteReply(int reviewId, int replyId);
}
