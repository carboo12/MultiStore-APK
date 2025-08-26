import 'dart:io';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:myapp/model/invoice_model.dart';

class PdfService {
  Future<void> generateSalesReport(List<Invoice> invoices) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(),
        build: (context) => [
          _buildReportTable(invoices, dateFormat),
          pw.Divider(),
          _buildSummary(invoices),
        ],
        footer: (context) => _buildFooter(),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sales_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the generated PDF
    await OpenFile.open(file.path);
  }

  pw.Widget _buildHeader() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(bottom: 20.0),
      child: pw.Column(
        children: [
          pw.Text('Reporte de Ventas', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Text('Latienda Express', style: pw.TextStyle(fontSize: 18)),
          pw.Text('Generado el: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
        ],
      ),
    );
  }

  pw.Widget _buildReportTable(List<Invoice> invoices, DateFormat dateFormat) {
    final headers = ['Fecha', 'ID Factura', 'Cliente', 'Total'];
    final data = invoices.map((invoice) {
      return [
        dateFormat.format(invoice.date),
        invoice.id.substring(0, 8), // Shortened ID
        invoice.customerName,
        '\$${invoice.total.toStringAsFixed(2)}',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _buildSummary(List<Invoice> invoices) {
    final totalSales = invoices.fold<double>(0, (sum, item) => sum + item.total);
    final totalInvoices = invoices.length;

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Resumen del Reporte', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Número total de ventas: $totalInvoices'),
          pw.Text('Ingresos totales: \$${totalSales.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20.0),
      child: pw.Text(
        'Latienda Express - Reporte Confidencial',
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
      ),
    );
  }
}