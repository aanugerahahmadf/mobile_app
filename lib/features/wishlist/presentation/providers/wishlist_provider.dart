import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider((ref) => WishlistRepository());

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier(ref.read(wishlistRepositoryProvider));
});

class WishlistState {
  final List<Map<String, dynamic>> items;
  final bool loading;
  final String? error;

  const WishlistState({this.items = const [], this.loading = false, this.error});

  WishlistState copyWith({List<Map<String, dynamic>>? items, bool? loading, String? error}) {
    return WishlistState(items: items ?? this.items, loading: loading ?? this.loading, error: error);
  }
}

class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepository _repo;
  WishlistNotifier(this._repo) : super(const WishlistState());

  Future<void> fetchWishlist() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.getWishlist();
      state = state.copyWith(items: items, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> toggle({String? packageId, String? productId}) async {
    try {
      await _repo.toggleWishlist(packageId: packageId, productId: productId);
      await fetchWishlist();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> remove(Map<String, dynamic> item) async {
    try {
      final isProduct = item['resource_type'] == 'product';
      final itemId = isProduct
          ? item['product_id']?.toString()
          : item['package_id']?.toString();
      if (itemId != null) await _repo.removeFromWishlist(itemId, isProduct: isProduct);
      await fetchWishlist();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
