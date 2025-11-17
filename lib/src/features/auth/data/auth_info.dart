import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final rolesProvider = FutureProvider<List<String>>((ref) async {
  return AuthState.getRoles();
});

final areasProvider = FutureProvider<List<String>>((ref) async {
  return AuthState.getAreas();
});

class Perms {
  static bool isAdmin(List<String> roles) => roles.contains("ADMIN");

  static bool canSeeBuses(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE");

  static bool canEditBus(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE");

  static bool canDeleteBus(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE");

  static bool canPlanMaintenance(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE") || areas.contains("OPERATIONS");

  static bool canViewOrders(List<String> areas, List<String> roles) =>
      isAdmin(roles) ||
          areas.contains("MAINTENANCE") ||
          areas.contains("OPERATIONS");

  static bool canDecommission(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE");

  static bool canReplace(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE");

  static bool canCreateBus(List<String> areas, List<String> roles) =>
      isAdmin(roles) || areas.contains("MAINTENANCE");
}

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