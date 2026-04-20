import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import 'mio_form_typography.dart';

/// Filled rounded field with optional uppercase label above (MIO auth style).
class MioTextField extends StatelessWidget {
  const MioTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.readOnly = false,
    this.onTap,
  });

  static const double _radius = 15;

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool readOnly;
  final VoidCallback? onTap;

  InputDecoration _decoration(BuildContext context) {
    final iconColor = const Color(0xFF4B5563);
    final multi = maxLines > 1;

    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputFill,
      hintText: hintText,
      hintStyle: MioFormTypography.hint(context),
      prefixText: prefixText,
      prefixStyle: MioFormTypography.fieldValue(context),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: prefixIcon != null ? 4 : 16,
        vertical: multi ? 16 : 16,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(left: 12, right: multi ? 4 : 8),
              child: Icon(prefixIcon, size: 22, color: iconColor),
            ),
      prefixIconConstraints: prefixIcon == null
          ? null
          : BoxConstraints(minWidth: 44, minHeight: multi ? 56 : 48),
      suffixIcon: suffixIcon,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: Colors.red.shade500, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      onChanged: onChanged,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      readOnly: readOnly,
      onTap: onTap,
      style: MioFormTypography.fieldValue(context),
      decoration: _decoration(context),
    );

    if (label == null || label!.isEmpty) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!.toUpperCase(), style: MioFormTypography.fieldLabel),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
