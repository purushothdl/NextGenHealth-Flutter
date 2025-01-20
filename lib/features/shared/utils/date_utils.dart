// lib/features/shared widgets/utils/date_utils.dart
class FormatDateUtils {
  // Helper method to format a date string (e.g., "2025-01-10T06:18:13") into "10th Jan, 2025"
  static String formatDateString(String dateString) {
    try {
      // Parse the string into a DateTime object
      final DateTime date = DateTime.parse(dateString);

      // Get the day suffix (e.g., "th", "st", "nd", "rd")
      String daySuffix;
      switch (date.day) {
        case 1:
        case 21:
        case 31:
          daySuffix = 'st';
          break;
        case 2:
        case 22:
          daySuffix = 'nd';
          break;
        case 3:
        case 23:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }

      // Format the date
      final month = _getMonthAbbreviation(date.month);
      return '${date.day}$daySuffix $month, ${date.year}';
    } catch (e) {
      return 'Invalid Date'; // Fallback for invalid date strings
    }
  }

  // Helper method to get the abbreviated month name
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