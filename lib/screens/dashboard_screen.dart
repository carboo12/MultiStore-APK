import 'package:flutter/material.dart';
import 'package:myapp/model/admin_model.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/services/scanner_service.dart';
import 'package:myapp/screens/inventory_page.dart';
import 'package:myapp/screens/billing_page.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  final Admin admin;
  const DashboardScreen({super.key, required this.admin});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  final ScannerService _scannerService = ScannerService();
  StreamSubscription? _scanSubscription;
  String _lastScan = 'Aún no hay datos escaneados.';

  @override
  void initState() {
    super.initState();
    _scannerService.init();
    _scanSubscription = _scannerService.scanResultStream.listen((scannedData) {
      setState(() {
        _lastScan = scannedData;
      });
      _showScanResultDialog(scannedData);
    });
  }

  void _showScanResultDialog(String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Código Escaneado'),
          content: Text(data, style: const TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _scannerService.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          InventoryPage(lastScan: _lastScan),
          BillingPage(lastScan: _lastScan),
          const Center(child: Text('Reportes', style: TextStyle(fontSize: 32))),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _scannerService.triggerScan(true),
              tooltip: 'Probar Escáner',
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildNavItem(Icons.inventory_2, 'Inventario', 0),
          _buildNavItem(Icons.receipt_long, 'Facturación', 1),
          _buildNavItem(Icons.bar_chart, 'Reportes', 2),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    final isHovered = _hoveredIndex == index;

    return BottomNavigationBarItem(
      icon: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = -1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: isHovered
              ? (Matrix4.identity()..translate(0.0, -8.0, 0.0))
              : Matrix4.identity(),
          child: Icon(icon),
        ),
      ),
      label: label,
    );
  }
}
