import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Cbir/Presentation/Providers/CbirProvider/CbirProvider.dart';

void main() {
  group('cbir provider state', () {
    test('default state constructs & types correctly', () {
      final s = CbirState();
      expect(s, isA<CbirState>());
    });
  });
}