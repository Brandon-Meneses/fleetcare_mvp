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
            tooltip: "Actualizar",
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(notificationsControllerProvider.notifier).load(refresh: true),
          ),
        ],
      ),

      body: notifState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text("Error: $e"),
        ),

        data: (items) {
          if (items.isEmpty) {
            return _emptyState(context);
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 80) {
                ref.read(notificationsControllerProvider.notifier).load();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) => _NotificationCard(item: items[i], ref: ref),
            ),
          );
        },
      ),
    );
  }

  /// --- Vista vacía: moderna, limpia ---
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none,
              size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text(
            "No hay notificaciones pendientes",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// =======================================================
///     TARJETA VISUAL DE NOTIFICACIÓN – MODERNA
/// =======================================================
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.ref});

  final dynamic item;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(notificationsControllerProvider.notifier).markAsRead(item.id);
      },

      /// Fondo verde al deslizar
      background: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),

      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),

        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (item.link != null) context.push(item.link!);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícono según tipo de notificación
                _leadingIcon(theme),

                const SizedBox(width: 16),

                // Texto principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),

                // Flecha si tiene link
                if (item.link != null)
                  Icon(Icons.chevron_right,
                      color: theme.colorScheme.primary, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ÍCONO SEGÚN CATEGORÍA ─ sin tocar backend
  Widget _leadingIcon(ThemeData theme) {
    final title = item.title.toLowerCase();

    IconData icon = Icons.notifications;
    Color color = theme.colorScheme.secondary;

    if (title.contains("mantenimiento") || title.contains("orden")) {
      icon = Icons.build_circle;
      color = Colors.orange;
    }
    if (title.contains("bus") || title.contains("vehículo")) {
      icon = Icons.directions_bus_filled;
      color = Colors.blue;
    }
    if (title.contains("alerta") || title.contains("urgente")) {
      icon = Icons.warning_amber_rounded;
      color = Colors.red;
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: color.withOpacity(0.15),
      child: Icon(icon, color: color, size: 26),
    );
  }
}