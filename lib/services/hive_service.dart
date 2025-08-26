import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/model/admin_model.dart';
import 'package:myapp/model/customer_model.dart';
import 'package:myapp/model/invoice_model.dart';
import 'package:myapp/model/product_model.dart';
import 'package:myapp/model/store_model.dart';

class HiveService {
  // Singleton pattern to ensure only one instance of the service is created.
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  // --- Box Getters (for direct access if needed, though methods are preferred) ---
  Box<Store> get storesBox => Hive.box<Store>('stores');
  Box<Admin> get adminsBox => Hive.box<Admin>('admins');
  Box<Customer> get customersBox => Hive.box<Customer>('customers');
  Box<Product> get productsBox => Hive.box<Product>('products');
  Box<Invoice> get invoicesBox => Hive.box<Invoice>('invoices');

  // --- Listenables for reactive UI updates ---
  ValueListenable<Box<Customer>> getCustomersListenable() =>
      customersBox.listenable();
  ValueListenable<Box<Product>> getProductsListenable() =>
      productsBox.listenable();

  // --- Read operations ---
  List<Invoice> getAllInvoices() => invoicesBox.values.toList();
  Product? getProduct(String id) => productsBox.get(id);

  // --- Write/Update operations ---
  Future<void> saveStore(Store store) => storesBox.put(store.licenseKey, store);
  Future<void> saveAdmin(Admin admin) => adminsBox.add(admin);
  Future<void> saveCustomer(Customer customer) =>
      customersBox.put(customer.id, customer);
  Future<void> saveProduct(Product product) =>
      productsBox.put(product.id, product);
  Future<void> saveInvoice(Invoice invoice) =>
      invoicesBox.put(invoice.id, invoice);

  // --- Specific finders (to encapsulate query logic) ---
  Admin? findAdminByUsername(String username) {
    return adminsBox.values.cast<Admin?>().firstWhere(
      (admin) => admin?.username == username,
      orElse: () => null,
    );
  }

  Store? findStoreByNameAndEmail(String name, String email) {
    return storesBox.values.cast<Store?>().firstWhere(
      (store) => store?.name == name && store?.email == email,
      orElse: () => null,
    );
  }

  Product? findProductByBarcode(String barcode) {
    return productsBox.values.cast<Product?>().firstWhere(
      (p) => p?.barcode == barcode,
      orElse: () => null,
    );
  }
}
