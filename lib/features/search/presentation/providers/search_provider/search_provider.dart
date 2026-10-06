import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/search_result/search_result.dart';
import '../../../data/search_repository_impl/search_repository_impl.dart';
import '../../../domain/search_repository/search_repository.dart';

class SearchState {
  final SearchResult? results;
  final bool loading;
  final String? error;

  const SearchState({this.results, this.loading = false, this.error});

  /// Sentinel untuk membedakan "argumen tidak diberikan" dari "nilai eksplisit
  /// null". Tanpa ini `copyWith(error: null)` tidak bisa dipakai untuk
  /// membersihkan error, karena `null` selalu berarti "tidak diberikan".
  static const Object _unset = Object();

  SearchState copyWith({
    SearchResult? results,
    bool? loading,
    Object? error = _unset,
  }) {
    return SearchState(
      results: results ?? this.results,
      loading: loading ?? this.loading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repository;
  SearchNotifier(this._repository) : super(const SearchState());

  Future<void> search(String query, {int page = 1}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final results = await _repository.search(query, page: page);
      // `error: null` eksplisit: pencarian yang berhasil harus ikut
      // membersihkan error dari percobaan sebelumnya.
      state = state.copyWith(results: results, loading: false, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(SearchRepositoryImpl());
});
