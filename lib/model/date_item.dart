import 'package:hive_ce/hive.dart';
part 'date_item.g.dart';

@HiveType(typeId: 2)
enum DayFulfillment {
  @HiveField(0)
  completed,
  @HiveField(1)
  partial,
  @HiveField(2)
  missed,
  @HiveField(3)
  future,
}

@HiveType(typeId: 3)
class DateItem {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final DayFulfillment fulfillment;

  DateItem({required this.date, required this.fulfillment});
}
