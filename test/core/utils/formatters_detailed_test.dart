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

    test('formats large amount', () {
      final result = Formatters.currency(1000000);
      expect(result, contains('1.000.000'));
    });

    test('formats very large amount', () {
      final result = Formatters.currency(1000000000);
      expect(result, contains('1.000.000.000'));
    });

    test('formats single digit', () {
      final result = Formatters.currency(5);
      expect(result, contains('5'));
    });

    test('formats amount with one thousand separator', () {
      final result = Formatters.currency(1500);
      expect(result, contains('1.500'));
    });

    test('formats amount with two thousand separators', () {
      final result = Formatters.currency(1500000);
      expect(result, contains('1.500.000'));
    });

    test('formats amount with three thousand separators', () {
      final result = Formatters.currency(1500000000);
      expect(result, contains('1.500.000.000'));
    });

    test('formats max int value', () {
      final result = Formatters.currency(2147483647);
      expect(result, contains('2.147.483.647'));
    });

    test('formats negative large amount', () {
      final result = Formatters.currency(-1000000);
      // NumberFormat.currency menaruh tanda minus SEBELUM simbol mata uang
      // ("-Rp 1.000.000"), bukan setelahnya. Ekspektasi lama "-1.000.000"
      // tidak pernah cocok dengan output Intl yang benar.
      expect(result, startsWith('-'));
      expect(result, contains('1.000.000'));
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

    // Formatters.date memakai pola 'dd MMM yyyy' dengan locale 'id', jadi
    // hasilnya "15 Jun 2024" — bukan "15/06/2024". Ekspektasi test lama
    // (/dd/MM/yyyy) hanya "kebetulan" tidak gagal sebelum ini karena
    // initializeDateFormatting() belum dipanggil, sehingga DateFormat
    // melempar dan kode jatuh ke string ISO mentah.
    test('formats date in correct format', () {
      final result = Formatters.date('2024-06-15');
      expect(result, equals('15 Jun 2024'));
    });

    test('formats date with single digit day', () {
      final result = Formatters.date('2024-06-05');
      expect(result, contains('05'));
    });

    test('formats date with localised month name', () {
      final result = Formatters.date('2024-06-15');
      expect(result, contains('Jun'));
    });

    test('formats date with double digit day', () {
      expect(Formatters.date('2024-12-25'), equals('25 Des 2024'));
    });

    test('handles empty string', () {
      final result = Formatters.date('');
      expect(result, isNotNull);
    });

    test('formats valid date strings', () {
      // Test that valid dates return formatted strings, not null
      final result = Formatters.date('2024-06-15');
      expect(result, isNotNull);
      expect(result, isA<String>());
    });
  });

  group('Formatters.dateTime', () {
    test('returns non-empty for valid datetime', () {
      final result = Formatters.dateTime('2024-06-15T10:30:00');
      expect(result, isNotEmpty);
    });

    test('formats datetime correctly', () {
      final result = Formatters.dateTime('2024-06-15T10:30:00');
      expect(result, contains('15 Jun 2024'));
      expect(result, contains('10:30'));
    });

    test('formats datetime with single digit hour', () {
      final result = Formatters.dateTime('2024-06-15T05:30:00');
      expect(result, contains('05:30'));
    });

    test('formats datetime with single digit minute', () {
      final result = Formatters.dateTime('2024-06-15T10:05:00');
      expect(result, contains('10:05'));
    });

    test('handles invalid datetime', () {
      final result = Formatters.dateTime('invalid');
      expect(result, isNotNull);
    });

    test('handles empty string', () {
      final result = Formatters.dateTime('');
      expect(result, isNotNull);
    });

    test('handles datetime with milliseconds', () {
      final result = Formatters.dateTime('2024-06-15T10:30:00.000');
      expect(result, isNotEmpty);
    });

    test('handles datetime with timezone', () {
      final result = Formatters.dateTime('2024-06-15T10:30:00+07:00');
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

    test('returns minutes ago for 5 minutes ago', () {
      final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
      final result = Formatters.timeAgo(fiveMinutesAgo.toIso8601String());
      expect(result, contains('menit'));
    });

    test('returns hours ago for 2 hours ago', () {
      final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2));
      final result = Formatters.timeAgo(twoHoursAgo.toIso8601String());
      expect(result, contains('jam'));
    });

    test('returns days ago for 3 days ago', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final result = Formatters.timeAgo(threeDaysAgo.toIso8601String());
      expect(result, contains('hari'));
    });

    test('returns weeks ago for 2 weeks ago', () {
      final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));
      final result = Formatters.timeAgo(twoWeeksAgo.toIso8601String());
      expect(result, contains('minggu'));
    });

    test('returns months ago for 2 months ago', () {
      final twoMonthsAgo = DateTime.now().subtract(const Duration(days: 60));
      final result = Formatters.timeAgo(twoMonthsAgo.toIso8601String());
      expect(result, contains('bulan'));
    });

    test('returns years ago for 2 years ago', () {
      final twoYearsAgo = DateTime.now().subtract(const Duration(days: 730));
      final result = Formatters.timeAgo(twoYearsAgo.toIso8601String());
      expect(result, contains('tahun'));
    });

    test('handles empty string', () {
      final result = Formatters.timeAgo('');
      expect(result, isNotNull);
    });

    test('handles future date', () {
      final futureDate = DateTime.now().add(const Duration(hours: 1));
      final result = Formatters.timeAgo(futureDate.toIso8601String());
      expect(result, isNotNull);
    });

    test('returns non-null for valid input', () {
      final result = Formatters.timeAgo(DateTime.now().toIso8601String());
      expect(result, isNotNull);
      expect(result, isA<String>());
    });
  });

  group('Formatters.imageUrl', () {
    test('returns valid URL for valid input', () {
      final result = Formatters.imageUrl('https://example.com/image.jpg');
      expect(result, isNotNull);
      expect(result, startsWith('http'));
    });

    test('handles relative URL', () {
      final result = Formatters.imageUrl('/images/test.jpg');
      expect(result, isNotNull);
    });

    test('handles empty string', () {
      final result = Formatters.imageUrl('');
      expect(result, isNotNull);
    });

    test('returns non-null for valid input', () {
      final result = Formatters.imageUrl('https://example.com/image.jpg');
      expect(result, isNotNull);
      expect(result, isA<String>());
    });
  });
}
