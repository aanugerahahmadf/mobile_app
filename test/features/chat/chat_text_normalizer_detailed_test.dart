import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/chat/presentation/utils/chat_text_normalizer/chat_text_normalizer.dart';

void main() {
  group('ChatTextNormalizer.normalize - Basic', () {
    test('preserves LF separators', () {
      expect(
        ChatTextNormalizer.normalize('Baris satu\nBaris dua'),
        'Baris satu\nBaris dua',
      );
    });

    test('converts CRLF separators to LF', () {
      expect(
        ChatTextNormalizer.normalize('Baris satu\r\nBaris dua'),
        'Baris satu\nBaris dua',
      );
    });

    test('converts CR separators to LF', () {
      expect(
        ChatTextNormalizer.normalize('Baris satu\rBaris dua'),
        'Baris satu\nBaris dua',
      );
    });

    test(r'converts literal backslash-n separators', () {
      expect(
        ChatTextNormalizer.normalize(r'Baris satu\nBaris dua'),
        'Baris satu\nBaris dua',
      );
    });

    test('converts literal slash-n separators', () {
      expect(
        ChatTextNormalizer.normalize('Baris satu/nBaris dua'),
        'Baris satu\nBaris dua',
      );
    });

    test('converts mixed separators in one message', () {
      expect(
        ChatTextNormalizer.normalize(
          r'Satu\nDua/nTiga'
          '\r\nEmpat',
        ),
        'Satu\nDua\nTiga\nEmpat',
      );
    });

    test('removes excessive blank lines and surrounding whitespace', () {
      expect(
        ChatTextNormalizer.normalize('  Satu\n\n\n\nDua  '),
        'Satu\n\nDua',
      );
    });

    test('returns an empty string for empty input', () {
      expect(ChatTextNormalizer.normalize(''), isEmpty);
    });
  });

  group('ChatTextNormalizer.normalize - Edge Cases', () {
    // `normalize` menerima String non-nullable, jadi "null" tidak bisa
    // diuji di sini -- kompilasi sudah menolaknya lebih dulu. Yang diuji
    // adalah kontrak yang sebenarnya berlaku: input kosong tetap aman.
    test('input kosong tidak melempar exception', () {
      expect(() => ChatTextNormalizer.normalize(''), returnsNormally);
    });

    test('handles single newline', () {
      expect(ChatTextNormalizer.normalize('\n'), '\n');
    });

    test('handles multiple consecutive newlines', () {
      expect(ChatTextNormalizer.normalize('\n\n\n'), '\n\n');
    });

    test('handles text with only whitespace', () {
      expect(ChatTextNormalizer.normalize('   '), isEmpty);
    });

    test('handles text with only newlines', () {
      expect(ChatTextNormalizer.normalize('\n\n\n'), '\n\n');
    });

    test('handles very long text', () {
      final longText = 'Baris\n' * 1000;
      final result = ChatTextNormalizer.normalize(longText);
      expect(result, isNotEmpty);
      // Panjang tidak bertambah dan isi utuh: baris kosong di ujung memang
      // dipertahankan, jadi `\n` penutup tidak boleh ikut terpotong.
      expect(result.length, lessThanOrEqualTo(longText.length));
      expect(result, longText);
    });

    test('handles text with tabs', () {
      expect(
        ChatTextNormalizer.normalize('Satu\tDua'),
        'Satu\tDua',
      );
    });

    test('handles text with mixed tabs and newlines', () {
      expect(
        ChatTextNormalizer.normalize('Satu\t\nDua\t\nTiga'),
        'Satu\t\nDua\t\nTiga',
      );
    });

    test('handles Unicode characters', () {
      expect(
        ChatTextNormalizer.normalize('Halo\nDunia'),
        'Halo\nDunia',
      );
    });

    test('handles emoji', () {
      expect(
        ChatTextNormalizer.normalize('­ƒÿÇ\n­ƒÿü'),
        '­ƒÿÇ\n­ƒÿü',
      );
    });

    test('handles special characters', () {
      expect(
        ChatTextNormalizer.normalize('!@#\n\$%^'),
        '!@#\n\$%^',
      );
    });

    test('handles numbers', () {
      expect(
        ChatTextNormalizer.normalize('123\n456'),
        '123\n456',
      );
    });

    test('handles single character lines', () {
      expect(
        ChatTextNormalizer.normalize('a\nb\nc'),
        'a\nb\nc',
      );
    });

    test('handles empty lines in middle', () {
      expect(
        ChatTextNormalizer.normalize('Satu\n\nDua'),
        'Satu\n\nDua',
      );
    });

    test('handles leading newlines', () {
      expect(
        ChatTextNormalizer.normalize('\n\nSatu'),
        '\n\nSatu',
      );
    });

    test('handles trailing newlines', () {
      expect(
        ChatTextNormalizer.normalize('Satu\n\n'),
        'Satu\n\n',
      );
    });

    test('handles CRLF at start', () {
      expect(
        ChatTextNormalizer.normalize('\r\nSatu'),
        '\nSatu',
      );
    });

    test('handles CRLF at end', () {
      expect(
        ChatTextNormalizer.normalize('Satu\r\n'),
        'Satu\n',
      );
    });

    test('handles only CRLF', () {
      expect(
        ChatTextNormalizer.normalize('\r\n'),
        '\n',
      );
    });

    test('handles only CR', () {
      expect(
        ChatTextNormalizer.normalize('\r'),
        '\n',
      );
    });

    test('handles alternating separators', () {
      expect(
        ChatTextNormalizer.normalize('A\r\nB\rC\nD'),
        'A\nB\nC\nD',
      );
    });

    test('handles literal backslash-n at start', () {
      expect(
        ChatTextNormalizer.normalize(r'\nSatu'),
        '\nSatu',
      );
    });

    test('handles literal backslash-n at end', () {
      expect(
        ChatTextNormalizer.normalize(r'Satu\n'),
        'Satu\n',
      );
    });

    test('handles literal slash-n at start', () {
      expect(
        ChatTextNormalizer.normalize('/nSatu'),
        '\nSatu',
      );
    });

    test('handles literal slash-n at end', () {
      expect(
        ChatTextNormalizer.normalize('Satu/n'),
        'Satu\n',
      );
    });

    test('handles multiple literal backslash-n', () {
      expect(
        ChatTextNormalizer.normalize(r'Satu\nDua\nTiga'),
        'Satu\nDua\nTiga',
      );
    });

    test('handles multiple literal slash-n', () {
      expect(
        ChatTextNormalizer.normalize('Satu/nDua/nTiga'),
        'Satu\nDua\nTiga',
      );
    });

    test('handles mixed literal and actual newlines', () {
      expect(
        ChatTextNormalizer.normalize(r'Satu\nDua' '\nTiga'),
        'Satu\nDua\nTiga',
      );
    });

    test('preserves single blank line between paragraphs', () {
      expect(
        ChatTextNormalizer.normalize('Paragraf 1\n\nParagraf 2'),
        'Paragraf 1\n\nParagraf 2',
      );
    });

    test('collapses multiple blank lines to single', () {
      expect(
        ChatTextNormalizer.normalize('Paragraf 1\n\n\n\nParagraf 2'),
        'Paragraf 1\n\nParagraf 2',
      );
    });

    test('trims leading whitespace on first line', () {
      expect(
        ChatTextNormalizer.normalize('  Satu\nDua'),
        'Satu\nDua',
      );
    });

    test('trims trailing whitespace on last line', () {
      expect(
        ChatTextNormalizer.normalize('Satu\nDua  '),
        'Satu\nDua',
      );
    });

    test('trims whitespace on all lines', () {
      expect(
        ChatTextNormalizer.normalize('  Satu  \n  Dua  '),
        'Satu\nDua',
      );
    });
  });

  group('ChatTextNormalizer.normalize - Real World Scenarios', () {
    test('normalizes typical chat message', () {
      final input = 'Halo, apa kabar?\r\nBaik saja, terima kasih!';
      final expected = 'Halo, apa kabar?\nBaik saja, terima kasih!';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes multiline message with bullet points', () {
      final input = r'ÔÇó Poin 1\nÔÇó Poin 2\nÔÇó Poin 3';
      final expected = 'ÔÇó Poin 1\nÔÇó Poin 2\nÔÇó Poin 3';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with numbered list', () {
      final input = '1. Pertama\n2. Kedua\n3. Ketiga';
      final expected = '1. Pertama\n2. Kedua\n3. Ketiga';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with code block', () {
      final input = '```\ncode here\n```';
      final expected = '```\ncode here\n```';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with quotes', () {
      final input = '> Quote 1\n> Quote 2';
      final expected = '> Quote 1\n> Quote 2';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with links', () {
      final input = 'Check this\nhttps://example.com';
      final expected = 'Check this\nhttps://example.com';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with email', () {
      final input = 'Contact us\nuser@example.com';
      final expected = 'Contact us\nuser@example.com';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with phone number', () {
      final input = 'Call us\n+628123456789';
      final expected = 'Call us\n+628123456789';
      expect(ChatTextNormalizer.normalize(input), expected);
    });

    test('normalizes message with mixed content', () {
      final input = 'Halo!\r\n\nApa kabar?\n\nBaik saja!';
      final expected = 'Halo!\n\nApa kabar?\n\nBaik saja!';
      expect(ChatTextNormalizer.normalize(input), expected);
    });
  });
}
