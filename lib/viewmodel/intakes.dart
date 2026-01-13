import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:medicine_reminder/model/med_intake.dart';
import 'package:medicine_reminder/model/med_item.dart';

class IntakeViewModel extends ChangeNotifier {
  final Box<MedIntake> _intakeBox = Hive.box<MedIntake>('intake_box');

  static const Duration gracePeriod = Duration(hours: 2);

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  String _key(int medId, DateTime date) {
    final d = _normalize(date);
    return '${medId}_${d.year}-${d.month}-${d.day}';
  }

  // ---------- CORE ----------

  bool isTaken(int medId, DateTime date) {
    return _intakeBox.get(_key(medId, date))?.taken ?? false;
  }

  /// The ONLY authority that decides if user can tap tick
  bool canTake(MedItem med, DateTime selectedDate) {
    final now = DateTime.now();

    if (!_isSameDay(selectedDate, now)) return false;
    if (isTaken(med.id, selectedDate)) return false;

    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      med.scheduledTime.hour,
      med.scheduledTime.minute,
    );

    return now.isAfter(scheduled) && now.isBefore(scheduled.add(gracePeriod));
  }

  Future<void> cancelToday(int medId, DateTime date) async {
    final key = '${medId}_${date.year}-${date.month}-${date.day}';
    if (_intakeBox.containsKey(key)) {
      await _intakeBox.delete(key);
      debugPrint('Cancelled intake for $medId on $date');
      notifyListeners(); // <--- triggers UI rebuild
    }
  }

  Future<void> deleteAllForMedication(int medId) async {
    final keysToDelete = _intakeBox.keys
        .where((k) => k.toString().startsWith('${medId}_'))
        .toList();

    for (final key in keysToDelete) {
      await _intakeBox.delete(key);
    }

    notifyListeners(); // THIS is what fixes your UI
  }

  void refreshAfterReset() {
    notifyListeners(); // Forces UI to re-check isTaken/canTake (which will now be false)
  }

  void take(MedItem med, DateTime date) {
    if (!canTake(med, date)) return;

    final key = _key(med.id, date);

    _intakeBox.put(
      key,
      MedIntake(medId: med.id, date: _normalize(date), taken: true),
    );

    notifyListeners();
  }

  // ---------- DERIVED STATUS ----------

  bool isMissed(MedItem med, DateTime date) {
    if (!_isSameDay(date, DateTime.now())) return false;
    if (isTaken(med.id, date)) return false;

    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      med.scheduledTime.hour,
      med.scheduledTime.minute,
    );

    return DateTime.now().isAfter(scheduled.add(gracePeriod));
  }

  bool isPending(MedItem med, DateTime date) {
    return canTake(med, date);
  }

  // ---------- CLEANUP ----------

  void cleanupOldIntakes({int keepDays = 7}) {
    final cutoff = _normalize(
      DateTime.now().subtract(Duration(days: keepDays)),
    );

    final keys = _intakeBox.keys.toList();

    for (final key in keys) {
      final intake = _intakeBox.get(key);
      if (intake != null && intake.date.isBefore(cutoff)) {
        _intakeBox.delete(key);
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
