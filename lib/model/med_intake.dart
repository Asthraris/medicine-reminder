import 'package:hive_ce/hive_ce.dart';

part 'med_intake.g.dart';

@HiveType(typeId: 4)
class MedIntake {
  @HiveField(0)
  final int medId;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final bool taken;

  MedIntake({required this.medId, required this.date, required this.taken});

  MedIntake copyWith({bool? taken}) {
    return MedIntake(medId: medId, date: date, taken: taken ?? this.taken);
  }
}
