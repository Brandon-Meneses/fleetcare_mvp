import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../report_controller.dart';
import '../report_pdf.dart';
import 'package:pdf/pdf.dart';

class ReportPage extends ConsumerWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Informe IA')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generar informe con IA'),
              onPressed: () => ref.read(reportControllerProvider.notifier).generate(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reportState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (rep) {
                  if (rep == null) {
                    return const Center(child: Text('Genera un informe para ver la vista previa.'));
                  }
                  return PdfPreview(
                    build: (format) async => await ReportPdf.build(rep),
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    initialPageFormat: PdfPageFormat.a4,
                    allowSharing: true,
                    allowPrinting: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}