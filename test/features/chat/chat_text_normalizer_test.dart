import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/chat/presentation/utils/chat_text_normalizer/chat_text_normalizer.dart';

void main() {
  group('ChatTextNormalizer.normalize', () {
    test('preserves LF separators', () {
      expect(
        ChatTextNormalizer.normalize('Baris satu\nBaris dua'),
        'Baris satu\nBaris dua',
      );
    });

    test('converts CRLF and CR separators to LF', () {
      expect(
        ChatTextNormalizer.normalize('Baris satu\r\nBaris dua\rBaris tiga'),
        'Baris satu\nBaris dua\nBaris tiga',
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
}
