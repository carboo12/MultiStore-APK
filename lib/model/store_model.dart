import 'package:hive/hive.dart';

part 'store_model.g.dart';

@HiveType(typeId: 0)
class Store extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String address;

  @HiveField(4)
  String licenseKey;

  @HiveField(5)
  String licensePlan;

  @HiveField(6)
  DateTime registrationDate;

  @HiveField(7)
  DateTime expirationDate;

  Store({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.licenseKey,
    required this.licensePlan,
    required this.registrationDate,
    required this.expirationDate,
  });
}
