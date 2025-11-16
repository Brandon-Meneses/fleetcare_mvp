import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'auth_state.dart';

final rolesProvider = FutureProvider<List<String>>((ref) async {
  return AuthState.getRoles();
});

final areasProvider = FutureProvider<List<String>>((ref) async {
  return AuthState.getAreas();
});

class AuthInfo {
  static Future<List<String>> roles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("roles") ?? [];
  }

  static Future<List<String>> areas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("areas") ?? [];
  }

  static Future<bool> isAdmin() async {
    final r = await roles();
    return r.contains("ADMIN");
  }

  static Future<bool> isUser() async {
    final r = await roles();
    return r.contains("USER");
  }
}