import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/model/admin_model.dart';
import 'package:myapp/services/hive_service.dart';
import 'package:myapp/model/admin_role.dart';
import 'package:myapp/screens/login_screen.dart';

class RegisterAdminAddScreen extends StatefulWidget {
  final Store store;
  const RegisterAdminAddScreen({super.key, required this.store});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterAdminAddScreenState createState() => _RegisterAdminAddScreenState();
}

class _RegisterAdminAddScreenState extends State<RegisterAdminAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AdminRole _selectedRole = AdminRole.admin;

  late final TextEditingController _storeNameController;
  late final TextEditingController _storeEmailController;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(text: widget.store.name);
    _storeEmailController = TextEditingController(text: widget.store.email);
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAdminAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Hashea la contraseña antes de guardarla.
      // BCrypt.gensalt() genera una "sal" aleatoria para asegurar que cada hash sea único.
      final String hashedPassword = BCrypt.hashpw(_passwordController.text, BCrypt.gensalt());

      final newAdmin = Admin(
          fullName: _fullNameController.text,
          username: _usernameController.text,
          password: hashedPassword,
          storeLicenseKey: widget.store.licenseKey,
          role: _selectedRole);

      await HiveService().saveAdmin(newAdmin);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Admin account for "${newAdmin.username}" created successfully!')));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 24.0),
                _buildStoreInfo(),
                const SizedBox(height: 16.0),
                _buildAdminFormFields(),
                const SizedBox(height: 24.0),
                _buildActionButtons(),
                const SizedBox(height: 16.0),
                _buildLoginLink(),
              ],
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
          Icons.person_add_alt_1,
          size: 80.0,
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 24.0),
        const Text(
          'Create Admin Account',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Enter the administrator\'s details.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfo() {
    return Column(
      children: [
        _buildReadOnlyTextField(
          controller: _storeNameController,
          label: 'Store Name',
        ),
        const SizedBox(height: 16.0),
        _buildReadOnlyTextField(
          controller: _storeEmailController,
          label: 'Store Email',
        ),
      ],
    );
  }

  Widget _buildReadOnlyTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAdminFormFields() {
    return Column(
      children: [
        _buildTextFormField(
          controller: _fullNameController,
          label: 'Full Name',
          hintText: 'Enter full name',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter a full name';
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        _buildTextFormField(
          controller: _usernameController,
          label: 'Username',
          hintText: 'Enter username',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter a username';
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        _buildTextFormField(
          controller: _passwordController,
          label: 'Password',
          hintText: 'Enter password',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter a password';
            if (value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        _buildTextFormField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hintText: 'Confirm your password',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please confirm your password';
            if (value != _passwordController.text) return 'Passwords do not match';
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<AdminRole>(
          value: _selectedRole,
          decoration: InputDecoration(
            labelText: 'Role',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items: AdminRole.values.map((AdminRole role) {
            final roleName = role.name;
            return DropdownMenuItem<AdminRole>(
              value: role,
              child: Text(roleName[0].toUpperCase() + roleName.substring(1)),
            );
          }).toList(),
          onChanged: (AdminRole? newValue) {
            if (newValue != null) setState(() => _selectedRole = newValue);
          },
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return ElevatedButton(
      onPressed: _createAdminAccount,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        'Create Account',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Already have an account? ',
          style: TextStyle(fontSize: 16.0),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          },
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}