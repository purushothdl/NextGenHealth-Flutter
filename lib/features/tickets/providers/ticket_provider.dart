// lib/features/tickets/providers/ticket_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/ticket_api_service.dart';
import '../models/ticket_model.dart'; // For creating tickets

class TicketProvider extends ChangeNotifier {
  final TicketApiService _ticketService = TicketApiService();
  bool isLoading = false;
  String? error;
  List<TicketResponse> _tickets = []; // Use TicketResponse for fetched tickets

  List<TicketResponse> get pendingTickets => _tickets.where((ticket) => ticket.status == 'pending').toList();
  List<TicketResponse> get resolvedTickets => _tickets.where((ticket) => ticket.status == 'resolved').toList();

  // Create a new ticket (uses Ticket model)
  Future<bool> createTicket(Ticket ticket) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _ticketService.createTicket(ticket);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch tickets (always fetch from API, no caching)
  Future<void> fetchTickets() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Notify listeners before the async operation

    try {
      final response = await _ticketService.getTickets();
      _tickets = response;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      // Use addPostFrameCallback to notify listeners after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Refresh tickets (alias for fetchTickets)
  Future<void> refreshTickets() async {
    await fetchTickets();
  }

  // Upload a report for a ticket
  Future<bool> uploadReport({
    required String ticketId,
    required String diagnosis,
    required String recommendations,
    required List<String> medications,
    String? imagePath,
    String? documentPath,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _ticketService.uploadReport(
        ticketId,
        diagnosis,
        recommendations,
        medications,
        imagePath,
        documentPath,
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch a report for a ticket
  Future<Map<String, dynamic>> fetchReport(String ticketId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _ticketService.getReport(ticketId);
      isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  // Fetch user details (patient or doctor)
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final response = await _ticketService.getUserDetails(userId); // Ensure this method exists
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}