import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:myapp/model/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  final String? barcode;

  const AddEditProductScreen({super.key, this.product, this.barcode});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _barcodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(
      text: widget.product?.barcode ?? widget.barcode ?? '',
    );
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final productsBox = Hive.box<Product>('products');
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final stock = int.tryParse(_stockController.text) ?? 0;

    final productToSave = _isEditing
        ? widget.product!.copyWith(
            barcode: _barcodeController.text.trim(),
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            stock: stock,
          )
        : Product(
            barcode: _barcodeController.text.trim(),
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            stock: stock,
          );

    await productsBox.put(productToSave.id, productToSave);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Agregar Producto'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextFormField(
                      controller: _barcodeController,
                      label: 'Código de Barras',
                      icon: Icons.qr_code_scanner,
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese un código de barras' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _nameController,
                      label: 'Nombre del Producto',
                      icon: Icons.label_outline,
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese el nombre' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _descriptionController,
                      label: 'Descripción',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _priceController,
                      label: 'Precio',
                      icon: Icons.attach_money_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese el precio' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _stockController,
                      label: 'Stock',
                      icon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese el stock' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _saveProduct,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar Producto'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
    );
  }
}
