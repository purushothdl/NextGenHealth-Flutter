// lib/core/services/api/ticket_api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_interceptor.dart';
import '../../../features/tickets/models/ticket_model.dart';

class TicketApiService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  TicketApiService() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(AuthInterceptor(_storage));
  }


Future<Map<String, dynamic>> createTicket(Ticket ticket) async {
  try {
    final formData = FormData.fromMap({
      'title': ticket.title,
      'description': ticket.description,
      'bp': ticket.bp,
      'sugar_level': ticket.sugarLevel,
      'weight': ticket.weight,
      'symptoms': ticket.symptoms,
      // Conditionally add image if path is not null
      if (ticket.imagePath != null)
        'image': await MultipartFile.fromFile(
          ticket.imagePath!,
          contentType: DioMediaType('image', 'jpeg'), 
        ),
      // Conditionally add document if path is not null
      if (ticket.documentPath != null)
        'document': await MultipartFile.fromFile(
          ticket.documentPath!,
          contentType: DioMediaType('application', 'pdf'), 
        ),
    });

    final response = await _dio.post(
      ApiEndpoints.createTicket,
      data: formData,
    );

    return response.data;
  } catch (e) {
    throw _handleError(e);
  }
}

  // Fetch tickets (returns List<TicketResponse>)
Future<List<TicketResponse>> getTickets() async {
  try {
    print('Calling API: ${ApiEndpoints.baseUrl}/api/tickets/'); // Debug log
    final response = await _dio.get('/api/tickets/');
    print('API Response: ${response.data}'); // Debug log

    // Ensure the response is a List
    if (response.data is List) {
      return (response.data as List).map((ticket) {
        print('Parsing Ticket: $ticket'); // Debug log
        return TicketResponse.fromJson(ticket);
      }).toList();
    } else {
      throw 'Invalid API response: Expected a List';
    }
  } catch (e) {
    print('API Error: $e'); // Debug log
    throw _handleError(e);
  }
}

  // Fetch user details
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
    final response = await _dio.get(
      '${ApiEndpoints.userData}/$userId', // Use ${} for interpolation
    );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

Future<void> uploadReport(
  String ticketId,
  String diagnosis,
  String recommendations,
  List<String> medications,
  String? imagePath,
  String? documentPath,
) async {
  try {
    final formData = FormData.fromMap({
      'ticket_id': ticketId,
      'diagnosis': diagnosis,
      'recommendations': recommendations,
      'medications': medications,
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          contentType: DioMediaType('image', 'jpeg'),
        ),
      if (documentPath != null)
        'document': await MultipartFile.fromFile(
          documentPath,
          contentType: DioMediaType('application', 'pdf'),
        ),
    });

    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}/api/tickets/$ticketId/report',
      data: formData,
    );
    return response.data;
  } catch (e) {
    throw _handleError(e);
  }
}

Future<Map<String, dynamic>> getReport(String ticketId) async {
  try {
    final response = await _dio.get(
      '${ApiEndpoints.baseUrl}/api/tickets/$ticketId/report'
    );
    return response.data;
  } catch (e) {
    print(e);
    throw _handleError(e);
  }
}





String _handleError(dynamic error) {
  if (error is DioException) {
    print('DioError: ${error.message}'); // Log the error message
    if (error.response != null) {
      print('Response Data: ${error.response?.data}'); // Log response data
      print('Status Code: ${error.response?.statusCode}'); // Log status code
      if (error.response?.data is Map) {
        return error.response?.data['detail'] ?? 'An error occurred';
      } else if (error.response?.data is List) {
        return error.response?.data.join(', ') ?? 'An error occurred';
      }
    }
    return error.message ?? 'An error occurred';
  }
  print('Unexpected Error: $error'); // Log unexpected errors
  return 'An error occurred';
}
}