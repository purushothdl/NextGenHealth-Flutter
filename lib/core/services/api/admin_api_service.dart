// lib/core/services/api/admin_api_service.dart
import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_interceptor.dart';

class AdminApiService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  AdminApiService() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(AuthInterceptor(_storage)); // Add AuthInterceptor
  }

  // Fetch a specific user's profile by user ID
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.adminGetUser}/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Fetch all doctors
  Future<List<dynamic>> getDoctors() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminGetDoctors);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Fetch all patients
  Future<List<dynamic>> getPatients() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminGetPatients);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }


  // Fetch pending approvals
  Future<List<dynamic>> getPendingApprovals() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminApprovals);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Approve a user
  Future<void> approveUser(String userId) async {
    try {
      await _dio.post('${ApiEndpoints.adminApprovals}/$userId/approve');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Reject a user
  Future<void> rejectUser(String userId) async {
    try {
      await _dio.post('${ApiEndpoints.adminApprovals}/$userId/reject');
    } catch (e) {
      throw _handleError(e);
    }
  }

// lib/core/services/api/admin_api_service.dart
Future<void> assignTicketToDoctor(String ticketId, String doctorId) async {
  try {
    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}/api/admin/$ticketId/assign',
      queryParameters: {'doctor_id': doctorId},
    );

    // Debug: Print the API response
    print('API Response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception(response.data['detail'] ?? 'Failed to assign ticket');
    }
  } catch (e) {
    throw _handleError(e);
  }
}



  // Handle errors
  String _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response?.data;
      if (response is Map<String, dynamic>) {
        return response['detail'] ?? 'An error occurred processing the request';
      }
      return 'An error occurred connecting to the server';
    }
    return 'An unexpected error occurred';
  }
}