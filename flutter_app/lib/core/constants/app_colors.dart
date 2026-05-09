import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF080C14);
  static const Color surface = Color(0xFF0D1526);
  static const Color surfaceElevated = Color(0xFF111D35);
  static const Color cardBorder = Color(0xFF1A2E4A);

  // Neon accents
  static const Color neonBlue = Color(0xFF00C8FF);
  static const Color neonCyan = Color(0xFF00FFD4);
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonPink = Color(0xFFFF4DB8);

  // Status colors (none are red/alarming — Grandma Theory)
  static const Color excellent = Color(0xFF00FFD4);
  static const Color good = Color(0xFF00C8FF);
  static const Color moderate = Color(0xFFFFB347);
  static const Color low = Color(0xFF78909C);

  // Text
  static const Color textPrimary = Color(0xFFE8F4FD);
  static const Color textSecondary = Color(0xFF8BA7C7);
  static const Color textMuted = Color(0xFF3D5A80);

  // Gradient palettes
  static const List<Color> primaryGradient = [neonBlue, neonCyan];
  static const List<Color> accentGradient = [neonPurple, neonBlue];
  static const List<Color> warmGradient = [neonPink, neonPurple];
  static const List<Color> scoreGradient = [neonCyan, neonBlue];
}
