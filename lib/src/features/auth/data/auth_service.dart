import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/auth_models.dart';
import 'auth_state.dart';
import 'auth_storage.dart';
import 'ApiConfig.dart';

class AuthService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<LoginResponse> login(LoginRequest request) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (res.statusCode == 200) {
      print("RAW RESPONSE: ${res.body}");
      final data = jsonDecode(res.body);
      print("TOKEN PARSED: ${data['token']}");
      final loginResponse = LoginResponse.fromJson(data);

      // 👉 guardamos token con AuthStorage
      await AuthState.setLoggedIn(
        loginResponse.token,
        loginResponse.roles,
        loginResponse.areas,
      );

      return loginResponse;
    } else {
      throw Exception("Credenciales inválidas");
    }
  }

  Future<void> logout() async {
    await AuthState.logout();
  }
}