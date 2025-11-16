class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}

class LoginResponse {
  final String token;
  final List<String> roles;
  final List<String> areas;

  LoginResponse({
    required this.token,
    required this.roles,
    required this.areas,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"],
      roles: (json["roles"] as List).map((e) => e.toString()).toList(),
      areas: (json["areas"] as List).map((e) => e.toString()).toList(),
    );
  }
}