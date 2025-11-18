import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../notifications_controller.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifState = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(notificationsControllerProvider.notifier).load(refresh: true),
          )
        ],
      ),
      body: notifState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text("No hay notificaciones pendientes"));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 80) {
                ref.read(notificationsControllerProvider.notifier).load();
              }
              return false;
            },
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final n = items[i];
                return Dismissible(
                  key: ValueKey(n.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref
                        .read(notificationsControllerProvider.notifier)
                        .markAsRead(n.id);
                  },
                  child: ListTile(
                    title: Text(n.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(n.content),
                    onTap: () {
                      if (n.link != null) context.push(n.link!);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}