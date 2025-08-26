import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String barcode;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int stock;

  Product({
    required this.barcode,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Product copyWith({
    String? barcode,
    String? name,
    String? description,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}
