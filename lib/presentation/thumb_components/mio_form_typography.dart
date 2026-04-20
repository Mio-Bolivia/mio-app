import 'package:flutter/material.dart';

/// Shared text styles for form labels and hints (thumbComponents).
abstract final class MioFormTypography {
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.85,
    color: Color(0xFF6B7280),
  );

  static TextStyle hint(BuildContext context) => TextStyle(
    fontSize: 15,
    color: Colors.grey.shade600,
    fontWeight: FontWeight.w400,
  );

  static TextStyle fieldValue(BuildContext context) => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0xFF111827),
  );
}
