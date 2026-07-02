import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../api/api_endpoints.dart';
import '../api/dio_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final service = NotificationService.instance;
  await service._initLocalNotifications();
  service._showLocalNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'wedding_notifications',
    'Notifikasi Wedding',
    description: 'Notifikasi dari aplikasi Wedding Organizer',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    await _initLocalNotifications();
    await _setupFCM();
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _setupFCM() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    _fcmToken = await messaging.getToken();
    debugPrint('FCM Token: $_fcmToken');
    if (_fcmToken != null) {
      _registerToken(_fcmToken!);
    }

    messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      debugPrint('FCM Token refreshed: $token');
      _registerToken(token);
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpened(initialMessage);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await DioClient.instance.post(ApiEndpoints.registerFcmToken, data: {
        'token': token,
        'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
      });
    } catch (_) {}
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _showLocalNotification(message);
  }

  void _handleNotificationOpened(RemoteMessage message) {
    _navigateFromNotification(message);
  }

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      _navigateToRoute(payload);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;
    final route = data['route'] as String? ?? data['type'] as String? ?? '';

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    final iosDetails = const DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification?.title ?? 'Notifikasi',
      body: notification?.body ?? '',
      notificationDetails: details,
      payload: route,
    );
  }

  void _navigateFromNotification(RemoteMessage message) {
    final data = message.data;
    final route = data['route'] as String?;
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    String targetRoute;
    if (route != null && route.isNotEmpty) {
      targetRoute = route;
    } else if (type != null && id != null) {
      targetRoute = _mapTypeToRoute(type, id);
    } else {
      targetRoute = '/notifications';
    }

    _navigateToRoute(targetRoute);
  }

  void _navigateToRoute(String route) {
    final element = WidgetsBinding.instance.rootElement;
    if (element == null) return;
    final router = GoRouter.of(element);
    router.go(route);
  }

  String _mapTypeToRoute(String type, String id) {
    switch (type) {
      case 'order':
      case 'payment':
        return '/order/$id';
      case 'chat':
        return '/chat/$id';
      case 'package':
        return '/catalog/packages/$id';
      case 'product':
        return '/catalog/products/$id';
      case 'promo':
        return '/vouchers';
      default:
        return '/notifications';
    }
  }
}
