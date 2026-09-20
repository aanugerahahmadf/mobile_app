import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/review_repository/review_repository.dart';

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
  Future<Map<String, dynamic>> getPackageReviews(
    String packageId, {
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
      ApiEndpoints.packageReviews(packageId),
      queryParameters: params,
    );
    return {
      'reviews':
          (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': response.data['pagination'],
    };
  }

  @override
  Future<Map<String, dynamic>> getProductReviews(
    String productId, {
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
      ApiEndpoints.productReviews(productId),
      queryParameters: params,
    );
    return {
      'reviews':
          (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': response.data['pagination'],
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getMyReviews() async {
    final response = await _dio.get(ApiEndpoints.myReviews);
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<List<Map<String, dynamic>>> getUserReviews(String userId) async {
    final response = await _dio.get(ApiEndpoints.userReviews(userId));
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<Map<String, dynamic>> getPackageRatingSummary(String packageId) async {
    final response = await _dio.get(
      ApiEndpoints.packageReviewSummary(packageId),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getProductRatingSummary(String productId) async {
    final response = await _dio.get(
      ApiEndpoints.productReviewSummary(productId),
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
