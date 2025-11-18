import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../auth/data/auth_info.dart';
import '../../auth/data/auth_state.dart';
import '../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/report_service.dart';
import '../domain/report_models.dart';
import '../../fleet/domain/entities/bus.dart';
import '../../auth/data/ApiConfig.dart';

final reportServiceProvider = FutureProvider<ReportService>((ref) async {
  final areasAsync = await ref.watch(areasProvider.future);

  // Elegimos el área del usuario
  final area = areasAsync.isNotEmpty ? areasAsync.first : "MAINTENANCE";

  final backendUrl = '${ApiConfig.baseUrl}/report/area/$area';
  print("🔎 ReportService inicializado con $backendUrl");

  return ReportService(Dio(), backendUrl: backendUrl);
});

final reportControllerProvider = StateNotifierProvider<ReportController, AsyncValue<ReportResponse?>>((ref) {
  return ReportController(ref);
});

class ReportController extends StateNotifier<AsyncValue<ReportResponse?>> {
  ReportController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> generate() async {
    final busesState = ref.read(busListControllerProvider);
    final cfg = ref.read(configProvider);

    state = const AsyncValue.loading();

    try {
      final buses = busesState.hasValue ? busesState.value! : <Bus>[];

      // Esperar a que el servicio esté disponible
      final service = await ref.read(reportServiceProvider.future);

      // Llamar al backend correcto
      final result = await service.generateReport(buses: buses, config: cfg);

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}