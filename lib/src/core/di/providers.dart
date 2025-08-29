import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/fleet/data/bus_repository_impl.dart';
import '../../features/fleet/domain/repositories/bus_repository.dart';

final busRepositoryProvider = Provider<BusRepository>((ref) {
  // Más adelante cambias a Isar/Supabase sin tocar la UI
  return InMemoryBusRepository();
});