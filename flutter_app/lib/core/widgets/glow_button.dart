import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? glowColor;
  final IconData? icon;
  final bool outlined;
  final double fontSize;

  const GlowButton({
    super.key,
    required this.label,
    this.onPressed,
    this.gradientColors,
    this.width,
    this.height = 52,
    this.borderRadius = 30,
    this.glowColor,
    this.icon,
    this.outlined = false,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? AppColors.primaryGradient;
    final glow = glowColor ?? colors.first;

    if (outlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colors.first, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            foregroundColor: colors.first,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: onPressed != null ? colors : [AppColors.textMuted, AppColors.textMuted],
        ),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: glow.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.1),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.black87, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
