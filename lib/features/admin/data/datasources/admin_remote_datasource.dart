import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class AdminRemoteDataSource {
  final Dio _dio;

  AdminRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<List<Map<String, dynamic>>> list(String endpoint) async {
    final res = await _dio.get(endpoint);
    final body = res.data;
    if (body is Map && body['data'] is List) {
      return (body['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<Map<String, dynamic>?> show(String Function(int id) endpoint, int id) async {
    final res = await _dio.get(endpoint(id));
    final body = res.data;
    if (body is Map && body['data'] is Map) {
      return body['data'] as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> create(String endpoint, Map<String, dynamic> data) async {
    final res = await _dio.post(endpoint, data: data);
    final body = res.data;
    if (body is Map && body['data'] is Map) {
      return body['data'] as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> update(String Function(int id) endpoint, int id, Map<String, dynamic> data) async {
    await _dio.put(endpoint(id), data: data);
  }

  Future<void> delete(String Function(int id) endpoint, int id) async {
    await _dio.delete(endpoint(id));
  }

  Future<void> uploadImage(String Function(int id) endpoint, int id, String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    await _dio.post(endpoint(id), data: formData);
  }
}
