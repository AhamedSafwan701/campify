// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_work_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManageAdapter extends TypeAdapter<Manage> {
  @override
  final int typeId = 3;

  @override
  Manage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manage(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as String,
      assignedWorkerIndices: (fields[4] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Manage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.assignedWorkerIndices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
