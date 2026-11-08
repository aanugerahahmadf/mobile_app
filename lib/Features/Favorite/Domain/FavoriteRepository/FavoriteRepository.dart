abstract class FavoriteRepository {
  Future<List<Map<String, dynamic>>> getFavorite();
  Future<void> toggleFavorite({String? packageId, String? catalogId});
  Future<void> removeFromFavorite(String id, {bool isCatalog = false});
}
