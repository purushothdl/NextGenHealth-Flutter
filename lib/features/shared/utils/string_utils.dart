// lib/features/shared widgets/utils/string_utils.dart
class StringUtils {
  static String getCapitalisedUsername(String username) {
    return username.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
