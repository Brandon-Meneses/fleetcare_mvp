import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifications_controller.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(notificationsControllerProvider.notifier).load(),
          ),
        ],
      ),
      body: notificationsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text('No hay notificaciones pendientes.'));
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(n.content),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  tooltip: "Marcar como leída",
                  onPressed: () async {
                    await ref.read(notificationsControllerProvider.notifier).markAsRead(n.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Notificación marcada como leída')));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}