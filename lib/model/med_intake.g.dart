// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_intake.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedIntakeAdapter extends TypeAdapter<MedIntake> {
  @override
  final typeId = 4;

  @override
  MedIntake read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedIntake(
      medId: (fields[0] as num).toInt(),
      date: fields[1] as DateTime,
      taken: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MedIntake obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.medId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.taken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedIntakeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
