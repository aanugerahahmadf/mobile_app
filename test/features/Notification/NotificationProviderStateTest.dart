import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Notification/Presentation/Providers/NotificationProvider/NotificationProvider.dart';

void main() {
  group('notification provider state', () {
    test('default state constructs & types correctly', () {
      final s = NotificationState();
      expect(s, isA<NotificationState>());
    });
  });
}