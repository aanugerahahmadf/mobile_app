import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Order/Presentation/Providers/OrderProvider/OrderProvider.dart';

void main() {
  group('order provider state', () {
    test('default state constructs & types correctly', () {
      final s = OrderState();
      expect(s, isA<OrderState>());
    });
  });
}