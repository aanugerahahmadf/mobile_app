import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/search/data/models/search_result/search_result.dart';
import 'package:mobile_app/features/search/data/models/search_suggestion/search_suggestion.dart';
import 'package:mobile_app/features/search/domain/search_repository/search_repository.dart';
import 'package:mobile_app/features/search/presentation/providers/search_provider/search_provider.dart';

class _FakeSearchRepository implements SearchRepository {
  SearchResult? _resultToReturn;
  String? _errorToThrow;
  int _callCount = 0;
  String? _lastQuery;
  int? _lastPage;

  @override
  Future<SearchResult> search(String query, {int page = 1}) async {
    _callCount++;
    _lastQuery = query;
    _lastPage = page;
    if (_errorToThrow != null) throw Exception(_errorToThrow);
    return _resultToReturn ?? const SearchResult();
  }

  /// Memindahkan fake ke mode "sukses" atau "gagal".
  ///
  /// Keduanya saling membersihkan status lawan. Kalau tidak, `setResult()`
  /// setelah `setError()` hanya mengubah nilai balik sementara `_errorToThrow`
  /// masih terisi, sehingga panggilan berikutnya tetap melempar dan test
  /// "search clears previous error" gagal untuk alasan yang salah.
  void setResult(SearchResult result) {
    _resultToReturn = result;
    _errorToThrow = null;
  }

  void setError(String error) {
    _errorToThrow = error;
    _resultToReturn = null;
  }

  int get callCount => _callCount;
  String? get lastQuery => _lastQuery;
  int? get lastPage => _lastPage;
}

void main() {
  group('SearchState', () {
    test('default constructor', () {
      const state = SearchState();
      expect(state.results, isNull);
      expect(state.loading, isFalse);
      expect(state.error, isNull);
    });

    test('constructor with all fields', () {
      final results = SearchResult(items: [
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 1,
          name: 'Test',
          routePath: '/test',
        ),
      ]);
      final state = SearchState(
        results: results,
        loading: true,
        error: 'Some error',
      );
      expect(state.results, isNotNull);
      expect(state.results!.items.length, 1);
      expect(state.loading, isTrue);
      expect(state.error, 'Some error');
    });

    test('copyWith updates fields correctly', () {
      const initialState = SearchState();
      final results = SearchResult(items: [
        const SearchSuggestion(
          type: SuggestionType.products,
          id: 2,
          name: 'Product',
          routePath: '/product',
        ),
      ]);

      final newState = initialState.copyWith(
        results: results,
        loading: true,
      );

      expect(newState.results, isNotNull);
      expect(newState.loading, isTrue);
      expect(newState.error, isNull);
    });

    test('copyWith preserves existing values when not provided', () {
      final results = SearchResult(items: [
        const SearchSuggestion(
          type: SuggestionType.categories,
          id: 3,
          name: 'Category',
          routePath: '/category',
        ),
      ]);
      final initialState = SearchState(
        results: results,
        loading: true,
        error: 'Error',
      );

      final newState = initialState.copyWith();

      expect(newState.results, equals(results));
      expect(newState.loading, isTrue);
      expect(newState.error, 'Error');
    });

    test('copyWith can clear error by setting it explicitly', () {
      const initialState = SearchState(error: 'Some error');
      final newState = initialState.copyWith(error: null);
      expect(newState.error, isNull);
    });
  });

  group('SearchNotifier', () {
    late _FakeSearchRepository fakeRepo;
    late SearchNotifier notifier;

    setUp(() {
      fakeRepo = _FakeSearchRepository();
      notifier = SearchNotifier(fakeRepo);
    });

    test('initial state is correct', () {
      expect(notifier.state.results, isNull);
      expect(notifier.state.loading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('search sets loading true initially', () async {
      fakeRepo.setResult(const SearchResult());
      final future = notifier.search('test');
      expect(notifier.state.loading, isTrue);
      await future;
    });

    test('search updates state with results on success', () async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 1,
          name: 'Paket Wedding',
          routePath: '/catalog/packages/1',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));

      await notifier.search('wedding');

      expect(notifier.state.loading, isFalse);
      expect(notifier.state.error, isNull);
      expect(notifier.state.results, isNotNull);
      expect(notifier.state.results!.items.length, 1);
      expect(notifier.state.results!.items.first.name, 'Paket Wedding');
    });

    test('search sets error on failure', () async {
      fakeRepo.setError('Network error');

      await notifier.search('test');

      expect(notifier.state.loading, isFalse);
      expect(notifier.state.error, isNotNull);
      expect(notifier.state.error, contains('Network error'));
    });

    test('search passes correct parameters to repository', () async {
      fakeRepo.setResult(const SearchResult());

      await notifier.search('wedding package', page: 2);

      expect(fakeRepo.lastQuery, 'wedding package');
      expect(fakeRepo.lastPage, 2);
    });

    test('search uses default page 1', () async {
      fakeRepo.setResult(const SearchResult());

      await notifier.search('test');

      expect(fakeRepo.lastPage, 1);
    });

    test('multiple searches update state correctly', () async {
      fakeRepo.setResult(const SearchResult(items: []));
      await notifier.search('first');
      expect(fakeRepo.callCount, 1);

      final items = [
        const SearchSuggestion(
          type: SuggestionType.products,
          id: 1,
          name: 'Product',
          routePath: '/catalog/products/1',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await notifier.search('second');

      expect(fakeRepo.callCount, 2);
      expect(notifier.state.results!.items.length, 1);
    });

    test('search clears previous error on new search', () async {
      fakeRepo.setError('First error');
      await notifier.search('first');
      expect(notifier.state.error, isNotNull);

      fakeRepo.setResult(const SearchResult());
      await notifier.search('second');
      expect(notifier.state.error, isNull);
    });

    test('search with empty result', () async {
      fakeRepo.setResult(const SearchResult(items: []));

      await notifier.search('nonexistent');

      expect(notifier.state.loading, isFalse);
      expect(notifier.state.error, isNull);
      expect(notifier.state.results, isNotNull);
      expect(notifier.state.results!.items, isEmpty);
    });
  });
}
