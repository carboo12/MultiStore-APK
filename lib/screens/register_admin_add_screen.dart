import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/screens/login_screen.dart';

class RegisterAdminAddScreen extends StatefulWidget {
  final Store store;
  const RegisterAdminAddScreen({super.key, required this.store});

  @override
  _RegisterAdminAddScreenState createState() => _RegisterAdminAddScreenState();
}

class _RegisterAdminAddScreenState extends State<RegisterAdminAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    if (_formKey.currentState!.validate()) {
      final newAdmin = Admin(
          fullName: _fullNameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          storeLicenseKey: widget.store.licenseKey);
      final adminBox = Hive.box<Admin>('admins');
      await adminBox.add(newAdmin);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Admin account for "${newAdmin.username}" created successfully!')));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
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
            children: <Widget>[
              // Purple icon
              Icon(
                Icons.storefront, // You can replace this with your desired icon
                size: 80.0,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24.0),
              // Title
              const Text(
                'Create Admin Account',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              // Subtitle
              const Text(
                'Enter the administrator\'s details.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24.0),
              // Store Name
              TextField(
                controller: _storeNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Store Name',
                  hintText: 'e.g., My Awesome Store',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Store Email
              TextField(
                controller: _storeEmailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Store Email',
                  hintText: 'e.g., contact@mystore.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              // Full Name
              TextFormField(
                controller: _fullNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a full name';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Username
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a username';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Password
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a password';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm your password';
                  if (value != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              // Create Account Button
              ElevatedButton(
                onPressed: _createAdminAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
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
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}