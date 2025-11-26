import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/auth_info.dart';
import '../../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../../maintenance/domain/entities/maintenance_order.dart';
import '../../../maintenance/domain/value_objects/maintenance_enums.dart';
import '../../../../core/di/providers.dart';
import '../controllers/maintenance_controller.dart';


enum _Filter { all, planned, open, closed }

class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(maintenanceControllerProvider);

    // === Roles y áreas ===
    final roles = ref.watch(rolesProvider).value ?? [];
    final areas = ref.watch(areasProvider).value ?? [];

    final canManage = roles.contains("ADMIN") || areas.contains("OPERATIONS");

    return Scaffold(
      appBar: AppBar(title: const Text("Órdenes de mantenimiento")),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _FilterBar(
            current: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          const Divider(height: 1),

          Expanded(
            child: ordersState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (orders) {
                final items = orders.where((o) {
                  return switch (_filter) {
                    _Filter.all => true,
                    _Filter.planned => o.status == MaintenanceStatus.planned,
                    _Filter.open => o.status == MaintenanceStatus.open,
                    _Filter.closed => o.status == MaintenanceStatus.closed,
                  };
                }).toList();

                if (items.isEmpty) {
                  return const Center(child: Text("No hay órdenes en este filtro"));
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) =>
                      _OrderTile(order: items[i], canManage: canManage),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: canManage
          ? FloatingActionButton(
        tooltip: "Nueva orden",
        onPressed: () async {
          final newOrder = await showDialog<MaintenanceOrder>(
            context: context,
            builder: (_) => const _NewOrderDialog(),
          );

          if (newOrder != null) {
            await ref
                .read(maintenanceControllerProvider.notifier)
                .createOrder(newOrder);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Orden creada")),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.current, required this.onChanged});

  final _Filter current;
  final ValueChanged<_Filter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          _pill(context, "Todas", Icons.list_alt, _Filter.all),
          _pill(context, "Planificadas", Icons.schedule, _Filter.planned),
          _pill(context, "Abiertas", Icons.play_arrow, _Filter.open),
          _pill(context, "Cerradas", Icons.check_circle, _Filter.closed),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label, IconData icon, _Filter value) {
    final isSelected = current == value;
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selectedColor: color.withOpacity(0.18),
        avatar: Icon(icon, size: 18, color: isSelected ? color : null),
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onChanged(value),
      ),
    );
  }
}

class _OrderTile extends ConsumerWidget {
  const _OrderTile({required this.order, required this.canManage});
  final MaintenanceOrder order;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busRepo = ref.read(busRepositoryProvider);
    final maint = ref.read(maintenanceControllerProvider.notifier);

    final color = _statusColor(order.status);
    final icon = _statusIcon(order.status);
    final typeIcon = _typeIcon(order.type);

    return FutureBuilder(
      future: busRepo.findById(order.busId),
      builder: (context, snap) {
        final plate = snap.data?.plate ?? order.busId;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => _OrderDetailDialog(order: order, plate: plate),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // --- CABECERA ---
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(icon, color: color, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${order.type.name.toUpperCase()} • ${order.status.label}",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // --- DATOS ---
                  Row(
                    children: [
                      Icon(typeIcon, size: 18),
                      const SizedBox(width: 6),
                      Text("Bus: $plate"),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ..._buildDates(order),

                  if ((order.notes ?? "").isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.note_alt_outlined, size: 18),
                        const SizedBox(width: 6),
                        Expanded(child: Text(order.notes!)),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // --- ACCIONES ---
                  if (canManage)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (order.status == MaintenanceStatus.planned)
                          FilledButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            label: const Text("Abrir"),
                            onPressed: () async {
                              await maint.openOrder(order);
                              ref.refresh(maintenanceControllerProvider);
                            },
                          ),

                        if (order.status == MaintenanceStatus.open)
                          FilledButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text("Cerrar"),
                            onPressed: () async {
                              final notes = await showDialog<String>(
                                context: context,
                                builder: (_) => const _CloseNotesDialog(),
                              );
                              await maint.closeOrder(order, notes: notes);
                              ref.refresh(maintenanceControllerProvider);
                            },
                          ),
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---- Helpers visuales ----

  List<Widget> _buildDates(MaintenanceOrder o) {
    final widgets = <Widget>[];

    if (o.plannedAt != null)
      widgets.add(_date("Planificada", Icons.calendar_month, o.plannedAt!));

    if (o.openedAt != null)
      widgets.add(_date("Abierta", Icons.play_circle_fill, o.openedAt!));

    if (o.closedAt != null)
      widgets.add(_date("Cerrada", Icons.check_circle, o.closedAt!));

    return widgets;
  }

  Widget _date(String label, IconData icon, DateTime date) {
    final formatted = date.toLocal().toString().split(" ").first;
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text("$label: $formatted"),
      ],
    );
  }

  IconData _statusIcon(MaintenanceStatus s) {
    return switch (s) {
      MaintenanceStatus.planned => Icons.schedule,
      MaintenanceStatus.open => Icons.play_arrow,
      MaintenanceStatus.closed => Icons.check_circle,
    };
  }

  IconData _typeIcon(MaintenanceType t) {
    return switch (t) {
      MaintenanceType.preventive => Icons.construction,
      MaintenanceType.corrective => Icons.build,
    };
  }

  Color _statusColor(MaintenanceStatus s) {
    return switch (s) {
      MaintenanceStatus.planned => Colors.blue,
      MaintenanceStatus.open => Colors.orange,
      MaintenanceStatus.closed => Colors.green,
    };
  }
}

class _OrderDetailDialog extends StatelessWidget {
  const _OrderDetailDialog({
    super.key,
    required this.order,
    required this.plate,
  });

  final MaintenanceOrder order;
  final String plate;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    final statusIcon = _statusIcon(order.status);
    final typeIcon = _typeIcon(order.type);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: statusColor.withOpacity(0.15),
                    child: Icon(statusIcon, color: statusColor, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.type == MaintenanceType.preventive
                              ? "Mantenimiento preventivo"
                              : "Mantenimiento correctivo",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.status.label, // PLANIFICADA / ABIERTA / CERRADA
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(typeIcon, size: 16),
                                const SizedBox(width: 4),
                                Text("Bus: $plate"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // FECHAS
              _infoRow(
                context,
                icon: Icons.calendar_month,
                label: "Planificada",
                value: _fmt(order.plannedAt),
              ),
              _infoRow(
                context,
                icon: Icons.play_circle_outline,
                label: "Abierta",
                value: _fmt(order.openedAt),
              ),
              _infoRow(
                context,
                icon: Icons.check_circle_outline,
                label: "Cerrada",
                value: _fmt(order.closedAt),
              ),

              const SizedBox(height: 16),

              // NOTAS
              if ((order.notes ?? "").isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notas",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.4),
                      ),
                      child: Text(order.notes!),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // BOTÓN CERRAR
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Helpers visuales (solo para este diálogo) ----

  static String _fmt(DateTime? d) {
    if (d == null) return "-";
    return d.toLocal().toString().split(" ").first;
  }

  static Color _statusColor(MaintenanceStatus s) {
    switch (s) {
      case MaintenanceStatus.planned:
        return Colors.blue;
      case MaintenanceStatus.open:
        return Colors.orange;
      case MaintenanceStatus.closed:
        return Colors.green;
    }
  }

  static IconData _statusIcon(MaintenanceStatus s) {
    switch (s) {
      case MaintenanceStatus.planned:
        return Icons.schedule;
      case MaintenanceStatus.open:
        return Icons.play_arrow;
      case MaintenanceStatus.closed:
        return Icons.check_circle;
    }
  }

  static IconData _typeIcon(MaintenanceType t) {
    switch (t) {
      case MaintenanceType.preventive:
        return Icons.construction;
      case MaintenanceType.corrective:
        return Icons.build;
    }
  }

  Widget _infoRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            "$label:",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseNotesDialog extends StatefulWidget {
  const _CloseNotesDialog({super.key});

  @override
  State<_CloseNotesDialog> createState() => _CloseNotesDialogState();
}

class _CloseNotesDialogState extends State<_CloseNotesDialog> {
  final _c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 44,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              "Cerrar orden",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar")),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () =>
                      Navigator.pop(context, _c.text.trim()),
                  child: const Text("Guardar"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NewOrderDialog extends ConsumerStatefulWidget {
  const _NewOrderDialog({super.key});

  @override
  ConsumerState<_NewOrderDialog> createState() => _NewOrderDialogState();
}

class _NewOrderDialogState extends ConsumerState<_NewOrderDialog> {
  MaintenanceType _type = MaintenanceType.preventive;
  String? _busId;
  final _notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final buses = ref.watch(busListControllerProvider).value ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.build_circle,
                  size: 42,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),

              Text(
                "Crear orden de mantenimiento",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Bus",
                  prefixIcon: Icon(Icons.directions_bus),
                ),
                value: _busId,
                items: buses
                    .map((b) => DropdownMenuItem(
                  value: b.id,
                  child: Text("${b.plate}  (km: ${b.kmCurrent})"),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _busId = v),
                validator: (v) => v == null ? "Seleccione un bus" : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<MaintenanceType>(
                decoration: const InputDecoration(
                  labelText: "Tipo",
                  prefixIcon: Icon(Icons.category),
                ),
                value: _type,
                items: MaintenanceType.values
                    .map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(
                    t == MaintenanceType.preventive
                        ? "Preventivo"
                        : "Correctivo",
                  ),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Notas",
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar")),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      if (_busId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Seleccione un bus")),
                        );
                        return;
                      }

                      Navigator.pop(
                        context,
                        MaintenanceOrder(
                          id: "",
                          busId: _busId!,
                          type: _type,
                          status: MaintenanceStatus.planned,
                          plannedAt: DateTime.now(),
                          notes: _notesCtrl.text.trim(),
                        ),
                      );
                    },
                    child: const Text("Crear"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}