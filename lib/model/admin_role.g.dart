// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminRoleAdapter extends TypeAdapter<AdminRole> {
  @override
  final int typeId = 4;

  @override
  AdminRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AdminRole.admin;
      case 1:
        return AdminRole.cashier;
      default:
        return AdminRole.admin;
    }
  }

  @override
  void write(BinaryWriter writer, AdminRole obj) {
    switch (obj) {
      case AdminRole.admin:
        writer.writeByte(0);
        break;
      case AdminRole.cashier:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
