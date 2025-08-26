import 'package:hive/hive.dart';

part 'admin_role.g.dart';

@HiveType(typeId: 4)
enum AdminRole {
  @HiveField(0)
  admin,

  @HiveField(1)
  cashier,
}
