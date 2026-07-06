import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../domain/search_repository.dart';
import 'models/search_result.dart';

class SearchRepositoryImpl implements SearchRepository {
  final _dio = DioClient.instance;
  final String _endpoint;

  SearchRepositoryImpl({String? endpoint}) : _endpoint = endpoint ?? ApiEndpoints.search;

  @override
  Future<SearchResult> search(String query, {int page = 1}) async {
    return DioClient.safeCall(() async {
      final response = await _dio.get(_endpoint, queryParameters: {
        'query': query,
        'page': page,
      });
      final json = response.data as Map<String, dynamic>? ?? {};
      return SearchResult.fromJson(json);
    });
  }
}
