import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/voucher/presentation/providers/voucher_provider/voucher_provider.dart';

void main() {
  group('voucher provider state', () {
    test('default state constructs & types correctly', () {
      final s = VoucherState();
      expect(s, isA<VoucherState>());
    });
  });
}