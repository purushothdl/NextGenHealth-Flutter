// lib/features/auth/models/user_model.dart
class UserRegistration {
  final String username;
  final String email;
  final String password;
  final String role;

  UserRegistration({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}