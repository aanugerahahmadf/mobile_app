abstract class CatalogRepository {
  Future<Map<String, dynamic>> getCatalog({
    String? categoryId,
    String? search,
    String? sort,
    String? sortBy,
    String? sortDirection,
    int? perPage,
  });
  Future<Map<String, dynamic>> getCatalogDetail(String id);
  Future<Map<String, dynamic>> getCatalogTiers(String id);
}
