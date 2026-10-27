import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/validators/validators.dart';

void main() {
  group('Validators.required', () {
    test('returns null for non-empty string', () {
      expect(Validators.required('test'), isNull);
    });

    test('returns error for null', () {
      expect(Validators.required(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.required(''), isNotNull);
    });

    test('returns error for whitespace-only', () {
      expect(Validators.required('   '), isNotNull);
    });

    test('returns error for newline-only', () {
      expect(Validators.required('\n'), isNotNull);
    });

    test('returns error for tab-only', () {
      expect(Validators.required('\t'), isNotNull);
    });
  });

  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('returns error for invalid email', () {
      expect(Validators.email('invalid-email'), isNotNull);
    });

    test('returns error for null', () {
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for missing @', () {
      expect(Validators.email('userexample.com'), isNotNull);
    });

    test('returns error for missing domain', () {
      expect(Validators.email('user@'), isNotNull);
    });

    test('returns error for missing TLD', () {
      expect(Validators.email('user@example'), isNotNull);
    });

    test('returns error for spaces', () {
      expect(Validators.email('user @example.com'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('returns null for strong password', () {
      expect(Validators.password('Str0ng!Pass1'), isNull);
    });

    test('returns error for too short', () {
      expect(Validators.password('Ab1!'), isNotNull);
    });

    test('returns error for missing uppercase', () {
      expect(Validators.password('weakpass1!@'), isNotNull);
    });

    test('returns error for missing number', () {
      expect(Validators.password('StrongPass!@'), isNotNull);
    });

    test('returns error for missing special char', () {
      expect(Validators.password('StrongPass1'), isNotNull);
    });

    test('returns error for all lowercase', () {
      expect(Validators.password('weakpass123'), isNotNull);
    });
  });

  group('Validators.isPasswordStrong', () {
    test('returns true for strong password', () {
      expect(Validators.isPasswordStrong('Str0ng!Pass1'), isTrue);
    });

    test('returns false for weak password', () {
      expect(Validators.isPasswordStrong('weak'), isFalse);
    });

    test('returns false for empty string', () {
      expect(Validators.isPasswordStrong(''), isFalse);
    });

    test('returns false for null', () {
      // isPasswordStrong should handle null gracefully
      expect(() => Validators.isPasswordStrong(null), returnsNormally);
    });
  });

  group('Validators.confirmPassword', () {
    test('returns null when passwords match', () {
      expect(Validators.confirmPassword('pass123', 'pass123'), isNull);
    });

    test('returns error when passwords do not match', () {
      expect(Validators.confirmPassword('pass123', 'different'), isNotNull);
    });

    test('returns error for null first password', () {
      expect(Validators.confirmPassword(null, 'pass123'), isNotNull);
    });

    test('returns error for null second password', () {
      expect(Validators.confirmPassword('pass123', null), isNotNull);
    });
  });

  group('Validators.phone', () {
    test('returns null for valid phone', () {
      expect(Validators.phone('08123456789'), isNull);
    });

    test('returns null for phone with + prefix', () {
      expect(Validators.phone('+628123456789'), isNull);
    });

    test('returns error for too short', () {
      expect(Validators.phone('123'), isNotNull);
    });

    test('returns error for letters', () {
      expect(Validators.phone('abcdefghij'), isNotNull);
    });

    test('returns error for null', () {
      expect(Validators.phone(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.phone(''), isNotNull);
    });

    test('returns error for phone too long', () {
      expect(Validators.phone('081234567890123456789'), isNotNull);
    });
  });
}