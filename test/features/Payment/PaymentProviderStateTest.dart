import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Payment/Presentation/Providers/PaymentProvider/PaymentProvider.dart';

void main() {
  group('payment provider state', () {
    test('default state constructs & types correctly', () {
      final s = PaymentState();
      expect(s, isA<PaymentState>());
    });
  });
}