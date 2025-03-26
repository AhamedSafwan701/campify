// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tent_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TentAdapter extends TypeAdapter<Tent> {
  @override
  final int typeId = 7;

  @override
  Tent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tent(
      tentId: fields[0] as String,
      name: fields[1] as String,
      bookedDates: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tentId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bookedDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
