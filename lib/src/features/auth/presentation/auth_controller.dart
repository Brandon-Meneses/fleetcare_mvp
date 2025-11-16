import 'package:flutter/material.dart';              // <- BuildContext
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <- StateNotifierProvider, Ref
import 'package:go_router/go_router.dart';
import '../../../core/di/providers.dart';
import '../../fleet/presentation/controllers/bus_list_controller.dart';
import '../../maintenance/presentation/controllers/maintenance_controller.dart';
import '../../reports/presentation/report_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/auth_info.dart';
import '../data/auth_service.dart';
import '../data/auth_state.dart';
import '../domain/auth_models.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AuthController(this.ref) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final response = await ref.read(authServiceProvider)
          .login(LoginRequest(email: email, password: password));

      // -------------------------------
      // 1️⃣ TOKEN GUARDADO
      // -------------------------------
      await AuthState.setLoggedIn(
        response.token,
        response.roles,
        response.areas,
      );

      // -------------------------------
      // 2️⃣ INVALIDAR providers que dependen del token
      // -------------------------------
      ref.invalidate(busRepositoryProvider); // 🔥 importante
      ref.invalidate(busListControllerProvider);
      ref.invalidate(maintenanceControllerProvider);
      ref.invalidate(reportControllerProvider);
      ref.invalidate(configProvider);
      ref.invalidate(rolesProvider);
      ref.invalidate(areasProvider);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    await AuthState.logout();

    // Limpieza al cerrar sesión
    ref.invalidate(busRepositoryProvider);
    ref.invalidate(busListControllerProvider);
    ref.invalidate(maintenanceControllerProvider);
    ref.invalidate(reportControllerProvider);
    ref.invalidate(configProvider);
    ref.invalidate(rolesProvider);
    ref.invalidate(areasProvider);

  }
}