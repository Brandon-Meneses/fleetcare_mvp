import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/data/ApiConfig.dart';
import '../domain/entities/notification_entity.dart';

class NotificationRepository {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwtToken");
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  /// 🔹 Lista de notificaciones no leídas
  Future<List<NotificationEntity>> listUnread() async {
    final res = await http.get(Uri.parse("$baseUrl/notifications"), headers: await _headers());
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => NotificationEntity.fromJson(e)).toList();
    }
    throw Exception("Error al listar notificaciones (${res.statusCode}): ${res.body}");
  }

  /// 🔹 Cantidad de no leídas
  Future<int> unreadCount() async {
    final res = await http.get(Uri.parse("$baseUrl/notifications/count"), headers: await _headers());
    if (res.statusCode == 200) return int.tryParse(res.body) ?? 0;
    throw Exception("Error al obtener contador (${res.statusCode})");
  }

  /// 🔹 Marcar como leída
  Future<void> markAsRead(int id) async {
    final res = await http.patch(Uri.parse("$baseUrl/notifications/$id/read"), headers: await _headers());
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Error al marcar como leída (${res.statusCode})");
    }
  }
}