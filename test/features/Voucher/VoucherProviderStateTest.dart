import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Voucher/Presentation/Providers/VoucherProvider/VoucherProvider.dart';

void main() {
  group('voucher provider state', () {
    test('default state constructs & types correctly', () {
      final s = VoucherState();
      expect(s, isA<VoucherState>());
    });
  });
}