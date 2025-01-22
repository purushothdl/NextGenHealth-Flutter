// lib/core/providers/notification_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/notfication_api_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationApiService _notificationApiService;
  List<dynamic> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _hasUnreadNotifications = false; // Track unread notifications

  // Private constructor
  NotificationProvider._(this._notificationApiService);

  // Factory constructor to initialize NotificationApiService internally
  factory NotificationProvider() {
    final notificationApiService = NotificationApiService(); // Initialize service
    return NotificationProvider._(notificationApiService);
  }

  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUnreadNotifications => _hasUnreadNotifications; // Expose unread state

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationApiService.getNotifications();
      _hasUnreadNotifications = _notifications.isNotEmpty; // Update unread state
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationsAsRead() async {
    try {
      await _notificationApiService.markNotificationsAsRead();
      _notifications.clear(); // Clear notifications after marking as read
      _hasUnreadNotifications = false; // Update unread state
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearUnreadNotifications() {
    _hasUnreadNotifications = false; // Clear unread state
    notifyListeners();
  }
}