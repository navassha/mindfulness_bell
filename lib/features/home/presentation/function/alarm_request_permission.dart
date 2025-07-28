import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

// checking the device version if the user using less then 31 it request
// a special alarm req from the setting directly
Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 31) {
      const platform = MethodChannel('alarm_permissions');
      try {
        await platform.invokeMethod('requestExactAlarm');
      } on PlatformException catch (e) {
        log('Error: ${e.message}');
      }
    }
  }
}
