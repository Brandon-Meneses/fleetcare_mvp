import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/fleet/data/bus_repository_impl.dart';
import '../../features/fleet/domain/repositories/bus_repository.dart';
import '../../features/maintenance/data/maintenance_repository_impl.dart';
import '../../features/maintenance/domain/repositories/maintenance_repository.dart';
import '../../features/maintenance/data/api_maintenance_repository.dart';

final busRepositoryProvider = Provider<BusRepository>((ref) {
  // Más adelante cambias a Isar/Supabase sin tocar la UI
  return InMemoryBusRepository();
});

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  // 🔹 Cambia aquí según quieras probar
  // return InMemoryMaintenanceRepository();
  return ApiMaintenanceRepository();
});