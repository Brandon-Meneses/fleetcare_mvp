import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/fleet/domain/repositories/bus_repository.dart';
import '../../features/maintenance/domain/repositories/maintenance_repository.dart';
import '../../features/maintenance/data/api_maintenance_repository.dart';
import '../../features/notifications/data/notification_repository_api.dart';
import '../../features/fleet/data/bus_repository_api.dart';

final busRepositoryProvider = Provider<BusRepository>((ref) {
  return ApiBusRepository(); // ahora usa el backend, no memoria
});

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  // 🔹 Cambia aquí según quieras probar
  // return InMemoryMaintenanceRepository();
  return ApiMaintenanceRepository();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});