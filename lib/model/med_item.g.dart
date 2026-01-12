// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedItemAdapter extends TypeAdapter<MedItem> {
  @override
  final typeId = 0;

  @override
  MedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedItem(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      dosage: (fields[2] as num).toInt(),
      type: fields[3] as DosageType,
      addInfo: fields[4] as String,
      repeatDays: fields[5] == null
          ? const []
          : (fields[5] as List).cast<int>(),
      scheduledTime: fields[6] as DateTime,
      isTaken: fields[7] == null ? false : fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MedItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dosage)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.addInfo)
      ..writeByte(5)
      ..write(obj.repeatDays)
      ..writeByte(6)
      ..write(obj.scheduledTime)
      ..writeByte(7)
      ..write(obj.isTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DosageTypeAdapter extends TypeAdapter<DosageType> {
  @override
  final typeId = 1;

  @override
  DosageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DosageType.mg;
      case 1:
        return DosageType.gm;
      case 2:
        return DosageType.kg;
      case 3:
        return DosageType.ml;
      case 4:
        return DosageType.pcs;
      default:
        return DosageType.mg;
    }
  }

  @override
  void write(BinaryWriter writer, DosageType obj) {
    switch (obj) {
      case DosageType.mg:
        writer.writeByte(0);
      case DosageType.gm:
        writer.writeByte(1);
      case DosageType.kg:
        writer.writeByte(2);
      case DosageType.ml:
        writer.writeByte(3);
      case DosageType.pcs:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DosageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
