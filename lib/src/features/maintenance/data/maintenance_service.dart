import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/maintenance_order.dart';
class MaintenanceService {
  final String baseUrl = "http://localhost:8080";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwtToken");
  }

  Future<List<MaintenanceOrder>> fetchOrders(String busId) async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/maintenance/$busId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => MaintenanceOrder.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener órdenes");
    }
  }

  Future<void> createOrder(MaintenanceOrder order) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse("$baseUrl/maintenance"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(order.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception("Error al crear orden");
    }
  }

  Future<void> closeOrder(String orderId, String notes) async {
    final token = await _getToken();
    final res = await http.patch(
      Uri.parse("$baseUrl/maintenance/$orderId/close"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"notes": notes}),
    );

    if (res.statusCode != 200) {
      throw Exception("Error al cerrar orden");
    }
  }
}