import 'package:go_router/go_router.dart';
import '../../features/fleet/presentation/pages/bus_list_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';


final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const BusListPage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/alerts', builder: (_, __) => const AlertsPage()),
  ],
);