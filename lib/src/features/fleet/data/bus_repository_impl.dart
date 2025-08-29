import 'dart:math';
import '../domain/entities/bus.dart';
import '../domain/repositories/bus_repository.dart';
import 'package:uuid/uuid.dart';

class InMemoryBusRepository implements BusRepository {
  final _store = <String, Bus>{};
  final _uuid = const Uuid();

  @override
  Future<List<Bus>> list() async {
    final items = _store.values.toList();
    items.sort((a, b) => a.plate.compareTo(b.plate));
    return items;
  }

  @override
  Future<Bus> upsert(Bus bus) async {
    final id = (bus.id.isEmpty) ? _genId() : bus.id;
    final data = bus.copyWith(id: id);
    _store[id] = data;
    return data;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
  }

  @override
  Future<Bus?> findById(String id) async => _store[id];

  String _genId() => _uuid.v4();
}