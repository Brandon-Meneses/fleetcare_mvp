import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/auth_models.dart';
import 'auth_storage.dart';

class AuthService {
  final String baseUrl = "http://localhost:8080"; // 👈 cambiar si usas emulador Android

  Future<LoginResponse> login(LoginRequest request) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final loginResponse = LoginResponse.fromJson(data);

      // 👉 guardamos token con AuthStorage
      await AuthStorage.saveToken(loginResponse.token);

      return loginResponse;
    } else {
      throw Exception("Credenciales inválidas");
    }
  }

  Future<void> logout() async {
    await AuthStorage.clearToken();
  }
}