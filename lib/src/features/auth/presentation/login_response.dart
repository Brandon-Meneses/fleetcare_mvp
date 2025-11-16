class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"], // 👈 debe coincidir EXACTO
    );
  }

  Map<String, dynamic> toJson() => {"token": token};
}