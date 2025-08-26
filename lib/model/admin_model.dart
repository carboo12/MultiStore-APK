import 'package:hive/hive.dart';
import 'package:myapp/model/admin_role.dart';

part 'admin_model.g.dart';

@HiveType(typeId: 1)
class Admin extends HiveObject {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String storeLicenseKey;

  @HiveField(4)
  final AdminRole role;

  Admin({
    required this.fullName,
    required this.username,
    required this.password,
    required this.storeLicenseKey,
    required this.role,
  });
}
