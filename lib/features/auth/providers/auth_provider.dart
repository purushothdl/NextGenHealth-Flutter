// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/auth_api_service.dart';
import '../../../core/services/firebase/firebase_service.dart';
import '../../../core/services/storage/storage_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authService = AuthApiService();
  final StorageService _storage = StorageService();
  final FirebaseService _firebaseService = FirebaseService(); // Initialize FirebaseService
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? currentUser;

  Future<bool> register(UserRegistration user) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Get FCM token internally
      final fcmToken = await _firebaseService.getFCMToken();

      // Create a new UserRegistration object with the FCM token
      final userWithFCM = UserRegistration(
        username: user.username,
        email: user.email,
        password: user.password,
        role: user.role,
        fcmToken: fcmToken ?? '', // Use an empty string if fcmToken is null
      );

      // Register user
      await _authService.register(userWithFCM);

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

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Get FCM token internally
      final fcmToken = await _firebaseService.getFCMToken();

      // Login user
      await _authService.login(email, password);

      // Update FCM token in backend
      await _authService.updateFCMToken(fcmToken.toString());

      // Fetch profile after login
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



  Future<void> logout() async {
    await _storage.deleteToken();
    currentUser = null;
    notifyListeners();
  }

}