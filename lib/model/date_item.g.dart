// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DateItemAdapter extends TypeAdapter<DateItem> {
  @override
  final typeId = 3;

  @override
  DateItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DateItem(
      date: fields[0] as DateTime,
      fulfillment: fields[1] as DayFulfillment,
    );
  }

  @override
  void write(BinaryWriter writer, DateItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.fulfillment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayFulfillmentAdapter extends TypeAdapter<DayFulfillment> {
  @override
  final typeId = 2;

  @override
  DayFulfillment read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DayFulfillment.completed;
      case 1:
        return DayFulfillment.partial;
      case 2:
        return DayFulfillment.missed;
      case 3:
        return DayFulfillment.future;
      default:
        return DayFulfillment.completed;
    }
  }

  @override
  void write(BinaryWriter writer, DayFulfillment obj) {
    switch (obj) {
      case DayFulfillment.completed:
        writer.writeByte(0);
      case DayFulfillment.partial:
        writer.writeByte(1);
      case DayFulfillment.missed:
        writer.writeByte(2);
      case DayFulfillment.future:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayFulfillmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
