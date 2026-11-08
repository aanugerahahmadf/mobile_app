import 'package:dio/dio.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/ReviewRepository/ReviewRepository.dart';
import '../Models/CatalogRatingCommentModel/CatalogRatingCommentModel.dart';
import '../Models/MyReviewModel/MyReviewModel.dart';
import '../Models/ReviewPage/ReviewPage.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final Dio _dio;

  ReviewRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  FormData? _buildFormData(
    Map<String, dynamic> data,
    List<String>? photoPaths,
  ) {
    if (photoPaths == null || photoPaths.isEmpty) {
      return data.isEmpty ? null : FormData.fromMap(data);
    }
    final form = FormData();
    data.forEach((k, v) => form.fields.add(MapEntry(k, v.toString())));
    for (final p in photoPaths) {
      form.files.add(MapEntry('photos[]', MultipartFile.fromFileSync(p)));
    }
    return form;
  }

  @override
  Future<Map<String, dynamic>> createReview(
    Map<String, dynamic> data, {
    List<String>? photoPaths,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.reviews,
      data: _buildFormData(data, photoPaths) ?? data,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateReview(
    int id,
    Map<String, dynamic> data, {
    List<String>? photoPaths,
    List<String>? removedPhotoUrls,
  }) async {
    final hasNew = photoPaths != null && photoPaths.isNotEmpty;
    final hasRemoved = removedPhotoUrls != null && removedPhotoUrls.isNotEmpty;
    if (!hasNew && !hasRemoved) {
      final response = await _dio.put(ApiEndpoints.review(id), data: data);
      return response.data['data'] as Map<String, dynamic>;
    }
    final form = FormData();
    data.forEach((k, v) => form.fields.add(MapEntry(k, v.toString())));
    if (hasNew) {
      for (final p in photoPaths) {
        form.files.add(MapEntry('photos[]', MultipartFile.fromFileSync(p)));
      }
    }
    if (hasRemoved) {
      for (final url in removedPhotoUrls) {
        form.fields.add(MapEntry('removed_photo_urls[]', url));
      }
    }
    final response = await _dio.put(ApiEndpoints.review(id), data: form);
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> deleteReview(int id) async {
    await _dio.delete(ApiEndpoints.review(id));
  }

  @override
  Future<Map<String, dynamic>> getCatalogReviews(
    String catalogId, {
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    int page = 1,
  }) async {
    final params = <String, dynamic>{
      'sort': sort,
      'per_page': 10,
      'page': page,
    };
    if (rating != null) params['rating'] = rating;
    if (withPhoto) params['with_photo'] = true;
    final response = await _dio.get(
      ApiEndpoints.catalogReviews(catalogId),
      queryParameters: params,
    );
    return {
      'reviews':
          (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': response.data['pagination'],
    };
  }

  Map<String, dynamic> _reviewQuery({
    required String sort,
    int? rating,
    bool withPhoto = false,
    bool withComment = false,
    bool verifiedOnly = false,
    String search = '',
    int? catalogId,
    required int page,
    required int perPage,
  }) {
    return {
      'sort': sort,
      'page': page,
      'per_page': perPage,
      'rating': ?rating,
      if (withPhoto) 'with_media': 1,
      if (withComment) 'with_comment': 1,
      if (verifiedOnly) 'verified_only': 1,
      if (search.trim().isNotEmpty) 'search': search.trim(),
      'catalog_id': ?catalogId,
    };
  }

  @override
  Future<ReviewPage<MyReviewModel>> getMyReviews({
    String sort = 'newest',
    int? rating,
    bool withPhoto = false,
    bool withComment = false,
    String search = '',
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.myReviews,
      queryParameters: _reviewQuery(
        sort: sort,
        rating: rating,
        withPhoto: withPhoto,
        withComment: withComment,
        search: search,
        page: page,
        perPage: perPage,
      ),
    );
    return ReviewPage.fromResponse(
      Map<String, dynamic>.from(response.data as Map),
      MyReviewModel.fromJson,
    );
  }

  @override
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
  }) async {
    final response = await _dio.get(
      ApiEndpoints.reviews,
      queryParameters: _reviewQuery(
        sort: sort,
        rating: rating,
        withPhoto: withPhoto,
        withComment: withComment,
        verifiedOnly: verifiedOnly,
        search: search,
        catalogId: catalogId,
        page: page,
        perPage: perPage,
      ),
    );
    return ReviewPage.fromResponse(
      Map<String, dynamic>.from(response.data as Map),
      CatalogRatingCommentModel.fromJson,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getUserReviews(String userId) async {
    final response = await _dio.get(ApiEndpoints.userReviews(userId));
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<Map<String, dynamic>> getCatalogRatingSummary(String catalogId) async {
    final response = await _dio.get(
      ApiEndpoints.catalogReviewSummary(catalogId),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> voteHelpful(int reviewId) async {
    final response = await _dio.post(ApiEndpoints.reviewVote(reviewId));
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> replyToReview(
    int reviewId,
    String comment,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.reviewReply(reviewId),
      data: {'comment': comment},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> deleteReply(int reviewId, int replyId) async {
    await _dio.delete(ApiEndpoints.reviewDeleteReply(reviewId, replyId));
  }
}
