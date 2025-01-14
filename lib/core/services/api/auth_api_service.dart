// lib/core/services/api/auth_api_service.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../features/auth/models/user_model.dart';
import '../../constants/api_endpoints.dart';

class AuthApiService {
  final Dio _dio = Dio();

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


  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null && error.response?.data is Map) {
        return error.response?.data['detail'] ?? 'An error occurred';
      }
      return error.message ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}