import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/history/presentation/providers/history_provider.dart';

void main() {
  group('history provider state', () {
    test('default state constructs & types correctly', () {
      final s = HistoryState();
      expect(s, isA<HistoryState>());
    });
  });
}