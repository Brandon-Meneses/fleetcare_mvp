import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../fleet/domain/services/rules_service.dart';
import '../../fleet/domain/value_objects/bus_state.dart';
import '../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../maintenance/presentation/controllers/maintenance_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/dashboard_stats.dart';
import '../../fleet/domain/entities/bus.dart';

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final busesAsync = ref.watch(busListControllerProvider);
  final ordersAsync = ref.watch(maintenanceControllerProvider);

  // --- Loading ---
  if (busesAsync.isLoading || ordersAsync.isLoading) {
    return Future.error("loading");
  }

  // --- Error handling ---
  if (busesAsync.hasError) throw busesAsync.error!;
  if (ordersAsync.hasError) throw ordersAsync.error!;

  // --- Ambos en data ---
  final buses = busesAsync.value!;
  final orders = ordersAsync.value!;

  final repo = ref.read(busRepositoryProvider);

  int ok = 0, dueSoon = 0, overdue = 0;
  final overdueList = <({int urgency, Bus bus})>[];

  // --- Procesamiento de buses ---
  for (final b in buses) {
    switch (b.status) {
      case "OK":
        ok++;
        break;

      case "PROXIMO":
        dueSoon++;
        break;

      case "VENCIDO":
        overdue++;

        // Fecha real desde backend
        final nextDate = await repo.nextMaintenanceDate(b.id);

        final daysOver = nextDate == null
            ? 0
            : DateTime.now().difference(nextDate).inDays;

        overdueList.add((urgency: daysOver, bus: b));
        break;
    }
  }

  overdueList.sort((a, b) => b.urgency.compareTo(a.urgency));
  final topOverdue = overdueList.take(5).map((e) => e.bus).toList();

  // --- Órdenes ---
  final planned = orders.where((o) => o.status.name == 'planned').length;
  final open = orders.where((o) => o.status.name == 'open').length;
  final closed = orders.where((o) => o.status.name == 'closed').length;

  return DashboardStats(
    totalBuses: buses.length,
    ok: ok,
    dueSoon: dueSoon,
    overdue: overdue,
    planned: planned,
    open: open,
    closed: closed,
    topOverdue: topOverdue,
  );
});