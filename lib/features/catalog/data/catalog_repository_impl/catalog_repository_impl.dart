import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  @override
  Future<Map<String, dynamic>> getPackages({
    String? categoryId,
    String? search,
    String? sort,
    int? perPage,
  }) async {
    final q = <String, dynamic>{};
    if (categoryId != null) q['category_id'] = categoryId;
    if (search != null) q['search'] = search;
    if (sort != null) q['sort'] = sort;
    if (perPage != null) q['per_page'] = perPage;
    final response = await DioClient.instance.get(
      ApiEndpoints.packages,
      queryParameters: q,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getPackageDetail(String id) async {
    final response = await DioClient.instance.get(
      ApiEndpoints.packageDetail(id),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getProducts({
    String? categoryId,
    String? search,
    String? sort,
    int? perPage,
  }) async {
    final q = <String, dynamic>{};
    if (categoryId != null) q['category_id'] = categoryId;
    if (search != null) q['search'] = search;
    if (sort != null) q['sort'] = sort;
    if (perPage != null) q['per_page'] = perPage;
    final response = await DioClient.instance.get(
      ApiEndpoints.products,
      queryParameters: q,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getProductDetail(String id) async {
    final response = await DioClient.instance.get(
      ApiEndpoints.productDetail(id),
    );
    return response.data as Map<String, dynamic>;
  }
}
