import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:myapp/screens/register_admin_screen.dart';
import 'package:hive/hive.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/services/email_service.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  _RegisterStoreScreenState createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  final _formKey = GlobalKey<FormState>();

  final _storeNameController = TextEditingController();
  final _storeEmailController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeAddressController = TextEditingController();

  String _licensePlan = 'Monthly';

  bool _showLicenseDetails = false;
  String _licenseKey = '';
  DateTime? _registrationDate;

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    _storePhoneController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  void _generateAndShowLicense() {
    setState(() {
      _showLicenseDetails = true;
      _licenseKey = _generateLicenseKey();
      _registrationDate = DateTime.now();
    });
  }

  void _registerStoreAndCreateAdmin() async {
    // 1. Validate the form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    // 2. Check if license key has been generated
    if (_licenseKey.isEmpty || _registrationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate a license key first.')),
      );
      return;
    }

    // 3. Create the Store object
    final newStore = Store(
      name: _storeNameController.text,
      email: _storeEmailController.text,
      phone: _storePhoneController.text,
      address: _storeAddressController.text,
      licenseKey: _licenseKey,
      licensePlan: _licensePlan,
      registrationDate: _registrationDate!,
      expirationDate: _calculateExpirationDate(),
    );

    // 4. Save to Hive
    final storeBox = Hive.box<Store>('stores');
    await storeBox.add(newStore);

    // 5. Send registration email (simulated)
    await EmailService().sendRegistrationEmail(newStore);

    // 6. Show success message and navigate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Store "${newStore.name}" registered successfully!')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterAdminScreen()),
    );
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
              // Icon
              Center(
                child: Icon(
                  Icons.storefront, // You might want a different icon
                  size: 80.0,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20.0),
              // Title
              Text(
                'Register Your Store',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              // Subtitle
              Text(
                'Start by providing your store\'s information.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30.0),
              // Store Name Field
              Text(
                'Store Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a store name';
                  }
                  return null;
                },
                controller: _storeNameController,
                decoration: InputDecoration(
                  hintText: 'e.g., My Awesome Store',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              SizedBox(height: 16.0),
              // Store Email Field
              Text(
                'Store Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                controller: _storeEmailController,
                decoration: InputDecoration(
                  hintText: 'e.g., contact@mystore.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              SizedBox(height: 16.0),
              // Store Phone Field
              Text(
                'Store Phone',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                controller: _storePhoneController,
                decoration: InputDecoration(
                  hintText: 'e.g., +1 123 456 7890',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              SizedBox(height: 16.0),
              // Store Address Field
              Text(
                'Store Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                controller: _storeAddressController,
                decoration: InputDecoration(
                  hintText: 'e.g., 123 Main St, Anytown',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              SizedBox(height: 24.0),
              // License Plan Section
              Text(
                'License Plan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Monthly'),
                      value: 'Monthly',
                      groupValue: _licensePlan,
                      onChanged: (value) {
                        setState(() {
                          _licensePlan = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Annual'),
                      value: 'Annual',
                      groupValue: _licensePlan,
                      onChanged: (value) {
                        setState(() {
                          _licensePlan = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _generateAndShowLicense,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Generate License Key'),
              ),
              SizedBox(height: 24.0),
              if (_showLicenseDetails) ...[
                Text(
                  'License Key Details',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'License Key',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _registrationDate != null ? DateFormat('yyyy-MM-dd').format(_registrationDate!) : '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Registration Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _registrationDate,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Expiration Date: ${DateFormat('yyyy-MM-dd').format(_calculateExpirationDate())}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 24.0),
              ],

              // Register Button
              ElevatedButton(
                onPressed: _registerStoreAndCreateAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Register Store & Create Admin',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 20.0),
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.deepPurple),
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

  String _generateLicenseKey() {
    // Simple random key generation for demonstration
    final random = Random.secure();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(16, (index) => chars[random.nextInt(chars.length)])
        .join()
        .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}-")
        .substring(0, 19);
  }

  DateTime _calculateExpirationDate() {
    // This should not be reached if the button logic is correct, as _registrationDate will be set.
    final registrationDateTime = _registrationDate ?? DateTime.now();
    DateTime expirationDateTime = _licensePlan == 'Monthly'
        ? registrationDateTime.add(Duration(days: 30)) // Approximate monthly
        : registrationDateTime.add(Duration(days: 365)); // Approximate annual
    return expirationDateTime;
  }
}