// lib/features/admin/providers/admin_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/admin_api_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminApiService _adminApiService = AdminApiService();
  List<dynamic> _doctors = [];
  List<dynamic> _patients = [];
  List<dynamic> _pendingApprovals = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get doctors => _doctors;
  List<dynamic> get patients => _patients;
  List<dynamic> get pendingApprovals => _pendingApprovals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDoctors({bool forceReload = false}) async {
    if (!forceReload && _doctors.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _doctors = await _adminApiService.getDoctors();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPatients({bool forceReload = false}) async {
    if (!forceReload && _patients.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _patients = await _adminApiService.getPatients();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<void> loadPendingApprovals({bool forceReload = false}) async {
  if (!forceReload && _pendingApprovals.isNotEmpty) return;

  _isLoading = true;
  notifyListeners();

  try {
    final newPendingApprovals = await _adminApiService.getPendingApprovals();
    if (newPendingApprovals != _pendingApprovals) {
      _pendingApprovals = newPendingApprovals;
      _error = null;
      notifyListeners(); // Only notify if the data has changed
    }
  } catch (e) {
    _error = e.toString();
    notifyListeners();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> approveUser(String userId) async {
    try {
      await _adminApiService.approveUser(userId);
      // Remove the user from pending approvals after approval
      _pendingApprovals.removeWhere((user) => user['_id'] == userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> rejectUser(String userId) async {
    try {
      await _adminApiService.rejectUser(userId);
      // Remove the user from pending approvals after rejection
      _pendingApprovals.removeWhere((user) => user['_id'] == userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}