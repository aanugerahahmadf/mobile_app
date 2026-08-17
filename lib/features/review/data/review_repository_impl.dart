import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../domain/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final Dio _dio;

  ReviewRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  FormData? _buildFormData(Map<String, dynamic> data, List<String>? photoPaths) {
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
  Future<Map<String, dynamic>> createReview(Map<String, dynamic> data, {List<String>? photoPaths}) async {
    final response = await _dio.post(
      ApiEndpoints.reviews,
      data: _buildFormData(data, photoPaths) ?? data,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateReview(int id, Map<String, dynamic> data, {List<String>? photoPaths}) async {
    final response = await _dio.put(
      ApiEndpoints.review(id),
      data: _buildFormData(data, photoPaths) ?? data,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> deleteReview(int id) async {
    await _dio.delete(ApiEndpoints.review(id));
  }

  @override
  Future<List<Map<String, dynamic>>> getPackageReviews(String packageId) async {
    final response = await _dio.get(ApiEndpoints.packageReviews(packageId));
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
    final response = await _dio.get(ApiEndpoints.productReviews(productId));
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
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
}
