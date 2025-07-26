import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindfulness_bell/features/home/presentation/function/notification_permission.dart';
import 'features/home/data/service/notification_service.dart';
import 'features/home/presentation/function/alarm_request_permission.dart';
import 'features/home/presentation/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
// requesting permission and senting a sample notofication
  await requestingNotificationPErmission();
// requesting alarmPermission
  await requestExactAlarmPermission();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfulness Bell',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
