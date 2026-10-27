import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/wishlist_repository/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final _dio = DioClient.instance;

  @override
  Future<List<Map<String, dynamic>>> getWishlist() async {
    return DioClient.safeCall(() async {
      final response = await _dio.get(ApiEndpoints.wishlist);
      final data = response.data['data'];
      if (data is List) return data.cast<Map<String, dynamic>>();
      return [];
    });
  }

  @override
  Future<void> toggleWishlist({String? packageId, String? catalogId}) async {
    return DioClient.safeCall(() async {
      final body = <String, dynamic>{};
      if (packageId != null) body['package_id'] = packageId;
      if (catalogId != null) body['catalog_id'] = catalogId;
      await _dio.post(ApiEndpoints.wishlistToggle, data: body);
    });
  }

  @override
  Future<void> removeFromWishlist(String id, {bool isCatalog = false}) async {
    return DioClient.safeCall(() async {
      if (isCatalog) {
        await _dio.delete(
          ApiEndpoints.wishlistItem(id),
          queryParameters: {'catalog_id': id},
        );
      } else {
        await _dio.delete(ApiEndpoints.wishlistItem(id));
      }
    });
  }
}
