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
      placeName: fields[4] as String,
      imagePath: fields[5] as String?,
      idProofPath: fields[6] as String?,
      packageType: fields[7] as String?,
      price:
          fields[8] is String
              ? double.tryParse(fields[8] as String)
              : fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, PackageClient obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.clientId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.placeName)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.idProofPath)
      ..writeByte(7)
      ..write(obj.packageType)
      ..writeByte(8)
      ..write(obj.price);
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
