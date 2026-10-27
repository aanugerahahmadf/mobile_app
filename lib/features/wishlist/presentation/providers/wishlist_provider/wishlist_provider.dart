import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/wishlist_repository/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider((ref) => WishlistRepository());

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>(
  (ref) {
    return WishlistNotifier(ref.read(wishlistRepositoryProvider));
  },
);

class WishlistState {
  final List<Map<String, dynamic>> items;
  final bool loading;
  final String? error;

  const WishlistState({
    this.items = const [],
    this.loading = false,
    this.error,
  });

  WishlistState copyWith({
    List<Map<String, dynamic>>? items,
    bool? loading,
    String? error,
  }) {
    return WishlistState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
    );
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

  Future<void> toggle({String? catalogId}) async {
    try {
      await _repo.toggleWishlist(catalogId: catalogId);
      await fetchWishlist();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> remove(Map<String, dynamic> item) async {
    try {
      final catalogId = item['catalog_id']?.toString() ?? item['id']?.toString();
      if (catalogId != null) {
        await _repo.removeFromWishlist(catalogId);
      }
      await fetchWishlist();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
