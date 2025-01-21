// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/auth_api_service.dart';
import '../../../core/services/storage/storage_service.dart';
import '../../chat/providers/app_state_providers.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authService = AuthApiService();
  final StorageService _storage = StorageService();
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? currentUser;

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


  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Login and automatically store token in AuthApiService
      await _authService.login(email, password);
      // Immediately fetch profile after login
      currentUser = await _authService.getProfile();
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

  Future<bool> checkAndLoadUser() async {
    final token = await _storage.getToken();
    if (token == null) return false;

    try {
      currentUser = await _authService.getProfile();
      notifyListeners();
      return true;
    } catch (e) {
      await _storage.deleteToken();
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updatedData) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Send the updated data to the backend
      final updatedProfile = await _authService.updateProfile(updatedData);

      // Update the current user data in the provider
      currentUser = updatedProfile;

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

  Future<void> logout() async {
    await _storage.deleteToken();
    currentUser = null;
    notifyListeners();
  }
}






