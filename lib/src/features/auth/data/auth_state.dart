import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  static final notifier = ValueNotifier<bool>(false);

  static Future<void> loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    notifier.value = prefs.getString("jwtToken") != null;
  }

  static Future<void> setLoggedIn(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", token);
    notifier.value = true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwtToken");
    notifier.value = false;
  }
}