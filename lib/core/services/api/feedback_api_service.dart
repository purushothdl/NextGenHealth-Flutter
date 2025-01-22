// lib/core/services/api/feedback_api_service.dart
import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_interceptor.dart';

class FeedbackApiService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  FeedbackApiService() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(AuthInterceptor(_storage)); // Add AuthInterceptor
  }

  // Post feedback
  Future<Map<String, dynamic>> postFeedback({
    required String title,
    required double rating,
    required String comment,
  }) async {
    try {
      // Create FormData
      final formData = FormData.fromMap({
        'title': title,
        'rating': rating,
        'comment': comment,
      });

      // Send FormData
      final response = await _dio.post(
        ApiEndpoints.postFeedback,
        data: formData,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get feedback
  Future<List<dynamic>> getFeedback() async {
    try {
      final response = await _dio.get(ApiEndpoints.getFeedback);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

    // Get feedback for all users (admin only)
    Future<List<dynamic>> getAdminFeedback() async {
      try {
        final response = await _dio.get(ApiEndpoints.adminFeedback);
        return response.data;
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