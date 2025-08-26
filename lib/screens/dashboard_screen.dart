import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/model/admin_model.dart';
import 'package:myapp/model/product_model.dart';
import 'package:myapp/model/admin_role.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/services/scanner_service.dart';
import 'package:myapp/screens/inventory_page.dart';
import 'package:myapp/screens/customers_page.dart';
import 'package:myapp/screens/add_edit_product_screen.dart';
import 'package:myapp/screens/billing_page.dart';
import 'dart:async';

class _DashboardTab {
  final String label;
  final IconData icon;
  final Widget page;

  _DashboardTab(
      {required this.label, required this.icon, required this.page});
}

class DashboardScreen extends StatefulWidget {
  final Admin admin;
  const DashboardScreen({super.key, required this.admin});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final ScannerService _scannerService = ScannerService();
  final GlobalKey<BillingPageState> _billingPageKey = GlobalKey<BillingPageState>();
  StreamSubscription? _scanSubscription;

  late final List<_DashboardTab> _tabs;

  @override
  void initState() {
    super.initState();

    final bool isAdmin = widget.admin.role == AdminRole.admin;

    // Define all possible tabs
    final allTabs = [
      _DashboardTab(
          label: 'Inventario',
          icon: Icons.inventory_2,
          page: InventoryPage(isAdmin: isAdmin)),
      if (isAdmin)
        _DashboardTab(
            label: 'Clientes', icon: Icons.people, page: const CustomersPage()),
      _DashboardTab(
          label: 'Facturación',
          icon: Icons.receipt_long,
          page: BillingPage(key: _billingPageKey)),
      if (isAdmin)
        _DashboardTab(
            label: 'Reportes',
            icon: Icons.bar_chart,
            page: const Center(child: Text('Reportes'))),
    ];

    _tabs = allTabs;

    _scannerService.init();
    _scanSubscription = _scannerService.scanResultStream.listen((scannedData) {
      // Si estamos en la pestaña de inventario, manejamos el escaneo.
      final currentTabLabel = _tabs[_selectedIndex].label;
      if (currentTabLabel == 'Inventario') {
        _handleScan(scannedData);
      } else if (currentTabLabel == 'Facturación') {
        _billingPageKey.currentState?.addProductByBarcode(scannedData);
      }
    });
  }

  void _handleScan(String barcode) {
    final productBox = Hive.box<Product>('products');
    final existingProduct = productBox.values
        .cast<Product?>()
        .firstWhere((p) => p?.barcode == barcode, orElse: () => null);

    if (existingProduct != null) {
      // Si el producto existe, vamos a la pantalla de edición.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: existingProduct),
      ));
    } else {
      // Si no existe, vamos a la pantalla de agregar con el código pre-llenado.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditProductScreen(barcode: barcode),
      ));
    }
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
          for (final tab in _tabs) tab.page,
        ],
      ),
      floatingActionButton: widget.admin.role == AdminRole.admin &&
              _tabs.isNotEmpty &&
              _tabs[_selectedIndex].label == 'Inventario'
          ? FloatingActionButton(
              onPressed: () {
                // Navega a la pantalla de agregar producto sin un código de barras.
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddEditProductScreen(),
                ));
              },
              tooltip: 'Agregar Producto',
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
