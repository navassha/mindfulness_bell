import 'package:flutter_local_notifications/flutter_local_notifications.dart';

requestingNotificationPErmission() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // requesting permission for alarm
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // test alarm notification with sound
  await flutterLocalNotificationsPlugin.show(
    0,
    'Testing the Bell',
    'test notification',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'bell_channel',
        'Bell Channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('ohm_bell'),
      ),
    ),
  );
}
