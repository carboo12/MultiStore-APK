import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/model/customer_model.dart';
import 'package:myapp/utils/phone_input_formatter.dart';
import 'package:myapp/services/hive_service.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool get _isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.customer?.fullName ?? '');

    // Formatea el número de teléfono inicial si se está editando un cliente.
    final initialPhone = widget.customer?.phone ?? '';
    final formattedPhone = PhoneInputFormatter().formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: initialPhone),
    ).text;
    _phoneController = TextEditingController(text: formattedPhone);
    _emailController = TextEditingController(text: widget.customer?.email ?? '');
    _addressController =
        TextEditingController(text: widget.customer?.address ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveCustomer() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Limpia el número de teléfono para guardar solo los dígitos, asegurando la consistencia de los datos.
    final rawPhoneNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    final customerToSave = _isEditing
        ? widget.customer!.copyWith(
            fullName: _fullNameController.text.trim(),
            phone: rawPhoneNumber,
            email: _emailController.text.trim(),
            address: _addressController.text.trim(),
          )
        : Customer(
            fullName: _fullNameController.text.trim(),
            phone: rawPhoneNumber,
            email: _emailController.text.trim(),
            address: _addressController.text.trim(),
          );

    await HiveService().saveCustomer(customerToSave);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cliente' : 'Agregar Cliente'),
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
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, ingrese el nombre completo.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !value.contains('@')) {
                          return 'Por favor, ingrese un correo válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        // Permite solo dígitos
                        FilteringTextInputFormatter.digitsOnly,
                        // Aplica el formato de número de teléfono
                        PhoneInputFormatter(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _saveCustomer,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar Cliente'),
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
}