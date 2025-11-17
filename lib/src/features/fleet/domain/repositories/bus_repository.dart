import '../entities/bus.dart';

abstract class BusRepository {
  Future<List<Bus>> list();
  Future<Bus> upsert(Bus bus);   // crea/actualiza
  Future<void> delete(String id);
  Future<Bus?> findById(String id);
  Future<void> updateStatus(String id, String status, {String? replacementId});
  Future<DateTime?> nextMaintenanceDate(String busId);

}