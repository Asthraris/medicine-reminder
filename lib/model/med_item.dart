enum DosageType { mg, gm, kg, ml, pcs }

class MedItem {
  final int id;
  final String name;
  final int dosage;
  final DosageType type;
  final String addInfo;
  final List<int> repeatDays;
  final DateTime scheduledTime;
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
