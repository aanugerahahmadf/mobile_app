import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/search/data/models/search_result/search_result.dart';
import 'package:mobile_app/features/search/data/models/search_suggestion/search_suggestion.dart';

void main() {
  group('SearchResult', () {
    test('const constructor with default items', () {
      const result = SearchResult();
      expect(result.items, isEmpty);
    });

    test('constructor with items', () {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.catalog,
          id: 1,
          name: 'Test',
          routePath: '/test',
        ),
      ];
      final result = SearchResult(items: items);
      expect(result.items.length, 1);
      expect(result.items.first.name, 'Test');
    });
  });

  group('SearchResult.fromJson', () {
    test('parses empty json', () {
      final result = SearchResult.fromJson({});
      expect(result.items, isEmpty);
    });

    test('parses packages correctly', () {
      final json = {
        'packages': [
          {'id': 1, 'name': 'Paket A'},
          {'id': 2, 'name': 'Paket B'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 2);
      expect(result.items[0].type, SuggestionType.catalog);
      expect(result.items[0].name, 'Paket A');
      expect(result.items[1].name, 'Paket B');
    });

    test('parses catalogs correctly', () {
      final json = {
        'catalogs': [
          {'id': 3, 'name': 'Catalog A'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.catalog);
    });

    test('parses categories correctly', () {
      final json = {
        'categories': [
          {'id': 4, 'name': 'Category A'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.categories);
    });

    test('parses vouchers correctly', () {
      final json = {
        'vouchers': [
          {'id': 5, 'code': 'VOUCHER1'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.vouchers);
    });

    test('parses orders correctly', () {
      final json = {
        'orders': [
          {'id': 6, 'order_number': 'ORD-001'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.orders);
    });

    test('parses reviews correctly', () {
      final json = {
        'reviews': [
          {'id': 7, 'comment': 'Great'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.reviews);
    });

    test('parses terms correctly', () {
      final json = {
        'terms': [
          {'id': 8, 'name': 'Terms'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.terms);
    });

    test('parses privacy correctly', () {
      final json = {
        'privacy': [
          {'id': 9, 'name': 'Privacy'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.privacy);
    });

    test('parses helps correctly', () {
      final json = {
        'helps': [
          {'id': 10, 'name': 'Help'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.helps);
    });

    test('parses histories correctly', () {
      final json = {
        'histories': [
          {'id': 11, 'reference_number': 'HIST-001'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.histories);
    });

    test('parses wedding_policy correctly', () {
      final json = {
        'wedding_policy': [
          {'id': 12, 'name': 'Policy'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].type, SuggestionType.weddingPolicy);
    });

    test('ignores unknown result keys', () {
      final json = {
        'unknown_key': [
          {'id': 13, 'store_name': 'Unknown A'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items, isEmpty);
    });

    test('parses multiple types at once', () {
      final json = {
        'packages': [
          {'id': 1, 'name': 'Paket A'},
        ],
        'catalogs': [
          {'id': 2, 'name': 'Catalog A'},
        ],
        'categories': [
          {'id': 3, 'name': 'Category A'},
        ],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 3);
    });

    test('handles null data gracefully', () {
      final json = {'data': null};
      final result = SearchResult.fromJson(json);
      expect(result.items, isEmpty);
    });

    test('handles missing type keys gracefully', () {
      final json = {'packages': null, 'catalogs': []};
      final result = SearchResult.fromJson(json);
      expect(result.items, isEmpty);
    });

    test('handles data wrapper correctly', () {
      final json = {
        'data': {
          'packages': [
            {'id': 1, 'name': 'Paket A'},
          ],
        },
      };
      final result = SearchResult.fromJson(json);
      expect(result.items.length, 1);
      expect(result.items[0].name, 'Paket A');
    });

    test('handles empty lists for all types', () {
      final json = {
        'packages': [],
        'catalogs': [],
        'categories': [],
        'vouchers': [],
        'orders': [],
        'reviews': [],
        'terms': [],
        'privacy': [],
        'helps': [],
        'histories': [],
        'wedding_policy': [],
      };
      final result = SearchResult.fromJson(json);
      expect(result.items, isEmpty);
    });
  });
}
