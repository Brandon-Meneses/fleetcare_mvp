import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../../maintenance/presentation/controllers/maintenance_controller.dart';
import '../../../fleet/domain/entities/bus.dart';
import '../../../fleet/domain/services/rules_service.dart';
import '../../../fleet/domain/value_objects/bus_state.dart';
import '../../../maintenance/presentation/controllers/maintenance_controller.dart' as mctl;
import '../../../settings/presentation/settings_controller.dart';
import '../dashboard_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Buses',
            icon: const Icon(Icons.directions_bus_filled_outlined),
            onPressed: () => context.push('/buslist'),
          ),
          IconButton(
            tooltip: 'Órdenes',
            icon: const Icon(Icons.build_circle_outlined),
            onPressed: () => context.push('/maintenance'),
          ),
          IconButton(
            tooltip: 'Informe IA',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => context.push('/report'),
          ),
          IconButton(
            tooltip: 'Config',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (s) {
          final total = (s.totalBuses == 0) ? 1 : s.totalBuses;
          final pOk = s.ok / total;
          final pSoon = s.dueSoon / total;
          final pOver = s.overdue / total;

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(busListControllerProvider.notifier).refresh();
              await ref.read(maintenanceControllerProvider.notifier).refresh();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Acciones rápidas
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickChip(label: 'Buses', icon: Icons.directions_bus, onTap: () => context.push('/buslist')),
                    _QuickChip(label: 'Alertas', icon: Icons.warning_amber_rounded, onTap: () => context.push('/alerts')),
                    _QuickChip(label: 'Órdenes', icon: Icons.build_circle_outlined, onTap: () => context.push('/maintenance')),
                    _QuickChip(label: 'Config', icon: Icons.settings, onTap: () => context.push('/settings')),
                  ],
                ),
                const SizedBox(height: 16),

                // KPIs principales
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatCard(title: 'Total buses', value: s.totalBuses.toString(), color: Colors.blue),
                    _StatCard(title: 'OK', value: s.ok.toString(), color: Colors.green),
                    _StatCard(title: 'Próximo', value: s.dueSoon.toString(), color: Colors.orange),
                    _StatCard(title: 'Vencido', value: s.overdue.toString(), color: Colors.red),
                  ],
                ),
                const SizedBox(height: 16),

                // Barras de distribución
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Distribución de estado', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _KpiBar(label: 'OK', value: pOk, color: Colors.green, trailing: '${(pOk*100).toStringAsFixed(0)}%'),
                        _KpiBar(label: 'Próximo', value: pSoon, color: Colors.orange, trailing: '${(pSoon*100).toStringAsFixed(0)}%'),
                        _KpiBar(label: 'Vencido', value: pOver, color: Colors.red, trailing: '${(pOver*100).toStringAsFixed(0)}%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Órdenes
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatCard(title: 'Planificadas', value: s.planned.toString(), color: Colors.indigo),
                    _StatCard(title: 'Abiertas', value: s.open.toString(), color: Colors.teal),
                    _StatCard(title: 'Cerradas', value: s.closed.toString(), color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 24),

                // Más urgentes (vencidos)
                const Text('Más urgentes (vencidos)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _UrgentList(buses: s.topOverdue),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------- Widgets de apoyo ----------

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.color});
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 96,
      child: Card(
        elevation: 0,
        color: color.withOpacity(0.12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiBar extends StatelessWidget {
  const _KpiBar({required this.label, required this.value, required this.color, this.trailing});
  final String label;
  final double value; // 0..1
  final Color color;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 88, child: Text(label)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 10,
                backgroundColor: color.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 44, child: Text(trailing ?? '', textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _UrgentList extends ConsumerWidget {
  const _UrgentList({required this.buses});
  final List<Bus> buses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (buses.isEmpty) {
      return const Text('No hay buses vencidos 🎉');
    }
    final cfg = ref.watch(configProvider);
    final maint = ref.read(maintenanceControllerProvider.notifier);

    return Card(
      child: Column(
        children: buses.map((b) {
          final due = RulesService.predictDueDate(
            bus: b,
            kmThreshold: cfg.kmThreshold,
            monthsThreshold: cfg.monthsThreshold,
            kmPerDayEstimated: 200,
          );
          final state = RulesService.computeState(
            bus: b,
            kmThreshold: cfg.kmThreshold,
            monthsThreshold: cfg.monthsThreshold,
          );
          final color = switch (state) {
            BusState.ok => Colors.green,
            BusState.dueSoon => Colors.orange,
            BusState.overdue => Colors.red,
          };

          return ListTile(
            leading: Icon(Icons.warning, color: color),
            title: Text(b.plate),
            subtitle: Text('Est.: ${due?.toLocal().toString().split(" ").first ?? "-"}  •  Km: ${b.kmCurrent}'),
            trailing: Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    await maint.planFromPrediction(bus: b);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orden planificada desde predicción')),
                      );
                    }
                  },
                  child: const Text('Agendar'),
                ),
                IconButton(
                  tooltip: 'Ver órdenes',
                  onPressed: () => context.push('/maintenance'),
                  icon: const Icon(Icons.list_alt),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}