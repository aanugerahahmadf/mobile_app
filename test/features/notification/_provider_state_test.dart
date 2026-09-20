import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/notification/presentation/providers/notification_provider/notification_provider.dart';

void main() {
  group('notification provider state', () {
    test('default state constructs & types correctly', () {
      final s = NotificationState();
      expect(s, isA<NotificationState>());
    });
  });
}