abstract class WishlistRepository {
  Future<List<Map<String, dynamic>>> getWishlist();
  Future<void> toggleWishlist({String? packageId, String? catalogId});
  Future<void> removeFromWishlist(String id, {bool isCatalog = false});
}
