import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/maintenance_order.dart';
import '../domain/repositories/maintenance_repository.dart';

class ApiMaintenanceRepository implements MaintenanceRepository {
  final String baseUrl = "http://localhost:8080";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwtToken");
  }

  @override
  Future<List<MaintenanceOrder>> list() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/maintenance"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => MaintenanceOrder.fromJson(e)).toList();
    } else {
      throw Exception("Error al listar órdenes: ${res.body}");
    }
  }

  @override
  Future<List<MaintenanceOrder>> listByBus(String busId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/maintenance/$busId"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => MaintenanceOrder.fromJson(e)).toList();
    } else {
      throw Exception("Error al listar órdenes de bus $busId: ${res.body}");
    }
  }

  @override
  Future<MaintenanceOrder> upsert(MaintenanceOrder order) async {
    final token = await _getToken();
    final body = jsonEncode(order.toJson());

    final res = await http.post(
      Uri.parse("$baseUrl/maintenance"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return MaintenanceOrder.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Error al crear/actualizar orden: ${res.body}");
    }
  }

  @override
  Future<void> delete(String id) async {
    // ⚠️ Aún no implementado en backend, lo dejamos como un TODO
    throw UnimplementedError();
  }

  @override
  Future<MaintenanceOrder?> findById(String id) async {
    final all = await list();
    return all.firstWhere((o) => o.id == id, orElse: () => null as MaintenanceOrder);
  }

  Future<MaintenanceOrder> openOrder(String id) async {
    final token = await _getToken();
    final res = await http.patch(
      Uri.parse("$baseUrl/maintenance/$id/open"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode == 200) {
      return MaintenanceOrder.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Error al abrir orden: ${res.body}");
    }
  }

  Future<MaintenanceOrder> closeOrder(String id, String? notes) async {
    final token = await _getToken();
    final res = await http.patch(
      Uri.parse("$baseUrl/maintenance/$id/close"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"notes": notes}),
    );
    if (res.statusCode == 200) {
      return MaintenanceOrder.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Error al cerrar orden: ${res.body}");
    }
  }
}