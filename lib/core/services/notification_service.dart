import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 1. Request Permission (iOS/Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Initialize Local Notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );

    // 3. Listen to FCM Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM Message received in foreground: ${message.notification?.title}');
      if (message.notification != null) {
        showLocalNotification(
          title: message.notification!.title ?? 'SidangKu',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sidangku_channel',
      'SidangKu Notifications',
      channelDescription: 'Pemberitahuan status sidang dan revisi',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }
}
