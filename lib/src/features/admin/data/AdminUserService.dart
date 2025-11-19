import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../auth/data/ApiConfig.dart';
import '../../auth/data/auth_storage.dart';

final adminUserServiceProvider = Provider<AdminUserService>((ref) {
  return AdminUserService(Dio(), baseUrl: ApiConfig.baseUrl);
});

class AdminUserService {
  final Dio _dio;
  final String baseUrl;

  AdminUserService(this._dio, {required this.baseUrl});

  Future<void> createUser({
    required String email,
    required String role,
    String? area,
  }) async {
    final token = await AuthStorage.getToken();

    final payload = {
      "email": email,
      "role": role,
      "area": area, // null si es ADMIN
    };

    await _dio.post(
      "$baseUrl/admin/users",
      data: payload,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
  }
}