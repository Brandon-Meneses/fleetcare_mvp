import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/notification_entity.dart';
import '../data/notification_repository_api.dart';

final notificationRepositoryProvider = Provider((_) => NotificationRepository());

final notificationsControllerProvider =
StateNotifierProvider<NotificationsController, AsyncValue<List<NotificationEntity>>>(
      (ref) => NotificationsController(ref)..load(),
);

class NotificationsController extends StateNotifier<AsyncValue<List<NotificationEntity>>> {
  final Ref ref;
  NotificationsController(this.ref) : super(const AsyncValue.loading());

  Future<void> load() async {
    final repo = ref.read(notificationRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.listUnread());
  }

  Future<void> markAsRead(int id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(id);
    await load(); // refrescar después de marcar
  }

  Future<int> countUnread() async {
    final repo = ref.read(notificationRepositoryProvider);
    return repo.unreadCount();
  }
}