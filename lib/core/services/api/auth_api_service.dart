// lib/core/services/api/auth_api_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../features/auth/models/user_model.dart';
import '../../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_interceptor.dart';

class AuthApiService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  AuthApiService() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(AuthInterceptor(_storage));
  }
  
  Future<Map<String, dynamic>> register(UserRegistration user) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: user.toJson(),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

    // Add this method
    Future<void> updateFCMToken(String? fcmToken) async {
      try {
        await _dio.post(
          ApiEndpoints.updateFCMToken,
          queryParameters: {'fcm_token': fcmToken},
        );
      } catch (e) {
        throw _handleError(e);
      }
    }

Future<Map<String, dynamic>> checkStatus(String email) async {
  try {
    final response = await _dio.get(
    ApiEndpoints.checkStatus,
    queryParameters: {"email": email}
);

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return Map<String, dynamic>.from(json.decode(response.data));
    }
    return {'status': 'unknown'};
  } on DioException catch (e) {
    if (e.response != null) {
      throw e.response?.data['detail'] ?? 'Server error occurred';
    }
    throw 'Connection error. Please check your internet connection.';
  } catch (e) {
    throw 'Failed to check status';
  }
}


Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final formData = FormData.fromMap({
      'email': email,
      'password': password,
    });

    final response = await _dio.post(
      ApiEndpoints.login,
      data: formData,
    );

    if (response.data is Map<String, dynamic>) {
      if (response.data['access_token'] != null) {
        await _storage.saveToken(response.data['access_token']);
      }
      return response.data;
    } else {
      throw FormatException('Expected a Map but got ${response.data.runtimeType}');
    }
  } catch (e) {
    throw _handleError(e);
  }
}

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.userProfile);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.userProfile,
        data: data,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Add to AuthApiService class
  Future<Map<String, dynamic>> getFAQs() async {
    try {
      final response = await _dio.get(ApiEndpoints.getFAQs);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
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