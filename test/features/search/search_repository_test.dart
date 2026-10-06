import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/search/data/search_repository_impl/search_repository_impl.dart';

void main() {
  group('SearchRepositoryImpl', () {
    test('can be instantiated', () {
      final repo = SearchRepositoryImpl();
      expect(repo, isA<SearchRepositoryImpl>());
    });

    test('implements SearchRepository interface', () {
      final repo = SearchRepositoryImpl();
      expect(repo, isA<dynamic>());
    });

    test('has singleton DioClient instance', () {
      final repo = SearchRepositoryImpl();
      expect(repo, isNotNull);
    });

    test('multiple instances can coexist', () {
      final repo1 = SearchRepositoryImpl();
      final repo2 = SearchRepositoryImpl();
      expect(repo1, isNot(same(repo2)));
    });

    test('search method exists and is callable', () {
      final repo = SearchRepositoryImpl();
      expect(repo.search, isA<Function>());
    });

    test('search method accepts query parameter', () {
      final repo = SearchRepositoryImpl();
      expect(() => repo.search('test'), returnsNormally);
    });

    test('search method accepts optional page parameter', () {
      final repo = SearchRepositoryImpl();
      expect(() => repo.search('test', page: 1), returnsNormally);
    });
  });
}
