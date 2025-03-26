// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkerAvailableAdapter extends TypeAdapter<WorkerAvailable> {
  @override
  final int typeId = 8;

  @override
  WorkerAvailable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkerAvailable(
      workerId: fields[0] as String,
      name: fields[1] as String,
      bookedDates: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkerAvailable obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.workerId)
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
      other is WorkerAvailableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
