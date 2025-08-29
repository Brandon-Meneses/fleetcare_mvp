import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../fleet/domain/entities/bus.dart';
import '../../../fleet/domain/repositories/bus_repository.dart';
import '../../../../core/di/providers.dart';

final busListControllerProvider =
StateNotifierProvider<BusListController, AsyncValue<List<Bus>>>(
      (ref) => BusListController(ref)..refresh(),
);

class BusListController extends StateNotifier<AsyncValue<List<Bus>>> {
  final Ref ref; // <-- en Riverpod 2 se usa Ref
  BusListController(this.ref) : super(const AsyncValue.loading());

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = ref.read(busRepositoryProvider);
    state = await AsyncValue.guard(() => repo.list());
  }

  Future<void> save(Bus bus) async {
    final repo = ref.read(busRepositoryProvider);
    await repo.upsert(bus);
    await refresh();
  }

  Future<void> remove(String id) async {
    final repo = ref.read(busRepositoryProvider);
    await repo.delete(id);
    await refresh();
  }
}