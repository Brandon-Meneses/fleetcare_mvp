import 'package:fleetcare_mvp/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/fleet/presentation/pages/bus_list_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/maintenance/presentation/pages/maintenance_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/reports/presentation/pages/report_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/data/auth_state.dart';
import '../../features/admin/presentation/CreateUserPage.dart';

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("jwtToken") != null;
}

Future<bool> canAccess(String route) async {
  final roles = await AuthState.getRoles();
  final areas = await AuthState.getAreas();

  final isAdmin = roles.contains("ADMIN");

  if (isAdmin) return true; // Admin ve todo 🚀

  return switch (route) {
    "/buslist"       => areas.contains("MAINTENANCE"),
    "/maintenance"   => areas.contains("OPERATIONS"),
    "/report"        => true,
    "/settings"      => false, // Solo admin
    "/notifications" => true, // todos
    "/dashboard"     => true, // todos
    _                => false,
  };
}

final appRouter = GoRouter(
  initialLocation: "/login",
  refreshListenable: AuthState.notifier,
  redirect: (context, state) async {
    final loggedIn = AuthState.notifier.value;
    final location = state.uri.path;

    // Si no está logueado → solo /login permitido
    if (!loggedIn && location != "/login") return "/login";

    // Si está logueado y va a login → mandarlo al dashboard
    if (loggedIn && location == "/login") return "/dashboard";

    // Protección por roles/áreas
    if (loggedIn) {
      final ok = await canAccess(location);
      if (!ok) return "/dashboard";
    }

    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (_, __) => const LoginPage()),

    GoRoute(path: "/dashboard", builder: (_, __) => const DashboardPage()),
    GoRoute(path: "/buslist", builder: (_, __) => const BusListPage()),
    GoRoute(path: "/settings", builder: (_, __) => const SettingsPage()),
    GoRoute(path: "/notifications", builder: (_, __) => const NotificationsPage()),
    GoRoute(path: "/maintenance", builder: (_, __) => const MaintenancePage()),
    GoRoute(path: "/report", builder: (_, __) => const ReportPage()),
    GoRoute(path: "/admin/users", builder: (_, __) => const CreateUserPage(),
    ),
  ],
);