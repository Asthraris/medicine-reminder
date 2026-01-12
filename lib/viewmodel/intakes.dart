import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../model/med_intake.dart';
import '../model/med_item.dart';

class IntakeViewModel extends ChangeNotifier {
  final Box<MedIntake> _intakeBox = Hive.box<MedIntake>('intake_box');
  // final Box<MedItem> _medBox = Hive.box<MedItem>('medication_box');

  static const Duration gracePeriod = Duration(hours: 2);

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  String _key(int medKey, DateTime date) {
    final d = _normalize(date);
    return '${medKey}_${d.year}-${d.month}-${d.day}';
  }

  // ---------- CORE API ----------

  bool isTaken(int medKey, DateTime date) {
    return _intakeBox.get(_key(medKey, date))?.taken ?? false;
  }

  void toggleTaken(int medKey, DateTime date) {
    final key = _key(medKey, date);
    final d = _normalize(date);

    final existing = _intakeBox.get(key);

    _intakeBox.put(
      key,
      existing == null
          ? MedIntake(medId: medKey, date: d, taken: true)
          : existing.copyWith(taken: !existing.taken),
    );

    notifyListeners();
  }

  // ---------- GRACE PERIOD LOGIC ----------

  bool isWithinGrace(MedItem med, DateTime selectedDate) {
    final now = DateTime.now();

    if (!_isSameDay(selectedDate, now)) return false;

    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      med.scheduledTime.hour,
      med.scheduledTime.minute,
    );

    return now.isBefore(scheduled.add(gracePeriod));
  }

  bool isMissed(MedItem med, DateTime date) {
    if (isTaken(med.id, date)) return false;
    if (!_isSameDay(date, DateTime.now())) return false;

    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      med.scheduledTime.hour,
      med.scheduledTime.minute,
    );

    return DateTime.now().isAfter(scheduled.add(gracePeriod));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ---------- CLEANUP (7 DAYS ONLY) ----------

  void cleanupOldIntakes() {
    final cutoff = _normalize(DateTime.now().subtract(const Duration(days: 7)));

    final keysToDelete = _intakeBox.keys.where((key) {
      final intake = _intakeBox.get(key);
      return intake != null && intake.date.isBefore(cutoff);
    }).toList();

    for (final key in keysToDelete) {
      _intakeBox.delete(key);
    }
  }
}
