import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  Future<void> initialize() async {
    try {
      const androidInitialize = AndroidInitializationSettings('@drawable/app_icon.png');
      const iOSInitialize = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initializationSettings = InitializationSettings(
        android: androidInitialize,
        iOS: iOSInitialize,
      );
      
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          print('Notification clicked');
        },
      );

      if (Platform.isAndroid) {
        final androidImplementation = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
            
        if (androidImplementation != null) {
          await androidImplementation.requestNotificationsPermission();
        }
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String channelId = 'default_channel',
    String channelName = 'Default Channel',
    String channelDescription = 'Default Channel Description',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}