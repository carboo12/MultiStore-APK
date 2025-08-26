import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 2)
class Customer extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String address;

  Customer({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Customer copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? address,
  }) {
    return Customer(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}
