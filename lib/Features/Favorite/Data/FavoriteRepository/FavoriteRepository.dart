import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';

class FavoriteRepository {
  final _dio = DioClient.instance;

  Future<List<Map<String, dynamic>>> getFavorite() async {
    final response = await _dio.get(ApiEndpoints.favorite);
    final data = response.data['data'];
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }

  Future<void> toggleFavorite({String? catalogId}) async {
    final body = <String, dynamic>{};
    if (catalogId != null) body['catalog_id'] = catalogId;
    await _dio.post(ApiEndpoints.favoriteToggle, data: body);
  }

  Future<void> removeFromFavorite(String catalogId) async {
    await _dio.delete(ApiEndpoints.favoriteItem(catalogId));
  }
}

