import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../reports/domain/report_models.dart';

class ReportPdf {
  static Future<Uint8List> build(ReportResponse rep) async {
    final pdf = pw.Document();
    final df = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(
      pw.MultiPage(
        build: (ctx) => [
          pw.Header(level: 0, child: pw.Text('Informe de Flota', style: pw.TextStyle(fontSize: 22))),
          pw.Text('Fecha: ${df.format(DateTime.now())}'),
          pw.Text('DataHash: ${rep.dataHash}', style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 12),
          pw.Text(rep.summary, style: pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 16),
          pw.Text('KPIs', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: const ['KPI', 'Valor'],
            data: rep.kpis.map((k) => [k.name, k.value]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 16),
          pw.Text('Secciones', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...rep.sections.map((s) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 8),
              pw.Text(s.title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(s.content),
            ],
          )),
        ],
      ),
    );

    return pdf.save();
  }
}