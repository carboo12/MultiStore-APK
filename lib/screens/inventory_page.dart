import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/model/product_model.dart';
import 'package:myapp/screens/add_edit_product_screen.dart';
import 'package:myapp/services/hive_service.dart';

class InventoryPage extends StatefulWidget {
  final bool isAdmin;
  const InventoryPage({super.key, required this.isAdmin});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  final _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          // La UI se reconstruirá usando el texto actual del controlador
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _showOptionsDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(product.name),
          content: const Text('¿Qué desea hacer?'),
          actions: <Widget>[
            if (widget.isAdmin)
              TextButton(
                child: const Text('Eliminar'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _showDeleteConfirmation(context, product);
                },
              ),
            if (widget.isAdmin)
              TextButton(
                child: const Text('Modificar'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditProductScreen(product: product),
                    ),
                  );
                },
              ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
              '¿Está seguro de que desea eliminar "${product.name}"? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () async {
                await product.delete();
                if (!context.mounted) return;
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${product.name}" eliminado.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o código...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _hiveService.getProductsListenable(),
            builder: (context, productBox, _) {
              final allProducts = productBox.values.toList().cast<Product>();
              final searchQuery = _searchController.text.toLowerCase();

              final filteredProducts = allProducts.where((product) {
                final nameMatch = product.name.toLowerCase().contains(searchQuery);
                final barcodeMatch = product.barcode.toLowerCase().contains(searchQuery);
                return nameMatch || barcodeMatch;
              }).toList();

              if (allProducts.isEmpty) {
                return const Center(
                  child: Text('No hay productos en el inventario.'),
                );
              }

              if (filteredProducts.isEmpty) {
                return const Center(
                  child: Text('No se encontraron productos.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Código: ${product.barcode}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Stock: ${product.stock}'),
                        ],
                      ),
                      onTap: widget.isAdmin ? () => _showOptionsDialog(context, product) : null,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}