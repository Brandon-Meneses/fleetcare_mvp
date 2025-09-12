import 'package:go_router/go_router.dart';
import '../../features/fleet/presentation/pages/bus_list_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/maintenance/presentation/pages/maintenance_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/reports/presentation/pages/report_page.dart';


final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const DashboardPage()),
    GoRoute(path: '/buslist', builder: (_, __) => const BusListPage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/alerts', builder: (_, __) => const AlertsPage()),
    GoRoute(path: '/maintenance', builder: (_, __) => const MaintenancePage()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
    GoRoute(path: '/report', builder: (_, __) => const ReportPage()),
  ],
);