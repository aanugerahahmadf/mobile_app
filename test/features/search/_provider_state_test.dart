import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/search/presentation/providers/search_provider/search_provider.dart';

void main() {
  group('search provider state', () {
    test('default state constructs & types correctly', () {
      final s = SearchState();
      expect(s, isA<SearchState>());
    });
  });
}