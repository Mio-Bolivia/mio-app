import 'package:flutter/material.dart';

/// Reusable form section wrapper
/// Adds consistent spacing and section headers
class ProductFormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsets padding;

  const ProductFormSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.padding = const EdgeInsets.only(bottom: 28),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
          if (subtitle == null) const SizedBox(height: 8),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
