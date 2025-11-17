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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          _chip('Todas', _Filter.all),
          _chip('Planificadas', _Filter.planned),
          _chip('Abiertas', _Filter.open),
          _chip('Cerradas', _Filter.closed),
        ],
      ),
    );
  }

  Widget _chip(String label, _Filter value) => ChoiceChip(
    label: Text(label),
    selected: current == value,
    onSelected: (_) => onChanged(value),
  );
}

class _OrderTile extends ConsumerWidget {
  const _OrderTile({required this.order, required this.canManage});
  final MaintenanceOrder order;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maint = ref.read(maintenanceControllerProvider.notifier);
    final busRepo = ref.read(busRepositoryProvider);

    return FutureBuilder(
      future: busRepo.findById(order.busId),
      builder: (context, snap) {
        final plate = snap.data?.plate ?? order.busId;

        final subtitles = <String>[];
        if (order.plannedAt != null) subtitles.add("Planificada: ${_fmt(order.plannedAt)}");
        if (order.openedAt != null) subtitles.add("Abierta: ${_fmt(order.openedAt)}");
        if (order.closedAt != null) subtitles.add("Cerrada: ${_fmt(order.closedAt)}");
        if ((order.notes ?? "").isNotEmpty) subtitles.add("Notas: ${order.notes}");

        return ListTile(
          title: Text("${order.type.name.toUpperCase()} • ${order.status.label}"),
          subtitle: Text("Bus: $plate  •  ${subtitles.join("  •  ")}"),
          trailing: canManage
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (order.status == MaintenanceStatus.planned)
                IconButton(
                  tooltip: "Abrir orden",
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () async {
                    await maint.openOrder(order);
                    ref.refresh(maintenanceControllerProvider); // 👈 refresh UI
                  },
                ),
              if (order.status == MaintenanceStatus.open)
                IconButton(
                  tooltip: "Cerrar orden",
                  icon: const Icon(Icons.check),
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
              : null,
        );
      },
    );
  }

  String _fmt(DateTime? d) => d == null ? "-" : d.toLocal().toString().split(" ").first;
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
    return AlertDialog(
      title: const Text('Notas de cierre'),
      content: TextField(controller: _c, decoration: const InputDecoration(hintText: 'Opcional')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(context, _c.text.trim()), child: const Text('Guardar')),
      ],
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
  final _notesCtrl = TextEditingController();
  String? _busId;

  @override
  Widget build(BuildContext context) {
    final buses = ref.watch(busListControllerProvider).value ?? [];

    return AlertDialog(
      title: const Text("Nueva orden"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Bus"),
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
          const SizedBox(height: 12),
          DropdownButtonFormField<MaintenanceType>(
            value: _type,
            decoration: const InputDecoration(labelText: "Tipo"),
            items: MaintenanceType.values
                .map((t) =>
                DropdownMenuItem(value: t, child: Text(t.name.toUpperCase())))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(labelText: "Notas"),
          )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        FilledButton(
          onPressed: () {
            if (_busId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Seleccione un bus")),
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
    );
  }
}