import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  static final notifier = ValueNotifier<bool>(false);

  static Future<void> loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    notifier.value = prefs.getString("jwtToken") != null;
  }

  static Future<void> setLoggedIn(
      String token,
      List<String> roles,
      List<String> areas,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", token);
    await prefs.setStringList("roles", roles);
    await prefs.setStringList("areas", areas);

    notifier.value = true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwtToken");
    await prefs.remove("roles");
    await prefs.remove("areas");

    notifier.value = false;
  }

  // === Helpers ===

  static Future<List<String>> getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("roles") ?? [];
  }

  static Future<List<String>> getAreas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("areas") ?? [];
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwtToken") != null;
  }
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwtToken");
  }
}