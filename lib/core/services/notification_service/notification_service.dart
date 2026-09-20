import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_endpoints/api_endpoints.dart';
import '../../api/dio_client/dio_client.dart';
import '../../utils/notification_prefs/notification_prefs.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final type = message.data['type'] as String?;
  if (type != null) {
    final allowed = await NotificationPrefs.shouldShowNotification(type);
    if (!allowed) return;
  }
  final service = NotificationService.instance;
  await service._initLocalNotifications();
  await service._loadSoundPref();
  service._showLocalNotification(message);
}

bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

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

  static const AndroidNotificationChannel _securityChannel =
      AndroidNotificationChannel(
        'security_notifications',
        'Notifikasi Keamanan',
        description: 'Notifikasi verifikasi login dan keamanan akun',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

  String? _fcmToken;
  bool _soundEnabled = true;

  static const _secureStorage = FlutterSecureStorage();

  void Function(String route)? onNavigate;

  String? get fcmToken => _fcmToken;

  /// Re-registers the current FCM token with the backend. Safe to call after
  /// login/logout; it is a no-op when the user has no FCM token or the app is
  /// not authenticated yet (avoids needless 401 calls).
  Future<void> syncFcmToken() async {
    if (_fcmToken == null) return;
    await _registerToken(_fcmToken!);
  }

  Future<void> initialize() async {
    await _loadSoundPref();
    await _initLocalNotifications();
    await _setupFCM();
  }

  Future<void> _loadSoundPref() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('notif_sound') ?? true;
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const windowsSettings = WindowsInitializationSettings(
      appName: 'Wedding Flower Decorations',
      appUserModelId: 'com.wedding.flowerdecorations',
      guid: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      windows: windowsSettings,
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_securityChannel);
  }

  Future<void> _setupFCM() async {
    if (!_isMobile) return;
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
  }

  Future<void> handleInitialMessage() async {
    if (!_isMobile) return;
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationOpened(initialMessage);
      });
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      final authToken = await _secureStorage.read(key: 'auth_token');
      if (authToken == null || authToken.isEmpty) {
        // Not logged in yet: the endpoint requires auth, so skip and retry
        // later via syncFcmToken() once the user authenticates.
        return;
      }
      final deviceName = defaultTargetPlatform.name;

      await DioClient.instance.post(
        ApiEndpoints.registerFcmToken,
        data: {
          'token': token,
          'platform': defaultTargetPlatform == TargetPlatform.iOS
              ? 'ios'
              : 'android',
          'device_name': deviceName,
        },
      );
    } catch (_) {}
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'] as String?;

    if (type != null) {
      final allowed = await NotificationPrefs.shouldShowNotification(type);
      if (!allowed) return;
    }

    await _loadSoundPref();
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
    final route = data['route'] as String?;
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    String payload;
    if (route != null && route.isNotEmpty) {
      payload = route;
    } else if (type != null && id != null) {
      payload = _mapTypeToRoute(type, id);
    } else if (type != null) {
      payload = type;
    } else {
      payload = '/notifications';
    }

    final isSecurity = type == 'security';
    final channelId = isSecurity ? _securityChannel.id : _channel.id;
    final channelName = isSecurity ? _securityChannel.name : _channel.name;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: isSecurity
          ? _securityChannel.description
          : _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: _soundEnabled,
      enableVibration: _soundEnabled,
      fullScreenIntent: isSecurity,
    );
    final iosDetails = DarwinNotificationDetails(presentSound: _soundEnabled);
    final windowsDetails = WindowsNotificationDetails(
      subtitle: notification?.body ?? '',
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      windows: windowsDetails,
    );

    _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification?.title ?? 'Notifikasi',
      body: notification?.body ?? '',
      notificationDetails: details,
      payload: payload,
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
    final cb = onNavigate;
    if (cb != null) {
      cb(route);
    }
  }

  String _mapTypeToRoute(String type, String id) {
    switch (type) {
      case 'order':
      case 'payment':
        return '/order/$id';
      case 'chat':
      case 'message':
      case 'new_message':
        return '/chat/$id';
      case 'package':
        return '/catalog/packages/$id';
      case 'product':
        return '/catalog/products/$id';
      case 'promo':
        return '/vouchers';
      case 'review':
        return '/my-reviews';
      default:
        return '/notifications';
    }
  }
}
