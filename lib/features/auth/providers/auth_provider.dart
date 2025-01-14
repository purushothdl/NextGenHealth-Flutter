// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';

import '../../../core/services/api/auth_api_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authService = AuthApiService();
  bool isLoading = false;
  String? error;

  Future<bool> register(UserRegistration user) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.register(user);
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

  Future<Map<String, dynamic>> checkStatus(String email) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final status = await _authService.checkStatus(email);
      isLoading = false;
      notifyListeners();
      return status;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}