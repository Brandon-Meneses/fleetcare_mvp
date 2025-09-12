import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_service.dart';
import '../data/auth_storage.dart';

final authServiceProvider = Provider((ref) => AuthService());

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  return AuthStorage.isLoggedIn();
});