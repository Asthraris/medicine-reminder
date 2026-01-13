import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// ---------- INIT ---------- before the main starts
  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  /// ---------- STABLE NOTIFICATION ID ---------- this generates an id for android to see which app does it belong waht it sis
  /// One notification per medication, forever
  static int notificationIdForMed(int medId) {
    return medId & 0x7FFFFFFF;
  }

  //for testing
  static Future<void> testOneShotNotification() async {
    final androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    final scheduled = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));

    await _plugin.zonedSchedule(
      999999,
      'TEST',
      'This must appear in 10 seconds',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null, // IMPORTANT
    );
  }

  /// ---------- SCHEDULE DAILY ----------
  static Future<void> scheduleDailyMedication({
    required int medId,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'med_channel',
      'Medication Reminders',
      channelDescription: 'Daily medication reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      notificationIdForMed(medId),
      title,
      body,
      _nextInstanceOfTime(time),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, //  DAILY
    );
  }

  /// ---------- CANCEL (DELETE MEDICATION) ----------
  static Future<void> cancelMedication(int medId) async {
    final id = notificationIdForMed(medId);
    await _plugin.cancel(id);
    debugPrint('Cancelled notification for medId=$medId (id=$id)');
  }

  /// ---------- NEXT TIME CALC ----------
  static tz.TZDateTime _nextInstanceOfTime(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
