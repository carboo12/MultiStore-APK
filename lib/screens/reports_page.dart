import 'package:flutter/material.dart';
import 'package:myapp/services/pdf_service.dart';
import 'package:myapp/services/hive_service.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  Future<void> _generateReport(BuildContext context) async {
    // Use the HiveService to get the data
    final invoices = HiveService().getAllInvoices();

    if (invoices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay ventas para generar un reporte.')),
      );
      return;
    }

    try {
      await PdfService().generateSalesReport(invoices);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar el PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              'Generación de Reportes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Aquí puedes generar reportes en formato PDF de tus ventas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _generateReport(context),
              icon: const Icon(Icons.download_for_offline),
              label: const Text('Generar Reporte de Ventas'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}