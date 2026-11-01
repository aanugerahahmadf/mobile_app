import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Search/Presentation/Providers/SearchProvider/SearchProvider.dart';

void main() {
  group('search provider state', () {
    test('default state constructs & types correctly', () {
      final s = SearchState();
      expect(s, isA<SearchState>());
    });
  });
}
