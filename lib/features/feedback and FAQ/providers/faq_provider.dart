// lib/features/feedback and FAQ/providers/faq_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/auth_api_service.dart';

class FAQProvider with ChangeNotifier {
  final AuthApiService _authApiService;
  Map<String, dynamic> _faqs = {};
  bool _isLoading = false;
  String? _error;

  // Private constructor
  FAQProvider._(this._authApiService);

  // Factory constructor to initialize AuthApiService internally
  factory FAQProvider() {
    final authApiService = AuthApiService(); // Initialize AuthApiService
    return FAQProvider._(authApiService);
  }

  Map<String, dynamic> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFAQs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _faqs = await _authApiService.getFAQs();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}