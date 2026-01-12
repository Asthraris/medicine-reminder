import 'package:hive_ce/hive.dart';

part 'med_item.g.dart';

@HiveType(typeId: 1)
enum DosageType {
  @HiveField(0)
  mg,
  @HiveField(1)
  gm,
  @HiveField(2)
  kg,
  @HiveField(3)
  ml,
  @HiveField(4)
  pcs,
}

@HiveType(typeId: 0)
class MedItem {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int dosage;
  @HiveField(3)
  final DosageType type;
  @HiveField(4)
  final String addInfo;
  @HiveField(5)
  final List<int> repeatDays;
  @HiveField(6)
  final DateTime scheduledTime;
  @HiveField(7)
  final bool isTaken;

  MedItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.addInfo,
    this.repeatDays = const [], //this tells its onetime med
    required this.scheduledTime,
    this.isTaken = false,
  });

  bool isDueToday() {
    int today = DateTime.now().weekday;
    return repeatDays.contains(today);
  }

  MedItem copyWith({bool? isTaken}) {
    return MedItem(
      id: id,
      name: name,
      dosage: dosage,
      type: type,
      addInfo: addInfo,
      repeatDays: repeatDays,
      scheduledTime: scheduledTime,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}
