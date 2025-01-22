// lib/core/services/api/notification_api_service.dart
import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_interceptor.dart';

class NotificationApiService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  NotificationApiService() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(AuthInterceptor(_storage));
  }

  Future<List<dynamic>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.getNotifications);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markNotificationsAsRead() async {
    try {
      await _dio.post(ApiEndpoints.markNotifications);
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        if (error.response?.data is Map) {
          return error.response?.data['detail'] ?? 'An error occurred';
        } else if (error.response?.data is List) {
          return error.response?.data.join(', ') ?? 'An error occurred';
        }
      }
      return error.message ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}