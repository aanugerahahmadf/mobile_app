import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/cbir/presentation/providers/cbir_provider/cbir_provider.dart';

void main() {
  group('cbir provider state', () {
    test('default state constructs & types correctly', () {
      final s = CbirState();
      expect(s, isA<CbirState>());
    });
  });
}