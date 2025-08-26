import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/screens/register_admin_add_screen.dart';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final _storeNameController = TextEditingController();
  final _storeEmailController = TextEditingController();

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    super.dispose();
  }

  void _verifyStore() {
    final storeName = _storeNameController.text.trim();
    final storeEmail = _storeEmailController.text.trim();

    if (storeName.isEmpty || storeEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both store name and email.')),
      );
      return;
    }

    final storeBox = Hive.box<Store>('stores');
    final foundStore = storeBox.values.cast<Store?>().firstWhere(
        (store) => store?.name == storeName && store?.email == storeEmail,
        orElse: () => null);

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.store, // Replace with the actual icon you want
                size: 80,
                color: Colors.deepPurple,
              ),
              SizedBox(height: 16),
              Text(
                'Create Admin Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'First, verify your store\'s registration.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              TextField(
                controller: _storeNameController,
                decoration: InputDecoration(
                  labelText: 'Store Name',
                  hintText: 'e.g., My Awesome Store',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _storeEmailController,
                decoration: InputDecoration(
                  labelText: 'Store Email',
                  hintText: 'e.g., contact@mystore.com',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _verifyStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Verify Store'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}