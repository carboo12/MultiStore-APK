import 'package:flutter/material.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/services/hive_service.dart';
import 'package:myapp/screens/register_admin_add_screen.dart';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _storeEmailController = TextEditingController();

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    super.dispose();
  }

  void _verifyStore() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final storeName = _storeNameController.text.trim();
    final storeEmail = _storeEmailController.text.trim();

    final foundStore = HiveService().findStoreByNameAndEmail(storeName, storeEmail);

    if (foundStore != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Store "${foundStore.name}" verified!')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterAdminAddScreen(store: foundStore)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store not found. Please check the details and try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildFormFields(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(
          Icons.verified_user_outlined,
          size: 80,
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 16),
        const Text(
          'Verify Your Store',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Before creating an admin, please confirm your store\'s registration details.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _storeNameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.storefront_outlined),
            hintText: 'Store Name',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the store name.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _storeEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: 'Store Email',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the store email.';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return ElevatedButton(
      onPressed: _verifyStore,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: const Text('Verify Store', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Pop all routes until the first one (LoginScreen)
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}