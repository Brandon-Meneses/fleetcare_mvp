import '../entities/maintenance_order.dart';

abstract class MaintenanceRepository {
  Future<List<MaintenanceOrder>> list();
  Future<List<MaintenanceOrder>> listByBus(String busId);
  Future<MaintenanceOrder> upsert(MaintenanceOrder order);
  Future<void> delete(String id);
  Future<MaintenanceOrder?> findById(String id);
}