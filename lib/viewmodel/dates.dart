import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/date_item.dart';

class DateViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  List<DateItem> _dates = [];

  DateViewModel() {
    _generateDates();
  }

  DateTime get selectedDate => _selectedDate;
  List<DateItem> get dates => _dates;

  void _generateDates({int pastDays = 2, int futureDays = 7}) {
    final today = DateTime.now();

    _dates = List.generate(pastDays + futureDays + 1, (i) {
      final date = today.add(Duration(days: i - pastDays));

      // TEMP logic – replace with Hive later
      final fulfillment = date.isAfter(today)
          ? DayFulfillment.future
          : DayFulfillment.completed;

      return DateItem(date: date, fulfillment: fulfillment);
    });
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
