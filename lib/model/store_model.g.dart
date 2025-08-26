// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 0;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      name: fields[0] as String,
      email: fields[1] as String,
      phone: fields[2] as String,
      address: fields[3] as String,
      licenseKey: fields[4] as String,
      licensePlan: fields[5] as String,
      registrationDate: fields[6] as DateTime,
      expirationDate: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.licenseKey)
      ..writeByte(5)
      ..write(obj.licensePlan)
      ..writeByte(6)
      ..write(obj.registrationDate)
      ..writeByte(7)
      ..write(obj.expirationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
