import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/model/admin_model.dart';
import 'package:myapp/model/customer_model.dart';
import 'package:myapp/model/store_model.dart';
import 'package:myapp/screens/login_screen.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de cualquier
  // operación asíncrona.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive para Flutter.
  await Hive.initFlutter();

  // Registra todos los adaptadores de los modelos de datos.
  // Es crucial que los typeId sean únicos.
  // typeId: 0 para Store
  // typeId: 1 para Admin
  // typeId: 2 para Customer
  Hive.registerAdapter(StoreAdapter());
  Hive.registerAdapter(AdminAdapter());
  Hive.registerAdapter(CustomerAdapter());

  // Abre las "cajas" (boxes) de Hive donde se almacenarán los datos.
  // Es como abrir tablas en una base de datos relacional.
  await Hive.openBox<Store>('stores');
  await Hive.openBox<Admin>('admins');
  await Hive.openBox<Customer>('customers');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
