import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsRepository {
  // this will be used as notification channel id
  static const notificationChannelId = 'my_foreground';

  // this will be used for notification id, So you can update your custom notification with this id.
  static const notificationPermanentId = 888;

  Future<void> initChannelNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Create a permanent notification
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high, // importance must be at low or higher level
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<int> createNotification(bool isPermanent, DateTime? startTime) async {
    int notificationId = Random().nextInt(1000);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (isPermanent) {
      flutterLocalNotificationsPlugin.show(
        notificationPermanentId,
        '2OSS Background Service',
        'Démarré depuis: $startTime',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    } else {
      // Create a temporary notification
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              notificationChannelId, 'Simple Notification',
              channelDescription:
                  'This channel is used for random notifications',
              importance: Importance.high,
              priority: Priority.high,
              ongoing: true,
              autoCancel: true,
              timeoutAfter: 60000,
              onlyAlertOnce: false,
              playSound: true,
              enableVibration: true,
              enableLights: true,
              showWhen: true,
              icon: 'ic_bg_service_small');

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          notificationId,
          'Tentative de connexion',
          'Vous essayez de vous connecter ?',
          platformChannelSpecifics);
    }

    // Create a NotificationInfo
    return notificationId;
  }
}