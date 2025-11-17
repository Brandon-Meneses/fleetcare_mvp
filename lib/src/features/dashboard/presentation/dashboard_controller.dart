import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../fleet/domain/services/rules_service.dart';
import '../../fleet/domain/value_objects/bus_state.dart';
import '../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../maintenance/presentation/controllers/maintenance_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/dashboard_stats.dart';
import '../../fleet/domain/entities/bus.dart';

final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final busesState = ref.watch(busListControllerProvider);
  final ordersState = ref.watch(maintenanceControllerProvider);

  if (busesState.isLoading || ordersState.isLoading) {
    return const AsyncValue.loading();
  }

  return busesState.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (buses) {
      return ordersState.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (orders) {
          int ok = 0, dueSoon = 0, overdue = 0;
          final overdueList = <({int urgency, Bus bus})>[];

          for (final b in buses) {
            final status = b.status; // <- estado real del backend

            switch (status) {
              case "OK":
                ok++;
                break;

              case "PROXIMO":
                dueSoon++;
                break;

              case "VENCIDO":
                overdue++;

                final due = RulesService.predictDueDate(
                  bus: b,
                  kmThreshold: ref.read(configProvider).kmThreshold,
                  monthsThreshold: ref.read(configProvider).monthsThreshold,
                  kmPerDayEstimated: 200,
                );

                final daysOver = due == null
                    ? 0
                    : DateTime.now().difference(due).inDays;

                overdueList.add((urgency: daysOver, bus: b));
                break;
            }
          }

          overdueList.sort((a, b) => b.urgency.compareTo(a.urgency));
          final topOverdue = overdueList.take(5).map((e) => e.bus).toList();

          final planned = orders.where((o) => o.status.name == 'planned').length;
          final open = orders.where((o) => o.status.name == 'open').length;
          final closed = orders.where((o) => o.status.name == 'closed').length;

          return AsyncValue.data(
            DashboardStats(
              totalBuses: buses.length,
              ok: ok,
              dueSoon: dueSoon,
              overdue: overdue,
              planned: planned,
              open: open,
              closed: closed,
              topOverdue: topOverdue,
            ),
          );
        },
      );
    },
  );
});