// lib/features/feedback/providers/feedback_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/feedback_api_service.dart';

class FeedbackProvider with ChangeNotifier {
  final FeedbackApiService _feedbackApiService = FeedbackApiService(); // Initialize internally
  List<dynamic> _feedbacks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<dynamic> get feedbacks => _feedbacks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Post feedback
  Future<void> postFeedback({
    required String title,
    required double rating,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _feedbackApiService.postFeedback(
        title: title,
        rating: rating,
        comment: comment,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load feedback
  Future<void> loadFeedback() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _feedbacks = await _feedbackApiService.getFeedback();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load feedback for all users (admin only)
  Future<void> loadAdminFeedback() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _feedbacks = await _feedbackApiService.getAdminFeedback();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}