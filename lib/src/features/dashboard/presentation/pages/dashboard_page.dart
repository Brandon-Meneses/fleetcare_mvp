import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/data/auth_info.dart';
import '../../../auth/presentation/auth_controller.dart';
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
    final rolesAsync = ref.watch(rolesProvider);
    final areasAsync = ref.watch(areasProvider);

    // Esperamos roles primero
    return rolesAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
          body: Center(child: Text("Error roles: $e"))),
      data: (roles) {
        return areasAsync.when(
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
              body: Center(child: Text("Error áreas: $e"))),
          data: (areas) {
            return _DashboardContent(context, ref, roles, areas);
          },
        );
      },
    );
  }
}

Widget _DashboardContent(
    BuildContext context,
    WidgetRef ref,
    List<String> roles,
    List<String> areas,
    ) {
  final stats = ref.watch(dashboardStatsProvider);

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          const Icon(Icons.dashboard_customize_rounded),
          const SizedBox(width: 8),
          const Text('FleetCare Dashboard'),
        ],
      ),
      actions: [
        if (roles.contains("ADMIN") || areas.contains("MAINTENANCE"))
          IconButton(
            tooltip: 'Buses',
            icon: const Icon(Icons.directions_bus_rounded),
            onPressed: () => context.push('/buslist'),
          ),

        if (roles.contains("ADMIN") || areas.contains("OPERATIONS"))
          IconButton(
            tooltip: 'Órdenes',
            icon: const Icon(Icons.build_circle_rounded),
            onPressed: () => context.push('/maintenance'),
          ),

        IconButton(
          tooltip: 'Informe IA',
          icon: const Icon(Icons.auto_graph_rounded),
          onPressed: () => context.push('/report'),
        ),

        if (roles.contains("ADMIN"))
          IconButton(
            tooltip: 'Config',
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),

        if (roles.contains("ADMIN"))
          IconButton(
            tooltip: 'Crear usuario',
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => context.push('/admin/users'),
          ),

        IconButton(
          tooltip: "Cerrar sesión",
          icon: const Icon(Icons.logout_rounded),
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).logout();
          },
        ),
      ],
    ),

    body: stats.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (s) {
        final total = s.totalBuses == 0 ? 1 : s.totalBuses;

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

              // HEADER CARD
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.directions_bus_rounded,
                          size: 40, color: colorScheme.primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Bienvenido a tu panel de control",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // QUICK ACTIONS MODERNOS
              Text(
                "Acciones rápidas",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (roles.contains("ADMIN") || areas.contains("MAINTENANCE"))
                    _QuickButton(
                      label: 'Buses',
                      icon: Icons.directions_bus_filled_rounded,
                      onTap: () => context.push('/buslist'),
                    ),

                  if (roles.contains("ADMIN") || areas.contains("OPERATIONS"))
                    _QuickButton(
                      label: 'Notificaciones',
                      icon: Icons.notifications_active_rounded,
                      onTap: () => context.push('/notifications'),
                    ),

                  _QuickButton(
                    label: 'Órdenes',
                    icon: Icons.build_rounded,
                    onTap: () => context.push('/maintenance'),
                  ),

                  if (roles.contains("ADMIN"))
                    _QuickButton(
                      label: 'Crear usuario',
                      icon: Icons.person_add_rounded,
                      onTap: () => context.push('/admin/users'),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // KPI GRID
              Text(
                "Estado de la flota",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _KpiCard(title: "Total", value: s.totalBuses.toString(), color: Colors.blue),
                  _KpiCard(title: "OK", value: s.ok.toString(), color: Colors.green),
                  _KpiCard(title: "Próximo", value: s.dueSoon.toString(), color: Colors.orange),
                  _KpiCard(title: "Vencido", value: s.overdue.toString(), color: Colors.red),
                ],
              ),

              const SizedBox(height: 24),

              // PROGRESS BARS
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Distribución de estados',
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _ModernBar(label: 'OK', value: pOk, color: Colors.green),
                      _ModernBar(label: 'Próximo', value: pSoon, color: Colors.orange),
                      _ModernBar(label: 'Vencido', value: pOver, color: Colors.red),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ÓRDENES
              Text(
                "Órdenes de mantenimiento",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _KpiCard(title: "Planificadas", value: s.planned.toString(), color: Colors.indigo),
                  _KpiCard(title: "Abiertas", value: s.open.toString(), color: Colors.teal),
                  _KpiCard(title: "Cerradas", value: s.closed.toString(), color: Colors.grey),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                "Más urgentes",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _UrgentList(buses: s.topOverdue),
            ],
          ),
        );
      },
    ),
  );
}

// ---------- Widgets de apoyo ----------

class _QuickButton extends StatelessWidget {
  const _QuickButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: c.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: c.primary),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: c.primary)),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withOpacity(0.12),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ModernBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text("${(v * 100).toStringAsFixed(0)}%"),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: v,
              minHeight: 12,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
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

    final repo = ref.read(busRepositoryProvider);
    final maint = ref.read(maintenanceControllerProvider.notifier);

    return Card(
      child: Column(
        children: buses.map((bus) {
          // --- STATUS LABEL + COLOR ---
          final status = bus.status;
          String label = status!!;
          Color color = Colors.grey;

          switch (status) {
            case "OK":
              label = "OK";
              color = Colors.green;
              break;
            case "PROXIMO":
              label = "Próximo";
              color = Colors.orange;
              break;
            case "VENCIDO":
              label = "Vencido";
              color = Colors.red;
              break;
            case "FUERA_SERVICIO":
              label = "Fuera de servicio";
              color = Colors.grey;
              break;
            case "REEMPLAZADO":
              label = "Reemplazado";
              color = Colors.blueGrey;
              break;
          }

          // --- TARJETA ---
          return FutureBuilder<DateTime?>(
            future: repo.nextMaintenanceDate(bus.id),
            builder: (context, snapshot) {
              final next = snapshot.data;
              final nextStr = next == null
                  ? "-"
                  : next.toLocal().toString().split(" ").first;

              return ListTile(
                leading: Chip(
                  label: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: color.withOpacity(0.15),
                ),

                title: Text(bus.plate),

                subtitle: Text(
                  'Próx. mant.: $nextStr  •  Km: ${bus.kmCurrent}',
                ),

                trailing: Wrap(
                  spacing: 8,
                  children: [
                    if (status != "FUERA_SERVICIO" &&
                        status != "REEMPLAZADO")
                      OutlinedButton(
                        onPressed: () async {
                          await maint.planFromPrediction(bus: bus);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Orden planificada desde predicción')),
                          );
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
            },
          );
        }).toList(),
      ),
    );
  }
}