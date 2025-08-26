import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 5)
class InvoiceItem extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double price; // Price per unit at the time of sale

  InvoiceItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}

@HiveType(typeId: 6)
class Invoice extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? customerId;

  @HiveField(2)
  final String customerName; // Denormalized for easy display

  @HiveField(3)
  final List<InvoiceItem> items;

  @HiveField(4)
  final double subtotal;

  @HiveField(5)
  final double tax;

  @HiveField(6)
  final double total;

  @HiveField(7)
  final DateTime date;

  Invoice({
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.date,
    this.customerId,
    String? id,
  }) : id = id ?? const Uuid().v4();
}
