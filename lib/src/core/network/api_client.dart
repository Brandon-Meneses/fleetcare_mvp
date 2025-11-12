import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/auth/data/auth_storage.dart';
import '../../features/auth/data/ApiConfig.dart';

class ApiClient {
  static Future<http.Response> get(String path) async {
    final token = await AuthStorage.getToken();
    final uri = Uri.parse("${ApiConfig.baseUrl}$path");
    return http.get(uri, headers: _headers(token));
  }

  static Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final token = await AuthStorage.getToken();
    final uri = Uri.parse("${ApiConfig.baseUrl}$path");
    return http.post(uri, headers: _headers(token), body: jsonEncode(body));
  }

  static Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final token = await AuthStorage.getToken();
    final uri = Uri.parse("${ApiConfig.baseUrl}$path");
    return http.put(uri, headers: _headers(token), body: jsonEncode(body));
  }

  static Future<http.Response> patch(String path, Map<String, dynamic> body) async {
    final token = await AuthStorage.getToken();
    final uri = Uri.parse("${ApiConfig.baseUrl}$path");
    return http.patch(uri, headers: _headers(token), body: jsonEncode(body));
  }

  static Future<http.Response> delete(String path) async {
    final token = await AuthStorage.getToken();
    final uri = Uri.parse("${ApiConfig.baseUrl}$path");
    return http.delete(uri, headers: _headers(token));
  }

  static Map<String, String> _headers(String? token) => {
    "Content-Type": "application/json",
    if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
  };
}