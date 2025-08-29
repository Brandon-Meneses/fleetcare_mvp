import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../fleet/domain/entities/bus.dart';
import '../../../fleet/domain/services/rules_service.dart';
import '../../../settings/presentation/settings_controller.dart';
import '../../domain/entities/maintenance_order.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/value_objects/maintenance_enums.dart';
import '../../../../core/di/providers.dart';

final maintenanceControllerProvider = StateNotifierProvider<
    MaintenanceController, AsyncValue<List<MaintenanceOrder>>>(
      (ref) => MaintenanceController(ref)..refresh(),
);

class MaintenanceController extends StateNotifier<AsyncValue<List<MaintenanceOrder>>> {
  final Ref ref;
  MaintenanceController(this.ref) : super(const AsyncValue.loading());

  Future<void> refresh() async {
    final repo = ref.read(maintenanceRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.list());
  }

  /// Crea una ORDEN PLANIFICADA usando la predicción (o una fecha objetivo).
  Future<void> planFromPrediction({
    required Bus bus,
    DateTime? targetDate, // si no se envía, usa la predicción
    MaintenanceType type = MaintenanceType.preventive,
  }) async {
    final cfg = ref.read(configProvider);
    final repo = ref.read(maintenanceRepositoryProvider);

    DateTime? planned = targetDate ??
        RulesService.predictDueDate(
          bus: bus,
          kmThreshold: cfg.kmThreshold,
          monthsThreshold: cfg.monthsThreshold,
          kmPerDayEstimated: 200, // por ahora; luego lo calculamos de histórico
        );

    planned ??= DateTime.now(); // fallback: hoy

    await repo.upsert(MaintenanceOrder(
      id: '',
      busId: bus.id,
      status: MaintenanceStatus.planned,
      type: type,
      plannedAt: planned,
      notes: 'Auto-agendada',
    ));
    await refresh();
  }

  Future<void> openOrder(MaintenanceOrder order) async {
    final repo = ref.read(maintenanceRepositoryProvider);
    await repo.upsert(order.copyWith(
      status: MaintenanceStatus.open,
      openedAt: DateTime.now(),
    ));
    await refresh();
  }

  Future<void> closeOrder(MaintenanceOrder order, {String? notes}) async {
    final repo = ref.read(maintenanceRepositoryProvider);
    await repo.upsert(order.copyWith(
      status: MaintenanceStatus.closed,
      closedAt: DateTime.now(),
      notes: notes ?? order.notes,
    ));
    await refresh();
  }

  Future<List<MaintenanceOrder>> ordersForBus(String busId) =>
      ref.read(maintenanceRepositoryProvider).listByBus(busId);
}