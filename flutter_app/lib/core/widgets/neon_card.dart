import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final List<BoxShadow>? glowShadows;
  final List<Color>? borderGradient;

  const NeonCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 16,
    this.onTap,
    this.glowShadows,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: glowShadows,
      ),
      child: child,
    );

    // Gradient border variant
    if (borderGradient != null) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(colors: borderGradient!),
          boxShadow: glowShadows,
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2),
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(borderRadius - 1),
          ),
          child: child,
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
