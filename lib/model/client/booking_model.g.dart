// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackageClientAdapter extends TypeAdapter<PackageClient> {
  @override
  final int typeId = 6;

  @override
  PackageClient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackageClient(
      clientId: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      date: fields[3] as String,
      packageName: fields[4] as String,
      placeName: fields[5] as String,
      imagePath: fields[6] as String?,
      idProofPath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PackageClient obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.clientId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.packageName)
      ..writeByte(5)
      ..write(obj.placeName)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.idProofPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageClientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
