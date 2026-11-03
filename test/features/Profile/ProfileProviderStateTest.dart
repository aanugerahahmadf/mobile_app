import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Profile/Presentation/Providers/ProfileProvider/ProfileProvider.dart';

void main() {
  group('profile provider state', () {
    test('default state constructs & types correctly', () {
      final s = ProfileState();
      expect(s, isA<ProfileState>());
    });
  });
}