import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get padding => mediaQuery.padding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}

extension StringExtensions on String {
  bool get isValidPhoneNumber {
    final digits = replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10;
  }

  String get phoneDisplay {
    if (length >= 10) {
      return '+${substring(0, 2)} (${substring(2, 6)}) ${substring(6)}';
    }
    return this;
  }
}

extension DoubleExtensions on double {
  String toPriceFormatted([String currency = 'Bs.']) {
    return '$currency ${NumberFormatter.formatPrice(this)}';
  }
}

class NumberFormatter {
  NumberFormatter._();

  static String formatPrice(double price) {
    return price
        .toStringAsFixed(2)
        .replaceAll('.', ',')
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
