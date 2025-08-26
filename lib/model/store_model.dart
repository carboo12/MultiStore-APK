

import 'package:hive/hive.dart';

part 'store_model.g.dart';

@HiveType(typeId: 0)
class Store extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String licenseKey;

  @HiveField(5)
  final String licensePlan;

  @HiveField(6)
  final DateTime registrationDate;

  @HiveField(7)
  final DateTime expirationDate;

  @HiveField(8)
  final int numberOfUsers;

  Store({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.licenseKey,
    required this.licensePlan,
    required this.registrationDate,
    required this.expirationDate,
    required this.numberOfUsers,
  });
}
