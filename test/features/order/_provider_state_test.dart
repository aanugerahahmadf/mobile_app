import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/order/presentation/providers/order_provider/order_provider.dart';

void main() {
  group('order provider state', () {
    test('default state constructs & types correctly', () {
      final s = OrderState();
      expect(s, isA<OrderState>());
    });
  });
}