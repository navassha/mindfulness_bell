import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
// initlizing the notification package
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

// sceduling the notification
  Future<void> scheduleBellNotifications({
    required String bell,
    required TimeOfDay start,
    required TimeOfDay end,
    required int intervalMinutes,
    required bool muteInSilent,
  }) async {
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

    // checking user wich sound is selected
    String soundFileCheck(String bellName) {
      if (bellName == 'Singing Bowl') {
        return 'singing_bowl';
      } else if (bellName == 'Ohm Bell') {
        return 'ohm_bell';
      } else if (bellName == "Gong") {
        return 'gong';
      } else {
        return 'singing_bowl';
      }
    }

    final soundName = soundFileCheck(bell);
    int notificationId = 0;

    for (var time = startDateTime;
        time.isBefore(endDateTime);
        time = time.add(
      Duration(minutes: intervalMinutes),
    ),) {
      final tzDateTime = tz.TZDateTime.from(time, tz.local);

      //  checking the time is before current time
      if (tzDateTime.isBefore(
        tz.TZDateTime.now(tz.local),
      )) continue;

// this function for the device idle mod
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId++,
          "Mindfulness Bell",
          "ringing the bell in : $bell",
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
          // ignore: deprecated_member_use
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: null,
          androidScheduleMode: AndroidScheduleMode.exact);
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tzdata;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   /// Initializes notification plugin and timezones
//   Future<void> init() async {
//     tzdata.initializeTimeZones();
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }

//   /// Schedules bell notifications between selected times at intervals
//   Future<void> scheduleBellNotifications({
//     required String bell,
//     required TimeOfDay start,
//     required TimeOfDay end,
//     required int intervalMinutes,
//     required bool muteInSilent,
//   }) async {
//     // Cancel any previously scheduled notifications
//     await flutterLocalNotificationsPlugin.cancelAll();

//     // Add 1-minute buffer to current time to avoid "past" notifications
//     final now = DateTime.now().add(const Duration(minutes: 1));
//     final startDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       start.hour,
//       start.minute,
//     );
//     final endDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       end.hour,
//       end.minute,
//     );

//     // Get matching sound file name for the bell type
//     String soundFileCheck(String bellName) {
//       switch (bellName) {
//         case 'Singing Bowl':
//           return 'singing_bowl';
//         case 'Ohm Bell':
//           return 'ohm_bell';
//         case 'Gong':
//           return 'gong';
//         default:
//           return 'singing_bowl';
//       }
//     }

//     final soundName = soundFileCheck(bell);
//     int notificationId = 0;

//     for (var time = startDateTime;
//         time.isBefore(endDateTime);
//         time = time.add(Duration(minutes: intervalMinutes))) {
//       final tzDateTime = tz.TZDateTime.from(time, tz.local);

//       // Skip if the scheduled time is still in the past
//       if (tzDateTime.isBefore(tz.TZDateTime.now(tz.local))) continue;

//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         notificationId++,
//         "Mindfulness Bell",
//         "Ringing the bell: $bell",
//         tzDateTime,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'bell_channel',
//             'Bell Notifications',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: !muteInSilent,
//             enableVibration: true,
//             sound: muteInSilent
//                 ? null
//                 : RawResourceAndroidNotificationSound(soundName),
//           ),
//         ),
//         // ignore: deprecated_member_use
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: null, // 👈 required fix
//       );
//     }
//   }
// }
