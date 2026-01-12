enum DayFulfillment { completed, partial, missed, future }

class DateItem {
  final DateTime date;
  final DayFulfillment fulfillment;

  DateItem({required this.date, required this.fulfillment});
}
