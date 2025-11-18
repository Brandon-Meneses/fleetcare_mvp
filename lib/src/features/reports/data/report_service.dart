import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import '../../fleet/domain/entities/bus.dart';
import '../../settings/domain/config.dart';
import '../domain/report_models.dart';
import '../../auth/data/auth_storage.dart';

class ReportService {
  final Dio _dio;
  final String _backendUrl; // e.g. https://your-backend/reports/groq

  ReportService(this._dio, {required String backendUrl}) : _backendUrl = backendUrl;

  /// Genera un hash simple de los datos para trazabilidad.
  String _dataHash(List<Bus> buses, AppConfig cfg) {
    final raw = jsonEncode({
      'buses': buses.map((b) => b.toJson()).toList(),
      'cfg': {'km': cfg.kmThreshold, 'months': cfg.monthsThreshold}
    });
    return sha1.convert(utf8.encode(raw)).toString();
  }

  /// Validación mínima del JSON.
  bool _isValidReport(Map<String, dynamic> data) {
    return data['summary'] is String &&
        data['kpis'] is List &&
        data['sections'] is List &&
        (data['kpis'] as List).every((e) => e is Map && e['name'] is String) &&
        (data['sections'] as List).every((e) => e is Map && e['title'] is String && e['content'] is String);
  }

  /// Fallback local básico si IA falla 2 veces o JSON inválido.
  ReportResponse _fallbackLocal(List<Bus> buses, AppConfig cfg, String dataHash) {
    final total = buses.length;
    final kmProm = total == 0 ? 0 : (buses.map((b) => b.kmCurrent).fold<int>(0, (a, b) => a + b) / total).round();
    return ReportResponse(
      summary: 'Resumen local: $total buses. Km promedio: $kmProm. Umbrales: ${cfg.kmThreshold}km / ${cfg.monthsThreshold}m.',
      kpis: [
        ReportKpi(name: 'Total buses', value: '$total'),
        ReportKpi(name: 'Km promedio', value: '$kmProm'),
        ReportKpi(name: 'Umbral KM', value: '${cfg.kmThreshold}'),
        ReportKpi(name: 'Umbral meses', value: '${cfg.monthsThreshold}'),
      ],
      sections: const [
        ReportSection(title: 'Notas', content: 'Este es un informe básico local porque la IA no respondió correctamente.')
      ],
      dataHash: dataHash,
    );
  }

  /// Llamada al backend (que a su vez llama a Groq/LLaMA)
  Future<ReportResponse> generateReport({
    required List<Bus> buses,
    required AppConfig config,
  }) async {
    final dataHash = _dataHash(buses, config);
    final token = await AuthStorage.getToken();

    // --- ESTA ES LA FORMA CORRECTA ---
    final payload = {
      'fleet': buses.map((b) => {
        'id': b.id,
        'plate': b.plate,
        'kmCurrent': b.kmCurrent,
        'lastServiceAt': b.lastMaintenanceDate?.toIso8601String().split('T').first,
      }).toList(),
      'config': {
        'kmThreshold': config.kmThreshold,
        'monthsThreshold': config.monthsThreshold,
      },
      'dataHash': dataHash,
    };

    final res = await _dio.post(
      _backendUrl,   // /report/area/MAINTENANCE
      data: payload,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final data = res.data;
    return ReportResponse.fromJson(data);
  }
}