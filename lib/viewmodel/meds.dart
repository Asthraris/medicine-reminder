import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:medicine_reminder/core/notification.dart';
import 'package:medicine_reminder/model/med_item.dart'; // Make sure the path to your model is correct
import 'package:medicine_reminder/model/med_intake.dart';

class MedicationViewModel extends ChangeNotifier {
  // 1. Get reference to the medication box opened in main.dart
  final Box<MedItem> _box = Hive.box<MedItem>('medication_box');
  final Box<MedIntake> intakeBox = Hive.box<MedIntake>('intake_box');

  // 2. Private list of all meds from Hive
  List<MedItem> _allMeds = [];

  MedicationViewModel() {
    _loadMeds();
  }

  // --- GETTERS ---

  /// Returns all medications stored in Hive
  List<MedItem> get allMeds => _allMeds;

  // --- ACTIONS ---

  /// Initial load of data from Hive
  void _loadMeds() {
    _allMeds = _box.values.toList();
    notifyListeners();
  }

  int _notificationId(int medId, DateTime time) {
    return ((medId * 1000) + (time.hour * 100 + time.minute)) & 0x7FFFFFFF;
  }

  /// Adds a new medication to Hive and refreshes the local list
  Future<void> addMedication(MedItem med) async {
    try {
      final notificationId = _notificationId(med.id, med.scheduledTime);

      debugPrint('Scheduling notification for ${med.name}');
      debugPrint('Notification ID: $notificationId');
      debugPrint('Scheduled time: ${med.scheduledTime}');
      await NotificationService.scheduleMedNotification(
        id: notificationId,
        title: 'Medication Reminder',
        body: 'Time to take ${med.name}',
        time: med.scheduledTime,
      );
    } catch (e) {
      debugPrint('Notification scheduling failed: $e');
    }
    _box.add(med);
    _loadMeds(); // Refresh the local list and notify UI
  }

  /// Toggles the 'isTaken' status of a specific medication
  void toggleTakenStatus(int id) {
    final med = _box.get(id);
    if (med != null) {
      final updatedMed = med.copyWith(isTaken: !med.isTaken);
      _box.put(id, updatedMed); // Update in Hive
      _loadMeds(); // Refresh and notify
    }
  }

  /// Deletes a medication from Hive
  void deleteMedication(int id) {
    _box.delete(id);
    _loadMeds();
  }

  List<MedItem> getSortedMedsForDate(DateTime selectedDate) {
    final weekday = selectedDate.weekday;

    // Filter
    List<MedItem> list = _box.values.where((med) {
      if (med.repeatDays.isEmpty) {
        return isSameDay(med.scheduledTime, selectedDate);
      }
      return med.repeatDays.contains(weekday);
    }).toList();

    // Sort by time (Hour and Minute)
    list.sort((a, b) {
      int timeA = a.scheduledTime.hour * 60 + a.scheduledTime.minute;
      int timeB = b.scheduledTime.hour * 60 + b.scheduledTime.minute;
      return timeA.compareTo(timeB);
    });

    return list;
  }

  // Helper to compare dates without time
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> deleteMedicationWithCleanup(MedItem med, intakeVM) async {
    // 1. Delete med
    await _box.delete(med.id);

    // 2. Delete all intakes (delegated correctly)
    await intakeVM.deleteAllForMedication(med.id);

    // 3. Cancel notifications
    for (int i = 0; i < 7; i++) {
      final id = _notificationId(
        med.id,
        med.scheduledTime.add(Duration(days: i)),
      );
      await NotificationService.cancelNotification(id);
    }

    _loadMeds(); // updates med list
  }
}
