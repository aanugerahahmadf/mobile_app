import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/search_repository/search_repository.dart';
import '../models/search_result/search_result.dart';

class SearchRepositoryImpl implements SearchRepository {
  final _dio = DioClient.instance;

  @override
  Future<SearchResult> search(String query, {int page = 1}) async {
    return DioClient.safeCall(() async {
      final response = await _dio.get(
        ApiEndpoints.search,
        queryParameters: {'query': query, 'page': page},
      );
      final json = response.data as Map<String, dynamic>? ?? {};

      // `l` sengaja tidak diteruskan.
      //
      // Sebelumnya baris ini mengambil AppLocalizations lewat
      // `WidgetsBinding.instance.rootElement!`. Itu rapuh di dua cara:
      // rootElement nullable sebelum frame pertama, dan setiap pemanggil
      // repository harus punya widget tree yang sudah dibangun -- termasuk
      // unit test, yang tidak punya sama sekali.
      //
      // Tidak ada yang hilang: SearchResult.fromJson dan
      // SearchSuggestion.fromJson menerima `l` opsional dan semua label
      // sudah punya fallback. Lapisan data juga tidak seharusnya menyentuh
      // widget tree sama sekali.
      return SearchResult.fromJson(json);
    });
  }
}
