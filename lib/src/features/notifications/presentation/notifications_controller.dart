import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../notifications/data/notification_repository_api.dart';
import '../domain/entities/notification_entity.dart';
import '../data/notification_repository_api.dart';

final notificationsControllerProvider =
StateNotifierProvider<NotificationsController, AsyncValue<List<NotificationEntity>>>(
      (ref) => NotificationsController(ref)..load(),
);



class NotificationsController extends StateNotifier<AsyncValue<List<NotificationEntity>>> {
  final Ref ref;
  int currentPage = 0;
  bool hasNext = true;
  final List<NotificationEntity> _items = [];

  NotificationsController(this.ref) : super(const AsyncValue.loading());

  Future<void> load({bool refresh = false}) async {
    final repo = ref.read(notificationRepositoryProvider); // ← CORREGIDO

    if (refresh) {
      currentPage = 0;
      hasNext = true;
      _items.clear();
      state = const AsyncValue.loading();
    }

    if (!hasNext) return;

    final pageData = await repo.listUnread(page: currentPage); // ← AHORA FUNCIONA
    _items.addAll(pageData.items);

    hasNext = pageData.hasNext;
    currentPage++;

    state = AsyncValue.data(List.of(_items));
  }

  Future<void> markAsRead(int id) async {
    final repo = ref.read(notificationRepositoryProvider); // ← CORREGIDO
    await repo.markAsRead(id); // ← AHORA FUNCIONA

    await load(refresh: true);
  }
}