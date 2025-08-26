import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/model/customer_model.dart';
import 'package:myapp/model/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final List<CartItem> _cart = [];
  Customer? _selectedCustomer;
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() {
    final customerBox = Hive.box<Customer>('customers');
    // Use listenable to update if customers are added while on this page
    customerBox.listenable().addListener(() {
      if (mounted) {
        setState(() {
          _customers = customerBox.values.toList();
          // If the selected customer was deleted, reset the selection
          if (_selectedCustomer != null &&
              !_customers.any((c) => c.id == _selectedCustomer!.id)) {
            _selectedCustomer = null;
          }
        });
      }
    });
    // Initial load
    if (mounted) {
      setState(() {
        _customers = customerBox.values.toList();
      });
    }
  }

  void addProductByBarcode(String barcode) {
    final productBox = Hive.box<Product>('products');
    final product = productBox.values
        .cast<Product?>()
        .firstWhere((p) => p?.barcode == barcode, orElse: () => null);

    if (!mounted) return;

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Producto no encontrado.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (product.stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Producto "${product.name}" sin stock.'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      final existingCartItemIndex =
          _cart.indexWhere((item) => item.product.id == product.id);

      if (existingCartItemIndex != -1) {
        if (_cart[existingCartItemIndex].quantity < product.stock) {
          _cart[existingCartItemIndex].quantity++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('No hay más stock para "${product.name}".'),
                backgroundColor: Colors.orange),
          );
        }
      } else {
        _cart.add(CartItem(product: product));
      }
    });
  }

  void _incrementQuantity(CartItem item) {
    setState(() {
      if (item.quantity < item.product.stock) {
        item.quantity++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No hay más stock para "${item.product.name}".')),
        );
      }
    });
  }

  void _decrementQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _cart.remove(item);
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  double get _subtotal => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  double get _iva => _subtotal * 0.16; // Assuming 16% IVA
  double get _total => _subtotal + _iva;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerSelector(),
            const SizedBox(height: 24),
            Text('Carrito de Compras',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Expanded(
              child: _cart.isEmpty
                  ? const Center(
                      child: Text('Escanee un producto para comenzar la venta.'),
                    )
                  : _buildCartList(),
            ),
            if (_cart.isNotEmpty) _buildSummary(),
          ],
        ),
      );
  }

  Widget _buildCustomerSelector() {
    return DropdownButtonFormField<Customer>(
      value: _selectedCustomer,
      hint: const Text('Seleccionar Cliente (Público General)'),
      isExpanded: true,
      items: _customers.map<DropdownMenuItem<Customer>>((Customer customer) {
        return DropdownMenuItem<Customer>(
          value: customer,
          child: Text(customer.fullName),
        );
      }).toList(),
      onChanged: (Customer? newValue) {
        setState(() {
          _selectedCustomer = newValue;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      itemCount: _cart.length,
      itemBuilder: (context, index) {
        final item = _cart[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(item.product.name),
            subtitle: Text(
                '${item.quantity} x \$${item.product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _decrementQuantity(item)),
                IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _incrementQuantity(item)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummary() {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:'),
                Text('\$${_subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('IVA (16%):'),
                Text('\$${_iva.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: Theme.of(context).textTheme.titleLarge),
                Text('\$${_total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(
                  onPressed: _clearCart,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red)),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar lógica de pago
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Proceder al Pago'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}