import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:myapp/model/admin_model.dart';
import 'package:myapp/screens/register_store_screen.dart';
import 'package:myapp/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese usuario y contraseña.')),
      );
      return;
    }

    // 1. Superuser check for store registration
    if (username == 'superusu' && password == 'Id14304++') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterStoreScreen()),
      );
      return;
    }

    // 2. Admin check using Hive
    final adminBox = Hive.box<Admin>('admins');
    Admin? foundAdmin;
    for (final admin in adminBox.values) {
      if (admin.username == username && admin.password == password) {
        foundAdmin = admin;
        break;
      }
    }

    if (foundAdmin != null) {
      // Navigate to Dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(admin: foundAdmin!)),
        (route) => false,
      );
    } else {
      // Show error for invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Purple Icon
              SvgPicture.asset(
                'assets/icons/app_icon.svg', // Replace with your icon path
                height: 80.0,
                colorFilter: const ColorFilter.mode(Colors.deepPurple, BlendMode.srcIn),
              ),
              const SizedBox(height: 24.0),
              // Title
              const Text(
                'Latienda Express',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              // Subtitle
              const Text(
                'Welcome back! Please login to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48.0),
              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24.0),
              // Create Account Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'First time setting up? ',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterStoreScreen()),
                      );
                    },
                    child: const Text(
                      'Create an account',
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
    );
  }
}
