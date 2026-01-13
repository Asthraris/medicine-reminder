import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future<void> scheduleMedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'med_channel',
      'Medication Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexact,
      //for one time reminder , set matachDatetime Components to null
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
      debugPrint('Cancelled notification with ID: $id');
    } catch (e) {
      debugPrint('Failed to cancel notification $id: $e');
    }
  }
}
