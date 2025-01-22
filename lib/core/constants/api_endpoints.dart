// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = "https://4b9e-117-241-203-153.ngrok-free.app";
  static const String register = "$baseUrl/api/auth/register";
  static const String login = "$baseUrl/api/auth/login";
  static const String checkStatus = "$baseUrl/api/auth/status";
  static const String userProfile = "$baseUrl/api/users/me";
  static const String createTicket = "$baseUrl/api/tickets/";
  static const String getTickets = "$baseUrl/api/tickets/";
  static const String userData = "$baseUrl/api/auth/get_user";
  static const String startChat = "$baseUrl/api/chats/start";
  static const String continueChat = "$baseUrl/api/chats/continue";
  static const String endChat = "$baseUrl/api/chats/end";

  // Admin Endpoints
  static const String adminGetUser = "$baseUrl/api/admin/get_user";
  static const String adminGetDoctors = "$baseUrl/api/admin/doctors";
  static const String adminGetPatients = "$baseUrl/api/admin/patients";
  static const String adminApprovals = "$baseUrl/api/admin/approvals";
  static const String adminAssignTicket = "$baseUrl/api/admin/tickets";
  static const String adminFeedback = "$baseUrl/api/feedback/all";


  // Feedback
  static const String postFeedback = "$baseUrl/api/feedback/";
  static const String getFeedback = "$baseUrl/api/feedback/user";

  // FQQs
  static const String getFAQs = "$baseUrl/api/misc/faqs";

  // Notifications
  static const String getNotifications = "$baseUrl/api/notifications/";
  static const String markNotifications = "$baseUrl/api/notifications/mark-read";
  static const String updateFCMToken = "$baseUrl/api/users/update-fcm-token";

}