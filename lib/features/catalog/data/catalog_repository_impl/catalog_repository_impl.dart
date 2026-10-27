import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  @override
  Future<Map<String, dynamic>> getCatalog({
    String? categoryId,
    String? search,
    String? sort,
    String? sortBy,
    String? sortDirection,
    int? perPage,
  }) async {
    final q = <String, dynamic>{};
    if (categoryId != null) q['category_id'] = categoryId;
    if (search != null) q['search'] = search;
    // Backend menerima dua bentuk sorting: `sort` (legacy, mis. `price_asc`)
    // dan pasangan `sort_by` + `sort_direction` yang lebih eksplisit. Keduanya
    // diteruskan apa adanya supaya pemanggil lama tidak ikut berubah.
    if (sort != null) q['sort'] = sort;
    if (sortBy != null) q['sort_by'] = sortBy;
    if (sortDirection != null) q['sort_direction'] = sortDirection;
    if (perPage != null) q['per_page'] = perPage;
    final response = await DioClient.instance.get(
      ApiEndpoints.catalog,
      queryParameters: q,
    );
    return _normalizeCatalogList(response.data);
  }

  @override
  Future<Map<String, dynamic>> getCatalogDetail(String id) async {
    final response = await DioClient.instance.get(
      ApiEndpoints.catalogDetail(id),
    );
    return _normalizeCatalogDetail(response.data);
  }

  @override
  Future<Map<String, dynamic>> getCatalogTiers(String id) async {
    final response = await DioClient.instance.get(
      ApiEndpoints.catalogTiers(id),
    );
    return _normalizeCatalogTiers(response.data);
  }

  /// The Laravel controller delegates to GraphQL. Older deployments return
  /// `{catalogs: ...}` / `{catalog: ...}`, while REST-wrapped deployments
  /// return `{data: ...}`. Keep that transport detail out of the UI so the
  /// mobile catalog always consumes one stable shape.
  Map<String, dynamic> _normalizeCatalogList(dynamic raw) {
    final root = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final envelope = root['data'] is Map
        ? Map<String, dynamic>.from(root['data'] as Map)
        : root;
    final payload = envelope['catalogs'] ?? root['catalogs'];
    if (payload is Map) {
      final catalogs = payload['data'] is List ? payload['data'] : payload;
      return {
        'status': 'success',
        'data': catalogs is List ? catalogs : <dynamic>[],
        'pagination': payload['paginatorInfo'] ?? payload['pagination'],
      };
    }
    if (envelope['data'] is List) return root;
    return {'status': 'success', 'data': <dynamic>[]};
  }

  Map<String, dynamic> _normalizeCatalogDetail(dynamic raw) {
    final root = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final envelope = root['data'] is Map
        ? Map<String, dynamic>.from(root['data'] as Map)
        : root;
    final catalog = envelope['catalog'] ?? root['catalog'];
    if (catalog is Map) return {'status': 'success', 'data': Map<String, dynamic>.from(catalog)};
    if (envelope['id'] != null) return {'status': 'success', 'data': envelope};
    return {'status': 'error', 'data': null};
  }

  Map<String, dynamic> _normalizeCatalogTiers(dynamic raw) {
    final detail = _normalizeCatalogDetail(raw);
    final data = detail['data'];
    if (data is Map && data['tiers'] is List) {
      return {'status': 'success', 'data': data['tiers']};
    }
    return {'status': 'success', 'data': <dynamic>[]};
  }
}
