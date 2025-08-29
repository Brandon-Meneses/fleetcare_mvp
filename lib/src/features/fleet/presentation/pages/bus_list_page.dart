import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/bus.dart';
import '../controllers/bus_list_controller.dart';
import '../../../settings/presentation/settings_controller.dart';
import '../../../settings/domain/config.dart';
import '../../domain/value_objects/bus_state.dart';
import '../../domain/services/rules_service.dart';

class BusListPage extends ConsumerWidget {
  const BusListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(busListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task), // Quick add para probar
            tooltip: 'Quick add',
            onPressed: () async {
              final now = DateTime.now();
              await ref.read(busListControllerProvider.notifier).save(
                Bus(
                  id: '',
                  plate: 'TEST-${now.second}${now.millisecond}',
                  kmCurrent: 0,
                  lastServiceAt: now,
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bus de prueba creado')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber),
            onPressed: () => context.push('/alerts'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],

      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (buses) => buses.isEmpty
            ? const Center(child: Text('No hay buses. Agrega uno con el botón +'))
            : ListView.separated(
          itemCount: buses.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final b = buses[i];
            final cfg = ref.watch(configProvider);
            final state = RulesService.computeState(
              bus: b,
              kmThreshold: cfg.kmThreshold,
              monthsThreshold: cfg.monthsThreshold,
            );
            final dueDate = RulesService.predictDueDate(
              bus: b,
              kmThreshold: cfg.kmThreshold,
              monthsThreshold: cfg.monthsThreshold,
              kmPerDayEstimated: 200, // opcional: valor por defecto hasta tener histórico
            );

            Color chipColor = switch (state) {
              BusState.ok => Colors.green,
              BusState.dueSoon => Colors.orange,
              BusState.overdue => Colors.red,
            };

            return ListTile(
              title: Text(b.plate),
              subtitle: Text(
                'Km: ${b.kmCurrent} • Último: ${b.lastServiceAt?.toLocal().toString().split(" ").first ?? "-"}'
                    '${dueDate != null ? ' • Est.: ${dueDate.toLocal().toString().split(" ").first}' : ''}',
              ),
              leading: Chip(
                backgroundColor: chipColor.withOpacity(0.15),
                label: Text(
                  state.label,
                  style: TextStyle(color: chipColor, fontWeight: FontWeight.bold),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 6),
              ),
              onTap: () async {
                await showDialog(context: context, builder: (_) => _BusFormDialog(initial: b));
                await ref.read(busListControllerProvider.notifier).refresh();
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => ref.read(busListControllerProvider.notifier).remove(b.id),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => const _BusFormDialog(),
          );
          // asegurar refresh
          await ref.read(busListControllerProvider.notifier).refresh();
        },
        child: const Icon(Icons.add),
      ),
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