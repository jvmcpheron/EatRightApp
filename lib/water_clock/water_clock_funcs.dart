import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permission on Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,  // You can use different IDs for multiple notifications
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Timer? scheduledNotificationTimer;

  Future<void> scheduleNotification({required String title, required String body, required Duration duration}) async {
    // If there's an existing scheduled notification, cancel it
    scheduledNotificationTimer?.cancel();

    scheduledNotificationTimer = Timer(duration, () async {
      // Ensure the timer hasn't been canceled before showing the notification
      await showNotification(
        title: title,
        body: body,
      );
    });
  }

  Future<void> cancelNotification() async {
    // Cancel the previously scheduled notification if any
    scheduledNotificationTimer?.cancel();
    scheduledNotificationTimer = null;
  }

}
