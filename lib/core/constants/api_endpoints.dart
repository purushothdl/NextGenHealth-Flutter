// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = "https://nextgenhealth.onrender.com";
  static const String register = "$baseUrl/api/auth/register";
  static const String login = "$baseUrl/api/auth/login";
  static const String checkStatus = "$baseUrl/api/auth/status";
  static const String userProfile = "$baseUrl/api/users/me";
}
