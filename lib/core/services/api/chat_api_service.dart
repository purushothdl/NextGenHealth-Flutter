// lib/core/services/api/chat_api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_interceptor.dart';
import '../../../features/chat/models/chat_model.dart';
import 'package:http_parser/http_parser.dart';

class ChatApiService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  ChatApiService() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(AuthInterceptor(_storage));
  }

Future<List<ChatSession>> getUserChats(String userId, {String? ticketId}) async {
  try {
    final response = await _dio.get(
      '${ApiEndpoints.baseUrl}/api/chats/user/$userId',
      queryParameters: ticketId != null ? {'ticket_id': ticketId} : null,
    );

    // Handle empty response
    if (response.data == null || response.data.isEmpty) {
      return [];
    }

    return (response.data as List)
        .map((chat) => ChatSession.fromJson(chat))
        .toList();
  } on DioException catch (e) {
    // Handle 404 error specifically
    if (e.response?.statusCode == 404) {
      return []; // Return an empty list for "no chats found"
    }
    throw _handleError(e);
  } catch (e) {
    throw _handleError(e);
  }
}

  Future<ChatSession> getChatById(String sessionId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.baseUrl}/api/chats/$sessionId');
      return ChatSession.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

Future<ChatSession> startChat({
  String? ticketId,
  String? message,
  String? imagePath,
  String? documentPath,
}) async {
  try {
    final formData = FormData();

    // Add ticket ID if provided
    if (ticketId != null) {
      formData.fields.add(MapEntry('ticket_id', ticketId));
    }

    // Add message if provided
    if (message != null && message.isNotEmpty) {
      formData.fields.add(MapEntry('message', message));
    }

    // Add image file if provided
    if (imagePath != null) {
      debugPrint("Adding image file: $imagePath");
      final imageFile = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
        contentType: MediaType('image', imagePath.split('.').last),
      );
      formData.files.add(MapEntry('image', imageFile));
    }

    // Add PDF file if provided
    if (documentPath != null) {
      debugPrint("Adding document file: $documentPath");
      final pdfFile = await MultipartFile.fromFile(
        documentPath,
        filename: documentPath.split('/').last,
        contentType: MediaType('application', 'pdf'),
      );
      formData.files.add(MapEntry('document', pdfFile));
    }

    // Debug log to check FormData
    debugPrint("FormData fields: ${formData.fields}");
    debugPrint("FormData files: ${formData.files}");

    // Send the request
    final response = await _dio.post(
      ApiEndpoints.startChat,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );

    // Debug log to check API response
    debugPrint("API Response: ${response.data}");

    // Handle response
    if (response.statusCode != 200) {
      throw Exception(response.data['detail'] ?? 'Failed to start chat');
    }

    return ChatSession.fromJson(response.data);
  } catch (e) {
    debugPrint("Error in startChat: $e"); // Debug log for errors
    throw _handleError(e);
  }
}

Future<ChatSession> continueChat({
  required String sessionId,
  required String message,
  String? imagePath,
  String? documentPath,
}) async {
  try {
    final formData = FormData();
    
    formData.fields.add(MapEntry('session_id', sessionId));
    
    if (message.isNotEmpty) {
      formData.fields.add(MapEntry('message', message));
    }

    if (imagePath != null) {
      final file = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
        contentType: MediaType('image', imagePath.split('.').last),
      );
      formData.files.add(MapEntry('image', file));
    }

    if (documentPath != null) {
      final file = await MultipartFile.fromFile(
        documentPath,
        filename: documentPath.split('/').last,
        contentType: MediaType('application', documentPath.split('.').last),
      );
      formData.files.add(MapEntry('document', file));
    }

    final response = await _dio.post(
      ApiEndpoints.continueChat,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['detail'] ?? 'Failed to continue chat');
    }

    return ChatSession.fromJson(response.data);
  } catch (e) {
    throw _handleError(e);
  }
}

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