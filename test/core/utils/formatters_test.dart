import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/formatters/formatters.dart';

void main() {
  group('Formatters.currency', () {
    test('formats integer amount', () {
      final result = Formatters.currency(50000);
      expect(result, contains('Rp'));
      expect(result, contains('50.000'));
    });

    test('formats zero', () {
      final result = Formatters.currency(0);
      expect(result, contains('Rp 0'));
    });

    test('formats negative amount', () {
      final result = Formatters.currency(-5000);
      expect(result, contains('-'));
    });
  });

  group('Formatters.date', () {
    test('returns original string on invalid input', () {
      final result = Formatters.date('not-a-date');
      expect(result, equals('not-a-date'));
    });

    test('returns non-empty for valid date', () {
      final result = Formatters.date('2024-06-15');
      expect(result, isNotEmpty);
    });
  });

  group('Formatters.dateTime', () {
    test('returns non-empty for valid datetime', () {
      final result = Formatters.dateTime('2024-06-15T10:30:00');
      expect(result, isNotEmpty);
    });
  });

  group('Formatters.timeAgo', () {
    test('returns "Baru saja" for recent time', () {
      final now = DateTime.now().toIso8601String();
      final result = Formatters.timeAgo(now);
      expect(result, equals('Baru saja'));
    });

    test('returns original string on invalid input', () {
      final result = Formatters.timeAgo('invalid');
      expect(result, equals('invalid'));
    });
  });
}
