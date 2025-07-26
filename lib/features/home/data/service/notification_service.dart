import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleBellNotifications({
    required String bell,
    required TimeOfDay start,
    required TimeOfDay end,
    required int intervalMinutes,
    required bool muteInSilent,
  }) async {
    await flutterLocalNotificationsPlugin.cancelAll(); // optional, clear old

    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      end.hour,
      end.minute,
    );

    String soundFileCheck(String bellName) {
      switch (bellName) {
        case 'Singing Bowl':
          return 'singing_bowl';
        case 'Ohm Bell':
          return 'ohm_bell';
        case 'Gong':
          return 'gong';
        default:
          return 'singing_bowl';
      }
    }

    final soundName = soundFileCheck(bell);
    int notificationId = 0;

    for (var time = startDateTime;
        time.isBefore(endDateTime);
        time = time.add(Duration(minutes: intervalMinutes))) {
      final tzDateTime = tz.TZDateTime.from(time, tz.local);
      if (tzDateTime.isBefore(tz.TZDateTime.now(tz.local))) continue;

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId++,
        "Mindfulness Bell",
        "Ringing the bell: $bell",
        tzDateTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'bell_channel',
            'Bell Notifications',
            importance: Importance.high,
            priority: Priority.high,
            playSound: !muteInSilent,
            enableVibration: true,
            sound: muteInSilent
                ? null
                : RawResourceAndroidNotificationSound(soundName),
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
        androidScheduleMode: AndroidScheduleMode.exact, // For Android 12+
      );
    }
  }
}
