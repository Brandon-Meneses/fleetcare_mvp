import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_controller.dart';
import '../../settings/presentation/settings_controller.dart'; // configProvider

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final cfg  = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        // 👇 ESTOS son los children del ListView (no del DropdownButton)
        children: [
          const Text('Tema', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<ThemeMode>(
            value: mode,
            onChanged: (m) => ref.read(themeModeProvider.notifier).set(m!),
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('Sistema')),
              DropdownMenuItem(value: ThemeMode.light,  child: Text('Claro')),
              DropdownMenuItem(value: ThemeMode.dark,   child: Text('Oscuro')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Umbrales de mantenimiento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Umbral por KM')),
              SizedBox(
                width: 120,
                child: TextFormField(
                  initialValue: cfg.kmThreshold.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(suffixText: 'km'),
                  onFieldSubmitted: (v) {
                    final n = int.tryParse(v);
                    if (n != null && n > 0) {
                      ref.read(configProvider.notifier).setKmThreshold(n);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Umbral KM actualizado')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Umbral por TIEMPO')),
              SizedBox(
                width: 120,
                child: TextFormField(
                  initialValue: cfg.monthsThreshold.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(suffixText: 'meses'),
                  onFieldSubmitted: (v) {
                    final n = int.tryParse(v);
                    if (n != null && n > 0) {
                      ref.read(configProvider.notifier).setMonthsThreshold(n);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Umbral meses actualizado')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}