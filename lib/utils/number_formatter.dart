class NumberFormatter {
  /// Formatiert eine Zahl in eine kompakte, lesbare Zeichenfolge (z.B. 1.2 Tsd, 5.5 Mio, 2.0 Mrd).
  /// Handhabt Unendlichkeit und NaN-Fälle robust, um App-Abstürze zu verhindern.
  static String format(double number) {
    if (number.isNaN) return "NaN";
    if (number.isInfinite) return "∞";

    final double absNumber = number.abs();
    final String sign = number < 0 ? "-" : "";

    if (absNumber >= 1000000000) {
      return "$sign${(absNumber / 1000000000).toStringAsFixed(1)} Mrd";
    } else if (absNumber >= 1000000) {
      return "$sign${(absNumber / 1000000).toStringAsFixed(1)} Mio";
    } else if (absNumber >= 1000) {
      return "$sign${(absNumber / 1000).toStringAsFixed(1)} Tsd";
    } else {
      if (absNumber == absNumber.truncateToDouble()) {
        return "$sign${absNumber.toInt().toString()}";
      }
      return "$sign${absNumber.toStringAsFixed(1)}";
    }
  }
}
