import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/FavoriteRepository/FavoriteRepository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final _dio = DioClient.instance;

  @override
  Future<List<Map<String, dynamic>>> getFavorite() async {
    return DioClient.safeCall(() async {
      final response = await _dio.get(ApiEndpoints.favorite);
      final data = response.data['data'];
      if (data is List) return data.cast<Map<String, dynamic>>();
      return [];
    });
  }

  @override
  Future<void> toggleFavorite({String? packageId, String? catalogId}) async {
    return DioClient.safeCall(() async {
      final body = <String, dynamic>{};
      if (packageId != null) body['package_id'] = packageId;
      if (catalogId != null) body['catalog_id'] = catalogId;
      await _dio.post(ApiEndpoints.favoriteToggle, data: body);
    });
  }

  @override
  Future<void> removeFromFavorite(String id, {bool isCatalog = false}) async {
    return DioClient.safeCall(() async {
      if (isCatalog) {
        await _dio.delete(
          ApiEndpoints.favoriteItem(id),
          queryParameters: {'catalog_id': id},
        );
      } else {
        await _dio.delete(ApiEndpoints.favoriteItem(id));
      }
    });
  }
}

