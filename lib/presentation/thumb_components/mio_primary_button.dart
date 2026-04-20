import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Stadium primary CTA with optional blue glow (MIO auth reference).
class MioPrimaryButton extends StatelessWidget {
  const MioPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.showArrow = true,
    this.leading,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.showGlow = true,
    this.filled = true,
    this.outlinedBorderColor,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.fontSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showArrow;
  final Widget? leading;
  final Color? backgroundColor;
  final Color foregroundColor;
  final bool showGlow;
  final bool filled;
  final Color? outlinedBorderColor;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;
  final double? fontSize;

  Color get _bg => backgroundColor ?? AppColors.formBlue;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: effectiveOnPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: filled ? _bg : Colors.white,
            border: filled
                ? null
                : Border.all(color: outlinedBorderColor ?? _bg, width: 2),
          ),
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: filled ? foregroundColor : _bg,
                    ),
                  )
                else ...[
                  if (leading != null) ...[leading!, const SizedBox(width: 10)],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize ?? 16,
                      fontWeight: FontWeight.w700,
                      color: filled ? foregroundColor : _bg,
                    ),
                  ),
                  if (showArrow && !isLoading && filled) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 22,
                      color: foregroundColor,
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );

    final wrapped = filled && showGlow
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: _bg.withValues(alpha: 0.38),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: child,
          )
        : child;

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: wrapped);
    }
    return wrapped;
  }
}
