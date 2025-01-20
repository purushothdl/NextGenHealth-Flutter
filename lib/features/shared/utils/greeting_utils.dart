// lib/features/shared widgets/utils/greeting_utils.dart

class GreetingUtils {
  static String getGreeting(String username) {
    final hour = DateTime.now().hour;

    final capitalizedUsername = username.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    if (hour < 12) {
      return 'Good Morning, $capitalizedUsername';
    } else if (hour < 18) {
      return 'Good Afternoon, $capitalizedUsername';
    } else {
      return 'Good Evening, $capitalizedUsername';
    }
  }
}


