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

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("jwtToken") != null;
}

final appRouter = GoRouter(
  initialLocation: "/login",
  refreshListenable: AuthState.notifier, // 👈 escucha cambios
  redirect: (context, state) {
    final loggedIn = AuthState.notifier.value;
    final loc = state.uri.path;

    if (!loggedIn && loc != "/login") return "/login";
    if (loggedIn && loc == "/login") return "/dashboard";

    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (_, __) => const LoginPage()),
    GoRoute(path: "/dashboard", builder: (_, __) => const DashboardPage()),
    GoRoute(path: "/buslist", builder: (_, __) => const BusListPage()),
    GoRoute(path: "/settings", builder: (_, __) => const SettingsPage()),
    GoRoute(path: "/alerts", builder: (_, __) => const AlertsPage()),
    GoRoute(path: "/maintenance", builder: (_, __) => const MaintenancePage()),
    GoRoute(path: "/report", builder: (_, __) => const ReportPage()),
  ],
);