import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'mio_form_typography.dart';

/// Styled [DropdownButtonFormField] matching [MioTextField] visuals.
class MioDropdownFormField<T> extends StatelessWidget {
  const MioDropdownFormField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.enabled = true,
  });

  static const double _radius = 15;

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final IconData? prefixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final iconColor = const Color(0xFF4B5563);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: MioFormTypography.fieldLabel),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          key: ValueKey(value),
          initialValue: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          style: MioFormTypography.fieldValue(context),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputFill,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 22, color: iconColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: BorderSide(
                color: AppColors.formBlue.withValues(alpha: 0.45),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.expand_more_rounded, color: iconColor),
        ),
      ],
    );
  }
}
