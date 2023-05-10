import 'dart:convert';

class LoginRequest {
  String email;
  String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  static LoginRequest loginRequestFromJson(String str) =>
      LoginRequest.fromJson(json.decode(str));

  static String loginRequestToJson(LoginRequest data) =>
      json.encode(data.toJson());

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
