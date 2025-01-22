// lib/core/utils/notification_utils.dart
import 'package:flutter/material.dart';

class NotificationUtils {
  // Get icon and color based on notification type
  static (IconData, Color) getNotificationMeta(String type) {
    switch (type) {
      case 'report_submitted':
        return (Icons.assignment_turned_in_rounded, Colors.orange.shade600);
      case 'ticket_created':
        return (Icons.add_task_rounded, Colors.green.shade600);
      case 'ticket_assigned':
        return (Icons.person_add_alt_1_rounded, Colors.blue.shade700);
      case 'user_registered':
        return (Icons.person_add_rounded, Colors.purple.shade600);
      case 'alert':
        return (Icons.warning_amber_rounded, Colors.red.shade400);
      default:
        return (Icons.notifications_active_rounded, Colors.blue.shade600);
    }
  }

  // Get color based on notification type
  static Color getTypeColor(String type) {
    switch (type) {
      case 'report_submitted':
        return Colors.orange.shade600;
      case 'ticket_created':
        return Colors.green.shade600;
      case 'ticket_assigned':
        return Colors.blue.shade700;
      case 'user_registered':
        return Colors.purple.shade600;
      case 'alert':
        return Colors.red.shade400;
      default:
        return Colors.blue.shade600;
    }
  }

  // Format notification type for display
  static String formatType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Format date for display
  static String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} • $hour:${date.minute.toString().padLeft(2, '0')} $period';
  }
}