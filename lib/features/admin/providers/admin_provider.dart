// lib/features/admin/providers/admin_provider.dart
import 'dart:convert';

import 'package:dio/dio.dart';
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
      _pendingApprovals = await _adminApiService.getPendingApprovals();
      _error = null;
    } on DioException catch (e) {
      _pendingApprovals = [];
      if (e.response?.statusCode == 404) {
        _error = e.response?.data['detail'] ?? 'No users found';
      } else {
        _error = 'An unexpected error occurred';
      }
    } catch (e) {
      _pendingApprovals = [];
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> approveUser(String userId) async {
    try {
      await _adminApiService.approveUser(userId);
      _pendingApprovals.removeWhere((user) => user['_id'] == userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      // Defer notifyListeners() to avoid calling it during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> rejectUser(String userId) async {
    try {
      await _adminApiService.rejectUser(userId);
      _pendingApprovals.removeWhere((user) => user['_id'] == userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      // Defer notifyListeners() to avoid calling it during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}