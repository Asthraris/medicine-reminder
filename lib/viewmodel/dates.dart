import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/model/date_item.dart';
import 'package:medicine_reminder/viewmodel/intakes.dart';
import 'package:medicine_reminder/model/med_item.dart';

class DateViewModel extends ChangeNotifier {
  // 1. Get reference to the History Box
  final Box<DateItem> _historyBox = Hive.box<DateItem>('history_box');

  DateTime _selectedDate = DateTime.now();
  List<DateItem> _dates = [];

  DateViewModel() {
    _generateDates();
  }

  DateTime get selectedDate => _selectedDate;
  List<DateItem> get dates => _dates;

  void _generateDates({int pastDays = 2, int futureDays = 7}) {
    final today = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(today);

    _dates = List.generate(pastDays + futureDays + 1, (i) {
      final date = today.add(Duration(days: i - pastDays));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      // 2. CHECK HIVE FIRST: Do we already have data for this day?
      DateItem? savedItem = _historyBox.get(dateKey);

      if (savedItem != null) {
        return savedItem;
      }

      // 3. DEFAULT LOGIC: If no Hive data, create a temporary item
      DayFulfillment fulfillment;
      if (DateFormat('yyyy-MM-dd').format(date) == todayKey) {
        fulfillment = DayFulfillment.partial; // Today starts as partial
      } else if (date.isAfter(today)) {
        fulfillment = DayFulfillment.future;
      } else {
        fulfillment =
            DayFulfillment.missed; // Past days with no record are 'missed'
      }

      return DateItem(date: date, fulfillment: fulfillment);
    });

    notifyListeners();
  }

  // 4. Update and Save to Hive
  void updateDateStatus(DateTime date, DayFulfillment newStatus) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final newItem = DateItem(date: date, fulfillment: newStatus);

    // Save to DB
    _historyBox.put(dateKey, newItem);

    // Refresh the local list so the UI updates
    _generateDates();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void resolveDayStatus(
    DateTime date,
    List<MedItem> meds,
    IntakeViewModel intakeVM,
  ) {
    bool anyTaken = false;
    bool anyMissed = false;

    for (final med in meds) {
      if (intakeVM.isTaken(med.id, date)) {
        anyTaken = true;
      } else if (intakeVM.isMissed(med, date)) {
        anyMissed = true;
      }
    }

    DayFulfillment status;

    if (anyTaken && !anyMissed) {
      status = DayFulfillment.completed;
    } else if (anyTaken && anyMissed) {
      status = DayFulfillment.partial;
    } else {
      status = DayFulfillment.missed;
    }

    updateDateStatus(date, status);
  }
}
