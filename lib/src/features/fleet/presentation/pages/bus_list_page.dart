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

        return FutureBuilder<DateTime?>(
          future: ref.read(busRepositoryProvider).nextMaintenanceDate(bus.id),
          builder: (context, snap) {
            DateTime? nextDate;

            if (snap.connectionState == ConnectionState.waiting) {
              nextDate = null;
            } else if (snap.hasData) {
              nextDate = snap.data;
            }

            /*final formattedNext = nextDate == null
                ? "-"
                : nextDate.toLocal().toString().split(" ").first;

            final formattedLast = bus.lastMaintenanceDate == null
                ? "-"
                : bus.lastMaintenanceDate!.toLocal().toString().split(" ").first;*/

            // dentro de itemBuilder: (_, i) {
            final bus = buses[i];

            return ListTile(
              title: Row(
                children: [
                  Text(bus.plate),
                  const SizedBox(width: 12),
                  Chip(
                    label: Text(
                      bus.status ?? '-',
                      style: TextStyle(
                        color: _statusColor(bus.status ?? ''),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _statusColor(bus.status ?? '').withOpacity(0.15),
                  ),
                ],
              ),

              subtitle: Text(
                [
                  'Km: ${bus.kmCurrent}',
                  'Último: ${bus.lastMaintenanceDate == null
                      ? "-"
                      : bus.lastMaintenanceDate!.toLocal().toString().split(" ").first}',
                  'Próx.: ${bus.nextMaintenanceDate == null
                      ? "-"
                      : bus.nextMaintenanceDate!.toLocal().toString().split(" ").first}',
                ].join(' • '),
              ),

              onTap: () async {
                if (bus.status == "FUERA_SERVICIO" || bus.status == "REEMPLAZADO") return;

                await showDialog(
                  context: context,
                  builder: (_) => _BusFormDialog(initial: bus),
                );

                await ref.read(busListControllerProvider.notifier).refresh();
              },

              trailing: PopupMenuButton<String>(
                enabled: bus.status != "REEMPLAZADO",
                onSelected: (value) async {
                  final repo = ref.read(busRepositoryProvider);
                  final maint = ref.read(maintenanceControllerProvider.notifier);

                  switch (value) {
                    case "plan":
                      if (["OK", "PROXIMO", "VENCIDO"].contains(bus.status)) {
                        await maint.planFromPrediction(bus: bus);
                      }
                      break;

                    case "viewOrders":
                      showDialog(
                        context: context,
                        builder: (_) => _OrdersDialog(busId: bus.id, plate: bus.plate),
                      );
                      break;

                    case "delete":
                      await ref.read(busListControllerProvider.notifier).remove(bus.id);
                      break;

                    case "decommission":
                      final confirmed = await _confirm(
                        context,
                        '¿Deseas marcar el bus ${bus.plate} como FUERA DE SERVICIO?',
                      );
                      if (confirmed) {
                        await repo.updateStatus(bus.id, "FUERA_SERVICIO");
                        await ref.read(busListControllerProvider.notifier).refresh();
                      }
                      break;

                    case "enable":
                      final confirmed = await _confirm(
                        context,
                        '¿Deseas habilitar nuevamente el bus ${bus.plate}?',
                      );
                      if (confirmed) {
                        await repo.updateStatus(bus.id, "OK");
                        await ref.read(busListControllerProvider.notifier).refresh();
                      }
                      break;

                    case "replace":
                      final replacement = await _askReplacementPlate(context);
                      if (replacement != null) {
                        await repo.updateStatus(
                          bus.id,
                          "REEMPLAZADO",
                          replacementId: replacement,
                        );
                        await ref.read(busListControllerProvider.notifier).refresh();
                      }
                      break;
                  }
                },

                itemBuilder: (_) {
                  final items = <PopupMenuEntry<String>>[];

                  final isActive = ["OK", "PROXIMO", "VENCIDO"].contains(bus.status);

                  if (isActive) {
                    items.add(const PopupMenuItem(value: 'plan', child: Text('Agendar por predicción')));
                    items.add(const PopupMenuItem(value: 'viewOrders', child: Text('Ver órdenes')));
                    items.add(const PopupMenuItem(value: 'delete', child: Text('Eliminar bus')));
                    items.add(const PopupMenuItem(value: 'decommission', child: Text('Marcar fuera de servicio')));
                    items.add(const PopupMenuItem(value: 'replace', child: Text('Registrar reemplazo')));
                  }

                  if (bus.status == "FUERA_SERVICIO") {
                    items.add(const PopupMenuItem(value: 'enable', child: Text('Habilitar bus')));
                  }

                  if (bus.status == "REEMPLAZADO") {
                    items.add(const PopupMenuItem(
                      enabled: false,
                      value: 'none',
                      child: Text('Sin acciones disponibles'),
                    ));
                  }

                  return items;
                },
              ),
            );
          },
        );
      },
    );
  }
  Color _statusColor(String status) {
    switch (status) {
      case "OK": return Colors.green;
      case "PROXIMO": return Colors.orange;
      case "VENCIDO": return Colors.red;
      case "FUERA_SERVICIO": return Colors.grey;
      case "REEMPLAZADO": return Colors.blueGrey;
      default: return Colors.grey;
    }
  }
  Future<bool> _confirm(BuildContext context, String msg) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
        ],
      ),
    ) ??
        false;
  }
  Future<String?> _askReplacementPlate(BuildContext context) async {
    final controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
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
      ),
    );
  }
}

// Lista de marcas disponibles
const brands = [
  "Toyota",
  "Hyundai",
  "Mercedes-Benz",
  "Volvo",
  "Scania",
  "Daewoo",
  "Renault",
];

// Modelos por marca
const modelsByBrand = {
  "Toyota": ["Coaster", "HiAce", "Urban"],
  "Hyundai": ["County", "Aero City", "Universe"],
  "Mercedes-Benz": ["Sprinter", "Citaro", "Tourismo"],
  "Volvo": ["B7R", "7900", "9700"],
  "Scania": ["K310", "F310", "Citywide"],
  "Daewoo": ["BV120MA", "BH090", "BC211"],
  "Renault": ["Master", "Traffic", "Irisbus"],
};

class _BusFormDialog extends ConsumerStatefulWidget {
  const _BusFormDialog({this.initial, super.key});
  final Bus? initial;

  @override
  ConsumerState<_BusFormDialog> createState() => _BusFormDialogState();
}

class _BusFormDialogState extends ConsumerState<_BusFormDialog> {
  String? selectedBrand;
  String? selectedModel;
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
    _lastServiceAt = widget.initial?.lastMaintenanceDate ?? DateTime.now();
    _alias.text = widget.initial?.alias ?? '';

    // Si existe notes, intentamos extraer marca y modelo
    _notes.text = widget.initial?.notes ?? '';

    if (widget.initial?.notes != null) {
      final parts = widget.initial!.notes!.split(" | ");
      if (parts.length == 2) {
        selectedBrand = parts[0];
        selectedModel = parts[1];
      }
    }
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER
                Row(
                  children: [
                    Icon(
                      isEdit ? Icons.directions_bus_filled : Icons.add_road,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEdit ? "Editar Bus" : "Registrar Nuevo Bus",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // CARD DE DATOS PRINCIPALES
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        TextFormField(
                          controller: _plate,
                          decoration: const InputDecoration(
                            labelText: 'Placa *',
                            prefixIcon: Icon(Icons.directions_bus),
                          ),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _km,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Km actual *',
                            prefixIcon: Icon(Icons.speed),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            final n = int.tryParse(v);
                            if (n == null || n < 0) return 'Km inválido';
                            final last = widget.initial?.kmCurrent ?? 0;
                            if (isEdit && n < last) {
                              return 'No puede ser menor al último ($last)';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // CARD DE MARCA Y MODELO
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        DropdownButtonFormField<String>(
                          value: selectedBrand,
                          decoration: const InputDecoration(
                            labelText: "Marca",
                            prefixIcon: Icon(Icons.local_shipping),
                          ),
                          items: brands
                              .map((b) =>
                              DropdownMenuItem(value: b, child: Text(b)))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedBrand = v;
                              selectedModel = null;
                            });
                          },
                          validator: (v) =>
                          v == null ? "Selecciona una marca" : null,
                        ),

                        const SizedBox(height: 16),

                        if (selectedBrand != null)
                          DropdownButtonFormField<String>(
                            value: selectedModel,
                            decoration: const InputDecoration(
                              labelText: "Modelo",
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                            items: modelsByBrand[selectedBrand]!
                                .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m),
                            ))
                                .toList(),
                            onChanged: (v) => setState(() => selectedModel = v),
                            validator: (v) =>
                            v == null ? "Selecciona un modelo" : null,
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // BOTONES
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),

                    const SizedBox(width: 12),

                    FilledButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Revisa los campos obligatorios")),
                          );
                          return;
                        }

                        final notifier = ref.read(busListControllerProvider.notifier);

                        final notes = "$selectedBrand | $selectedModel";

                        final bus = (widget.initial ??
                            Bus(id: '', plate: _plate.text.trim(), kmCurrent: 0))
                            .copyWith(
                          plate: _plate.text.trim(),
                          kmCurrent: int.parse(_km.text),
                          lastMaintenanceDate: _lastServiceAt,
                          alias: _alias.text.trim().isEmpty ? null : _alias.text.trim(),
                          notes: notes,
                        );

                        await notifier.save(bus);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEdit ? "Bus actualizado" : "Bus creado"),
                            ),
                          );
                        }
                      },
                      child: Text(isEdit ? "Guardar" : "Crear"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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