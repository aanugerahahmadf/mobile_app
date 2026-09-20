import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/wishlist/presentation/providers/wishlist_provider/wishlist_provider.dart';

void main() {
  group('wishlist provider state', () {
    test('default state constructs & types correctly', () {
      final s = WishlistState();
      expect(s, isA<WishlistState>());
    });
  });
}