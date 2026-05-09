import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'neon_card.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int? score;
  final List<Color> accentColors;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.score,
    this.accentColors = AppColors.primaryGradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 14,
      onTap: onTap,
      glowShadows: [
        BoxShadow(
          color: accentColors.first.withOpacity(0.06),
          blurRadius: 14,
          spreadRadius: 1,
        ),
      ],
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: LinearGradient(
                colors: accentColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, color: Colors.black87, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (score != null)
            ShaderMask(
              shaderCallback: (b) =>
                  LinearGradient(colors: accentColors).createShader(b),
              child: Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            )
          else
            Icon(
              Icons.chevron_right_rounded,
              color: accentColors.first.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}
