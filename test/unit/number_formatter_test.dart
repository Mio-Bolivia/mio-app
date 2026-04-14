import 'package:flutter_test/flutter_test.dart';
import 'package:mio/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter', () {
    group('formatPrice', () {
      test('formats price with comma as decimal separator', () {
        expect(NumberFormatter.formatPrice(100.00), equals('100,00'));
      });

      test('formats price with thousand separators', () {
        expect(NumberFormatter.formatPrice(1000.00), equals('1.000,00'));
      });

      test('formats large numbers with multiple thousand separators', () {
        expect(NumberFormatter.formatPrice(1000000.00), equals('1.000.000,00'));
      });

      test('formats decimal values correctly', () {
        expect(NumberFormatter.formatPrice(99.99), equals('99,99'));
      });
    });

    group('formatCompact', () {
      test('formats thousands as K', () {
        expect(NumberFormatter.formatCompact(1000), equals('1.0K'));
      });

      test('formats millions as M', () {
        expect(NumberFormatter.formatCompact(1000000), equals('1.0M'));
      });

      test('returns small numbers as is', () {
        expect(NumberFormatter.formatCompact(100), equals('100'));
      });
    });
  });
}
