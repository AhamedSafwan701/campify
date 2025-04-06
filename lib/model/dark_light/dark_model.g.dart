// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeModeModelAdapter extends TypeAdapter<ThemeModeModel> {
  @override
  final int typeId = 10;

  @override
  ThemeModeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeModeModel(isDarkMode: fields[0] as bool);
  }

  @override
  void write(BinaryWriter writer, ThemeModeModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isDarkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
