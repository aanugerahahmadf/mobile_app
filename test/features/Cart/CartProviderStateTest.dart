import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Cart/Presentation/Providers/CartProvider/CartProvider.dart';

void main() {
  group('cart provider state', () {
    test('default state constructs & types correctly', () {
      final s = CartState();
      expect(s, isA<CartState>());
    });
  });
}