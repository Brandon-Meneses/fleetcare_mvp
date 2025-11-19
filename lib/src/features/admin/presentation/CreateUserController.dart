import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/AdminUserService.dart';


final createUserControllerProvider =
StateNotifierProvider<CreateUserController, AsyncValue<void>>((ref) {
  return CreateUserController(ref);
});

class CreateUserController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CreateUserController(this.ref) : super(const AsyncData(null));

  Future<bool> createUser({
    required String email,
    required String role,
    required String? area,
  }) async {
    state = const AsyncLoading();

    try {
      final service = ref.read(adminUserServiceProvider);
      await service.createUser(email: email, role: role, area: area);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}