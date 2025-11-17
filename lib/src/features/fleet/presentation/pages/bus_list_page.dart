import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../auth/data/auth_info.dart';
import '../../domain/entities/bus.dart';
import '../controllers/bus_list_controller.dart';
import '../../../settings/presentation/settings_controller.dart';
import '../../../settings/domain/config.dart';
import '../../domain/value_objects/bus_state.dart';
import '../../domain/services/rules_service.dart';
import '../../../maintenance/presentation/controllers/maintenance_controller.dart';
import '../../../maintenance/domain/value_objects/maintenance_enums.dart';
import '../../../maintenance/domain/entities/maintenance_order.dart';


class BusListPage extends ConsumerWidget {
  const BusListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(busListControllerProvider);
    final rolesAsync = ref.watch(rolesProvider);
    final areasAsync = ref.watch(areasProvider);

    return rolesAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error roles: $e"))),
      data: (roles) {
        return areasAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text("Error áreas: $e"))),
          data: (areas) {
            final canCreate = Perms.canCreateBus(areas, roles);
            final canViewOrders = Perms.canViewOrders(areas, roles);

            return Scaffold(
              appBar: AppBar(
                title: const Text("Buses"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dashboard_outlined),
                    onPressed: () => context.push("/dashboard"),
                  ),
                ],
              ),

              floatingActionButton: canCreate
                  ? FloatingActionButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const _BusFormDialog(),
                  );
                  await ref.read(busListControllerProvider.notifier).refresh();
                },
                child: const Icon(Icons.add),
              )
                  : null,

              body: busesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data: (buses) => _BusListView(
                  buses: buses,
                  roles: roles,
                  areas: areas,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BusListView extends ConsumerWidget {
  const _BusListView({required this.buses, required this.roles, required this.areas});

  final List<Bus> buses;
  final List<String> roles;
  final List<String> areas;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (buses.isEmpty) {
      return const Center(child: Text("No hay buses registrados"));
    }

    return ListView.separated(
      itemCount: buses.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final bus = buses[i];

        final canEdit = Perms.canEditBus(areas, roles);
        final canDelete = Perms.canDeleteBus(areas, roles);
        final canPlan = Perms.canPlanMaintenance(areas, roles);
        final canViewOrders = Perms.canViewOrders(areas, roles);
        final canDecommission = Perms.canDecommission(areas, roles);
        final canReplace = Perms.canReplace(areas, roles);

        return ListTile(
          title: Text(bus.plate),
          subtitle: Text("Km: ${bus.kmCurrent}"),
          onTap: canEdit
              ? () async {
            await showDialog(
              context: context,
              builder: (_) => _BusFormDialog(initial: bus),
            );
            await ref.read(busListControllerProvider.notifier).refresh();
          }
              : null,
          trailing: PopupMenuButton<String>(
            itemBuilder: (_) {
              final items = <PopupMenuEntry<String>>[];

              if (canPlan)
                items.add(const PopupMenuItem(value: "plan", child: Text("Agendar por predicción")));

              if (canViewOrders)
                items.add(const PopupMenuItem(value: "viewOrders", child: Text("Ver órdenes")));

              if (canDelete)
                items.add(const PopupMenuItem(value: "delete", child: Text("Eliminar bus")));

              if (canDecommission)
                items.add(const PopupMenuItem(value: "decommission", child: Text("Marcar fuera de servicio")));

              if (canReplace)
                items.add(const PopupMenuItem(value: "replace", child: Text("Registrar reemplazo")));

              // fallback si no tiene permisos
              if (items.isEmpty) {
                items.add(const PopupMenuItem(
                  enabled: false,
                  child: Text("Sin acciones disponibles"),
                ));
              }

              return items;
            },
            onSelected: (value) async {
              print("SELECCIONADO: $value");

              final controller = ref.read(busListControllerProvider.notifier);

              switch (value) {
                case "plan":
                  await ref.read(maintenanceControllerProvider.notifier)
                      .planFromPrediction(bus: bus);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Orden planificada desde predicción')),
                    );
                  }
                  break;

                case "viewOrders":
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => _OrdersDialog(busId: bus.id, plate: bus.plate),
                    );
                  }
                  break;

                case "delete":
                  await controller.remove(bus.id);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bus ${bus.plate} eliminado')),
                    );
                  }
                  break;

                case "decommission":
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Confirmar acción'),
                      content: Text('¿Deseas marcar el bus ${bus.plate} como fuera de servicio?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await ref.read(busRepositoryProvider)
                        .updateStatus(bus.id, "FUERA_SERVICIO");
                    await ref.read(busListControllerProvider.notifier).refresh();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bus ${bus.plate} marcado como fuera de servicio')),
                      );
                    }
                  }
                  break;

                case "replace":
                  final replacementPlate = await showDialog<String>(
                    context: context,
                    builder: (_) {
                      final controller = TextEditingController();
                      return AlertDialog(
                        title: const Text('Registrar reemplazo'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(labelText: 'Placa del nuevo bus'),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, controller.text.trim()),
                            child: const Text('Guardar'),
                          ),
                        ],
                      );
                    },
                  );

                  if (replacementPlate != null && replacementPlate.isNotEmpty) {
                    // 1) Crear el nuevo bus
                    final newBus = await ref.read(busRepositoryProvider).upsert(
                      Bus(
                        id: '',
                        plate: replacementPlate,
                        kmCurrent: 0,
                        lastServiceAt: DateTime.now(),
                      ),
                    );

                    // 2) Actualizar el bus original como reemplazado
                    await ref.read(busRepositoryProvider).updateStatus(
                      bus.id,
                      "REEMPLAZADO",
                      replacementId: newBus.id,
                    );

                    await ref.read(busListControllerProvider.notifier).refresh();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bus ${bus.plate} reemplazado por ${newBus.plate}')),
                      );
                    }
                  }
                  break;
              }
            },
          ),
        );
      },
    );
  }
}

class _BusFormDialog extends ConsumerStatefulWidget {
  const _BusFormDialog({this.initial, super.key});
  final Bus? initial;

  @override
  ConsumerState<_BusFormDialog> createState() => _BusFormDialogState();
}

class _BusFormDialogState extends ConsumerState<_BusFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _plate;
  late final TextEditingController _km;
  DateTime? _lastServiceAt;
  final TextEditingController _alias = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _plate = TextEditingController(text: widget.initial?.plate ?? '');
    _km = TextEditingController(text: (widget.initial?.kmCurrent ?? 0).toString());
    _lastServiceAt = widget.initial?.lastServiceAt ?? DateTime.now();
    _alias.text = widget.initial?.alias ?? '';
    _notes.text = widget.initial?.notes ?? '';
  }

  @override
  void dispose() {
    _plate.dispose();
    _km.dispose();
    _alias.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return AlertDialog(
      title: Text(isEdit ? 'Editar bus' : 'Nuevo bus'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _plate,
              decoration: const InputDecoration(labelText: 'Placa *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _km,
              decoration: const InputDecoration(labelText: 'Km actual *'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requerido';
                final n = int.tryParse(v);
                if (n == null || n < 0) return 'Km inválido';
                final last = widget.initial?.kmCurrent ?? 0;
                if (isEdit && n < last) return 'No puede ser menor al último ($last)';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Último mantenimiento: '),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _lastServiceAt ?? DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _lastServiceAt = picked);
                  },
                  child: Text(
                    _lastServiceAt == null
                        ? 'Elegir fecha'
                        : _lastServiceAt!.toLocal().toString().split(' ').first,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _alias,
              decoration: const InputDecoration(labelText: 'Alias'),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notas'),
              maxLines: 2,
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Revisa los campos obligatorios')),
                );
              }
              return;
            }
            final notifier = ref.read(busListControllerProvider.notifier);
            final isEdit = widget.initial != null;
            final bus = (widget.initial ?? Bus(id: '', plate: _plate.text.trim(), kmCurrent: 0)).copyWith(
              plate: _plate.text.trim(),
              kmCurrent: int.parse(_km.text),
              lastServiceAt: _lastServiceAt,
              alias: _alias.text.trim().isEmpty ? null : _alias.text.trim(),
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
            );
            await notifier.save(bus);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isEdit ? 'Bus actualizado' : 'Bus creado')),
              );
            }
          },
          child: Text(isEdit ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}

class _OrdersDialog extends ConsumerWidget {
  const _OrdersDialog({required this.busId, required this.plate, super.key});
  final String busId;
  final String plate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Órdenes • $plate'),
      content: SizedBox(
        width: 420,
        child: FutureBuilder(
          future: ref.read(maintenanceControllerProvider.notifier).ordersForBus(busId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
            }
            final items = snapshot.data!;
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No hay órdenes para este bus.'),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final o = items[i];
                return ListTile(
                  title: Text('${o.type.name.toUpperCase()} • ${o.status.name.toUpperCase()}'),
                  subtitle: Text([
                    if (o.plannedAt != null) 'Planificada: ${o.plannedAt!.toLocal().toString().split(" ").first}',
                    if (o.openedAt  != null) 'Abierta: ${o.openedAt!.toLocal().toString().split(" ").first}',
                    if (o.closedAt  != null) 'Cerrada: ${o.closedAt!.toLocal().toString().split(" ").first}',
                    if (o.notes != null && o.notes!.isNotEmpty) 'Notas: ${o.notes}',
                  ].join('  •  ')),
                  trailing: _OrderActions(order: o),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        TextButton(
          onPressed: () async {
            // atajo: planificar manual para mañana
            final bus = await ref.read(busRepositoryProvider).findById(busId);
            if (bus != null) {
              await ref.read(maintenanceControllerProvider.notifier).planFromPrediction(
                bus: bus,
                targetDate: DateTime.now().add(const Duration(days: 1)),
              );
              (context as Element).markNeedsBuild(); // refrescar el diálogo
            }
          },
          child: const Text('Planificar (+1 día)'),
        ),
      ],
    );
  }
}

class _OrderActions extends ConsumerWidget {
  const _OrderActions({required this.order, super.key});
  final MaintenanceOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maint = ref.read(maintenanceControllerProvider.notifier);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (order.status == MaintenanceStatus.planned)
        IconButton(
          tooltip: 'Abrir',
          onPressed: () => maint.openOrder(order),
          icon: const Icon(Icons.play_arrow),
        ),
      if (order.status == MaintenanceStatus.open)
        IconButton(
          tooltip: 'Cerrar',
          onPressed: () async {
            final notes = await showDialog<String>(
              context: context,
              builder: (_) => const _CloseNotesDialog(),
            );
            await maint.closeOrder(order, notes: notes);
          },
          icon: const Icon(Icons.check),
        ),
    ]);
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