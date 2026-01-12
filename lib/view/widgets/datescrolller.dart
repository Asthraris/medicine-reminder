import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/model/date_item.dart';

class DateScroller extends StatelessWidget {
  final List<DateItem> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateScroller({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Color _colorForFulfillment(DayFulfillment status, BuildContext context) {
    switch (status) {
      case DayFulfillment.completed:
        return Colors.green;
      case DayFulfillment.partial:
        return Colors.orange;
      case DayFulfillment.missed:
        return Colors.red;
      case DayFulfillment.future:
        return Theme.of(context).colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = dates[index];
          final isToday = _isSameDay(item.date, DateTime.now());
          final isSelected = _isSameDay(item.date, selectedDate);

          final tileColor = isSelected
              ? Theme.of(context).colorScheme.primary
              : _colorForFulfillment(item.fulfillment, context);

          return GestureDetector(
            onTap: () => onDateSelected(item.date),
            child: Container(
              width: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  width: isSelected ? 3 : 0.0,
                ),
                color: tileColor.withAlpha(70),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(item.date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
