import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonBlue,
        secondary: AppColors.neonCyan,
        tertiary: AppColors.neonPurple,
        surface: AppColors.surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.rajdhaniTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.rajdhani(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        headlineMedium: GoogleFonts.rajdhani(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.rajdhani(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.rajdhani(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: AppColors.cardBorder,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.neonBlue;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.neonBlue.withOpacity(0.3);
          }
          return AppColors.cardBorder;
        }),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.neonBlue,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor: AppColors.neonBlue,
        dividerColor: AppColors.cardBorder,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neonBlue, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
