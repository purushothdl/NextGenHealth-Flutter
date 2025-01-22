// lib/features/auth/models/user_model.dart
class UserRegistration {
  final String username;
  final String email;
  final String password;
  final String role;
  final String fcmToken;

  UserRegistration({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.fcmToken
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'fcm_token': fcmToken
    };
  }
}