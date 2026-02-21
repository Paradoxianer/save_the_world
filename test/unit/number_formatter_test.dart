import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/utils/number_formatter.dart';

void main() {
  group('NumberFormatter Tests (German Suffixes & International Dot)', () {
    test('Format small numbers', () {
      expect(NumberFormatter.format(0), '0');
      expect(NumberFormatter.format(42), '42');
      expect(NumberFormatter.format(999), '999');
      // Präzision bei Kommazahlen < 1000 (nutzt Punkt)
      expect(NumberFormatter.format(10.5), '10.5'); 
    });

    test('Format thousands (Tsd)', () {
      expect(NumberFormatter.format(1000), '1.0 Tsd');
      expect(NumberFormatter.format(1500), '1.5 Tsd');
      expect(NumberFormatter.format(10000), '10.0 Tsd');
    });

    test('Format millions (Mio)', () {
      expect(NumberFormatter.format(1000000), '1.0 Mio');
      expect(NumberFormatter.format(2500000), '2.5 Mio');
    });

    test('Format billions (Mrd)', () {
      expect(NumberFormatter.format(1000000000), '1.0 Mrd');
      expect(NumberFormatter.format(1500000000), '1.5 Mrd');
    });

    test('Special cases: NaN and Infinity', () {
      expect(NumberFormatter.format(double.nan), 'NaN');
      expect(NumberFormatter.format(double.infinity), '∞');
    });
  });
}
