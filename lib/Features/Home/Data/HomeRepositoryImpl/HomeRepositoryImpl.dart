import 'package:dio/dio.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/HomeRepository/HomeRepository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Dio _dio;

  HomeRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<Map<String, dynamic>> getHomeData() async {
    final response = await _dio.get(ApiEndpoints.home);
    return response.data['data'] as Map<String, dynamic>? ?? {};
  }
}
