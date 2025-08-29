import 'dart:math';
import '../domain/entities/maintenance_order.dart';
import '../domain/repositories/maintenance_repository.dart';

class InMemoryMaintenanceRepository implements MaintenanceRepository {
  final _store = <String, MaintenanceOrder>{};
  final _rand = Random();

  @override
  Future<List<MaintenanceOrder>> list() async =>
      _store.values.toList()
        ..sort((a, b) => (a.plannedAt ?? a.openedAt ?? DateTime(0))
            .compareTo(b.plannedAt ?? b.openedAt ?? DateTime(0)));

  @override
  Future<List<MaintenanceOrder>> listByBus(String busId) async =>
      (await list()).where((o) => o.busId == busId).toList();

  @override
  Future<MaintenanceOrder> upsert(MaintenanceOrder o) async {
    final id = o.id.isEmpty ? _genId() : o.id;
    final data = o.copyWith(id: id);
    _store[id] = data;
    return data;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
  }

  @override
  Future<MaintenanceOrder?> findById(String id) async => _store[id];

  String _genId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_rand.nextInt(1000000000)}';
}