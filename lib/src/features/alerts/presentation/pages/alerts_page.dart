import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../../settings/presentation/settings_controller.dart';
import '../../../fleet/domain/services/rules_service.dart';
import '../../../fleet/domain/value_objects/bus_state.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(busListControllerProvider);
    final cfg = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (buses) {
          final alerts = buses.where((b) {
            final s = RulesService.computeState(
              bus: b,
              kmThreshold: cfg.kmThreshold,
              monthsThreshold: cfg.monthsThreshold,
            );
            return s != BusState.ok;
          }).toList();
          if (alerts.isEmpty) return const Center(child: Text('Sin alertas'));
          return ListView.separated(
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final b = alerts[i];
              final s = RulesService.computeState(
                  bus: b, kmThreshold: cfg.kmThreshold, monthsThreshold: cfg.monthsThreshold);
              final due = RulesService.predictDueDate(
                  bus: b, kmThreshold: cfg.kmThreshold, monthsThreshold: cfg.monthsThreshold, kmPerDayEstimated: 200);
              return ListTile(
                title: Text(b.plate),
                subtitle: Text('Estado: ${s.label}${due != null ? ' • Est.: ${due.toLocal().toString().split(" ").first}' : ''}'),
              );
            },
          );
        },
      ),
    );
  }
}