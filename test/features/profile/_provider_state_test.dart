import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/profile/presentation/providers/profile_provider/profile_provider.dart';

void main() {
  group('profile provider state', () {
    test('default state constructs & types correctly', () {
      final s = ProfileState();
      expect(s, isA<ProfileState>());
    });
  });
}