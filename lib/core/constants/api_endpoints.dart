// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = "https://b228-2409-40f0-1043-2976-e846-2d6e-9a15-8b22.ngrok-free.app";
  static const String register = "$baseUrl/api/auth/register";
  static const String login = "$baseUrl/api/auth/login";
  static const String checkStatus = "$baseUrl/api/auth/status";
  static const String userProfile = "$baseUrl/api/users/me";
  static const String createTicket = "$baseUrl/api/tickets/";
  static const String getTickets = "$baseUrl/api/tickets/";
  static const String userData = "$baseUrl/api/auth/get_user";
  static const String startChat = "$baseUrl/api/chats/start";
  static const String continueChat = "$baseUrl/api/chats/continue";
}
