import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/report_service.dart';
import '../domain/report_models.dart';
import '../../fleet/domain/entities/bus.dart';

final reportServiceProvider = Provider<ReportService>((ref) {
  // TODO: reemplaza por tu endpoint real
  const backendUrl = 'https://your-backend.example.com/report';
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
    final service = ref.read(reportServiceProvider);

    state = const AsyncValue.loading();

    final List<Bus> buses = busesState.hasValue ? busesState.value! : <Bus>[];

    try {
      final result = await service.generateReport(buses: buses, config: cfg);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}