// lib/core/utils/date_utils.dart
class AdminDateUtils {
  // Format date as "dd/MM/yyyy"
  static String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  // Format date as relative time (e.g., "2 days ago", "today")
  static String formatRelativeDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return 'on ${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
    return 'today';
  }

  // Format date as "dd/MM/yyyy • hh:mm AM/PM"
  static String formatDateTime(String dateString) {
    final date = DateTime.parse(dateString);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} • ${_twoDigits(hour)}:${_twoDigits(date.minute)} $period';
  }

  // Format date as "hh:mm AM/PM"
  static String formatTime(String dateString) {
    final date = DateTime.parse(dateString);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '${_twoDigits(hour)}:${_twoDigits(date.minute)} $period';
  }

  // Format date as "dd MMM yyyy" (e.g., "12 Jan 2025")
  static String formatShortDate(String dateString) {
    final date = DateTime.parse(dateString);
    final month = _getMonthAbbreviation(date.month);
    return '${_twoDigits(date.day)} $month ${date.year}';
  }

  // Helper to ensure two-digit formatting
  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  // Get month abbreviation (e.g., "Jan", "Feb")
  static String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}