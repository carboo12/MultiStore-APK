import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  final String lastScan;
  const InventoryPage({super.key, required this.lastScan});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final bool _hasProducts = false; // Set to true if you have products to display

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Inventory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your products and view their inventory status.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton('All'),
                        const SizedBox(width: 8),
                        _buildFilterButton('Active'),
                        const SizedBox(width: 8),
                        _buildFilterButton('Draft'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.document_scanner_outlined),
                  onPressed: () {
                    // TODO: Implement document scan action
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Último dato escaneado: ${widget.lastScan}',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _hasProducts
                  ? ListView.builder(
                      itemCount: 0, // Replace with your actual product list count
                      itemBuilder: (context, index) {
                        // TODO: Build your product list items here
                        return Container(); // Placeholder
                      },
                    )
                  : const Center(
                      child: Text('No products found.'),
                    ),
            ),
          ],
        ),
      );
  }

  Widget _buildFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement filter action
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // Add styles for selected/unselected states if needed
      ),
      child: Text(text),
    );
  }
}