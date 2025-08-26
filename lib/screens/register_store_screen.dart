import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  State<RegisterStoreScreen> createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _licensePlanController = TextEditingController();
  final _numberOfUsersController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _licensePlanController.dispose();
    _numberOfUsersController.dispose();
    super.dispose();
  }

  void _registerStore() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final registrationDate = DateTime.now();
    // Por defecto, la licencia expira en un año.
    final expirationDate = registrationDate.add(const Duration(days: 365));
    final licenseKey = const Uuid().v4();
    final numberOfUsers = int.tryParse(_numberOfUsersController.text.trim());

    if (numberOfUsers == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número de usuarios inválido.')),
      );
      return;
    }

    final newStore = Store(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      licensePlan: _licensePlanController.text.trim(),
      numberOfUsers: numberOfUsers,
      licenseKey: licenseKey,
      registrationDate: registrationDate,
      expirationDate: expirationDate,
    );

    await HiveService().saveStore(newStore);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Tienda "${newStore.name}" registrada con éxito.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Tienda'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Nombre de la tienda'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el nombre de la tienda.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Por favor, ingrese un email válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _licensePlanController,
                      decoration:
                          const InputDecoration(labelText: 'Plan de Licencia'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _numberOfUsersController,
                      decoration:
                          const InputDecoration(labelText: 'Número de usuarios'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el número de usuarios.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, ingrese un número válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _registerStore,
                      child: const Text('Registrar Tienda'),
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