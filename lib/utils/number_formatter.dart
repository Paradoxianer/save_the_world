class NumberFormatter {
  /// Formats a number into a compact, human-readable string (e.g., 1.2K, 5.5M).
  /// Robustly handles Infinity and NaN cases to prevent app crashes.
  static String format(double number) {
    if (number.isNaN) return "NaN";
    if (number.isInfinite) return "∞";

    final double absNumber = number.abs();
    final String sign = number < 0 ? "-" : "";

    if (absNumber >= 1000000000) {
      return "$sign${(absNumber / 1000000000).toStringAsFixed(1)}B";
    } else if (absNumber >= 1000000) {
      return "$sign${(absNumber / 1000000).toStringAsFixed(1)}M";
    } else if (absNumber >= 1000) {
      return "$sign${(absNumber / 1000).toStringAsFixed(1)}K";
    } else {
      // For small numbers, check if it's effectively a whole number
      // but do it safely without throwing exceptions on edge cases.
      if (absNumber == absNumber.truncateToDouble()) {
        return "$sign${absNumber.toInt().toString()}";
      }
      return "$sign${absNumber.toStringAsFixed(1)}";
    }
  }
}
