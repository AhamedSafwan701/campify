// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 5;

  @override
  Place read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      id: fields[0] as String,
      placeName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.placeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
