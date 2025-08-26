import 'package:hive/hive.dart';

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

  Admin({
    required this.fullName,
    required this.username,
    required this.password,
    required this.storeLicenseKey,
  });
}
