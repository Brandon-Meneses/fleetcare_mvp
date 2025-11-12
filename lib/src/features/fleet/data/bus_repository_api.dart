// lib/src/features/fleet/data/bus_repository_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_storage.dart';
import '../../auth/data/ApiConfig.dart';
import '../domain/entities/bus.dart';
import '../domain/repositories/bus_repository.dart';

class ApiBusRepository implements BusRepository {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /buses
  @override
  Future<List<Bus>> list() async {
    final res = await http.get(Uri.parse('$_baseUrl/buses'), headers: await _headers());
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Bus.fromJson(e)).toList();
    }
    throw Exception('Error al listar buses (${res.statusCode})');
  }

  /// POST /buses (CreateBusReq)
  @override
  Future<Bus> upsert(Bus bus) async {
    final headers = await _headers();

    // Crear
    if (bus.id.isEmpty) {
      final body = jsonEncode({
        "plate": bus.plate,
        "kmInitial": bus.kmCurrent,
        "dateEnabled": bus.lastServiceAt?.toIso8601String().split('T').first,
      });
      final res = await http.post(Uri.parse('$_baseUrl/buses'), headers: headers, body: body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return Bus.fromJson(jsonDecode(res.body));
      }
      throw Exception('Error al crear bus (${res.statusCode})');
    }

    // Actualizar km o último mantenimiento (según lo que venga)
    final body = jsonEncode({"km": bus.kmCurrent});
    final res = await http.put(Uri.parse('$_baseUrl/buses/${bus.id}/km'), headers: headers, body: body);
    if (res.statusCode == 200) {
      return Bus.fromJson(jsonDecode(res.body));
    }
    throw Exception('Error al actualizar bus (${res.statusCode})');
  }

  /// DELETE /buses/{id}
  @override
  Future<void> delete(String id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/buses/$id'), headers: await _headers());
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Error al eliminar bus (${res.statusCode})');
    }
  }

  /// GET /buses/{id}
  @override
  Future<Bus?> findById(String id) async {
    final res = await http.get(Uri.parse('$_baseUrl/buses/$id'), headers: await _headers());
    if (res.statusCode == 200) return Bus.fromJson(jsonDecode(res.body));
    if (res.statusCode == 404) return null;
    throw Exception('Error al obtener bus (${res.statusCode})');
  }

  /// PUT /buses/{id}/last-maint
  Future<void> updateLastMaintenance(String id, DateTime date) async {
    final headers = await _headers();
    final body = jsonEncode({"date": date.toIso8601String().split('T').first});
    final res = await http.put(Uri.parse('$_baseUrl/buses/$id/last-maint'), headers: headers, body: body);
    if (res.statusCode != 200) throw Exception('Error al actualizar último mantenimiento');
  }

  /// GET /buses/{id}/prediction
  Future<Map<String, dynamic>> predict(String id, {int? kmPerDay}) async {
    final headers = await _headers();
    final uri = Uri.parse('$_baseUrl/buses/$id/prediction${kmPerDay != null ? '?kmPerDay=$kmPerDay' : ''}');
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Error al obtener predicción (${res.statusCode})');
  }

  /// POST /buses/{id}/auto-schedule
  Future<void> autoSchedule(String id, {int? adjustDays}) async {
    final headers = await _headers();
    final uri = Uri.parse('$_baseUrl/buses/$id/auto-schedule${adjustDays != null ? '?adjustDays=$adjustDays' : ''}');
    final res = await http.post(uri, headers: headers);
    if (res.statusCode != 200) throw Exception('Error al auto-agendar mantenimiento');
  }

  Future<void> updateStatus(String id, String status, {String? replacementId}) async {
    final headers = await _headers();
    final body = jsonEncode({
      "status": status,
      "replacementId": replacementId,
    });

    final res = await http.put(
      Uri.parse("$_baseUrl/buses/$id/status"),
      headers: headers,
      body: body,
    );

    if (res.statusCode != 200) {
      throw Exception("Error al actualizar estado del bus: ${res.body}");
    }
  }
}