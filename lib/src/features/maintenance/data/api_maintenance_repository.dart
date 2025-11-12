import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/maintenance_order.dart';
import '../domain/repositories/maintenance_repository.dart';
import '../../../features/auth/data/ApiConfig.dart';

class ApiMaintenanceRepository implements MaintenanceRepository {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwtToken");
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  /// ✅ Lista todas las órdenes
  @override
  Future<List<MaintenanceOrder>> list() async {
    final res = await http.get(Uri.parse("$baseUrl/maintenance"), headers: await _headers());
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => MaintenanceOrder.fromJson(e)).toList();
    }
    throw Exception("Error al listar órdenes: ${res.body}");
  }

  /// ✅ Lista órdenes por bus
  @override
  Future<List<MaintenanceOrder>> listByBus(String busId) async {
    final res = await http.get(Uri.parse("$baseUrl/maintenance/$busId"), headers: await _headers());
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => MaintenanceOrder.fromJson(e)).toList();
    }
    throw Exception("Error al listar órdenes de bus $busId: ${res.body}");
  }

  /// ✅ Crea una orden (POST /maintenance)
  @override
  Future<MaintenanceOrder> upsert(MaintenanceOrder order) async {
    final res = await http.post(
      Uri.parse("$baseUrl/maintenance"),
      headers: await _headers(),
      body: jsonEncode(order.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return MaintenanceOrder.fromJson(jsonDecode(res.body));
    }
    throw Exception("Error al crear orden: ${res.body}");
  }

  /// 🚫 No hay DELETE en backend (placeholder)
  @override
  Future<void> delete(String id) async {
    throw UnimplementedError("Eliminación no soportada por el backend");
  }

  @override
  Future<MaintenanceOrder?> findById(String id) async {
    final all = await list();
    try {
      return all.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  /// ✅ PATCH /maintenance/{id}/open
  Future<MaintenanceOrder> openOrder(String id) async {
    final res = await http.patch(
      Uri.parse("$baseUrl/maintenance/$id/open"),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return MaintenanceOrder.fromJson(jsonDecode(res.body));
    }
    throw Exception("Error al abrir orden: ${res.body}");
  }

  /// ✅ PATCH /maintenance/{id}/close
  Future<MaintenanceOrder> closeOrder(String id, {String? notes}) async {
    final res = await http.patch(
      Uri.parse("$baseUrl/maintenance/$id/close"),
      headers: await _headers(),
      body: jsonEncode({"notes": notes}),
    );
    if (res.statusCode == 200) {
      return MaintenanceOrder.fromJson(jsonDecode(res.body));
    }
    throw Exception("Error al cerrar orden: ${res.body}");
  }
}