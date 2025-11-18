import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  static final notifier = ValueNotifier<bool>(false);

  static Future<void> loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    notifier.value = prefs.getString("jwtToken") != null;
  }

  static Future<void> setLoggedIn(String token, List<String> roles, List<String> areas,) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", token);
    await prefs.setStringList("roles", roles);
    await prefs.setStringList("areas", areas);

    notifier.value = true;
  }

  static bool isLoggingOut = false;

  static Future<void> logout() async {
    isLoggingOut = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwtToken");
    await prefs.remove("roles");
    await prefs.remove("areas");

    notifier.value = false;

    // Espera pequeño para que GoRouter reciba el nuevo valor
    await Future.delayed(const Duration(milliseconds: 50));

    isLoggingOut = false;
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

  static List<String> lastAreas = [];

  static Future<void> load() async {
    lastAreas = await getAreas();
  }

  static List<String> getAreasSync() {
    return lastAreas;
  }
}