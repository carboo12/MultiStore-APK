import 'package:flutter/material.dart';

class BillingPage extends StatefulWidget {
  final String lastScan;
  const BillingPage({super.key, required this.lastScan});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  // TODO: Implement actual customer selection and cart management
  String _selectedCustomer = 'General Public';
  final bool _isCartEmpty = true;
  final double _subtotal = 0.00;
  final double _iva = 0.00;
  final double _total = 0.00;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Section
            const Text(
              'Customer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCustomer,
                    items: <String>['General Public', 'Customer A', 'Customer B'] // Example customers
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCustomer = newValue;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement Add New Customer
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add New Customer'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Scan or Search Section
            const Text(
              'Scan or Search',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Find products by barcode or name.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search or scan barcode',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Último dato escaneado: ${widget.lastScan}',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),

            // Cart Section
            if (_isCartEmpty)
              const Center(
                child: Text(
                  'Cart is empty. Scan or search for a product to begin.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // TODO: Implement displaying cart items when not empty

            const Spacer(), // Pushes the summary to the bottom

            // Summary Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text('\$$_subtotal'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('IVA (16%):'),
                    Text('\$$_iva'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$$_total',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement proceed to payment
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Proceed to Payment'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Make button full width
                    backgroundColor: Colors.deepPurple, // Example color
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}