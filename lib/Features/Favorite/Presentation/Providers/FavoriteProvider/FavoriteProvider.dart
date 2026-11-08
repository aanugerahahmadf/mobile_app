import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Data/FavoriteRepository/FavoriteRepository.dart';

final favoriteRepositoryProvider = Provider((ref) => FavoriteRepository());

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Favoritestate>(
  (ref) {
    return FavoriteNotifier(ref.read(favoriteRepositoryProvider));
  },
);

class Favoritestate {
  final List<Map<String, dynamic>> items;
  final bool loading;
  final String? error;

  const Favoritestate({
    this.items = const [],
    this.loading = false,
    this.error,
  });

  Favoritestate copyWith({
    List<Map<String, dynamic>>? items,
    bool? loading,
    String? error,
  }) {
    return Favoritestate(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class FavoriteNotifier extends StateNotifier<Favoritestate> {
  final FavoriteRepository _repo;
  FavoriteNotifier(this._repo) : super(const Favoritestate());

  Future<void> fetchFavorite() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.getFavorite();
      state = state.copyWith(items: items, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> toggle({String? catalogId}) async {
    try {
      await _repo.toggleFavorite(catalogId: catalogId);
      await fetchFavorite();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> remove(Map<String, dynamic> item) async {
    try {
      final catalogId = item['catalog_id']?.toString() ?? item['id']?.toString();
      if (catalogId != null) {
        await _repo.removeFromFavorite(catalogId);
      }
      await fetchFavorite();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

