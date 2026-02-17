class NumberFormatter {
  /// Formats a number into a compact, human-readable string (e.g., 1.2K, 5.5M).
  /// This ensures the UI remains clean in the mid- to endgame.
  static String format(double number) {
    if (number >= 1000000000) {
      return "${(number / 1000000000).toStringAsFixed(1)}B";
    } else if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    } else {
      // For small numbers, show one decimal place if it's not a whole number, 
      // or just the number if it is (to save space).
      if (number == number.toInt()) {
        return number.toInt().toString();
      }
      return number.toStringAsFixed(1);
    }
  }
}
