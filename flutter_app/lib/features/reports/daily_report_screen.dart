import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/score_ring.dart';
import '../../navigation/app_routes.dart';

class DailyReportScreen extends StatelessWidget {
  final bool isEmbedded;

  const DailyReportScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, isEmbedded ? 100 : 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate(_buildContent(context)),
            ),
          ),
        ],
      ),
    );

    if (isEmbedded) return body;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DAILY REPORT'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: body,
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    return [
      // Header
      if (isEmbedded) ...[
        const Text(
          'DAILY REPORT',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
      ],
      const Text(
        'May 9, 2025',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 24),
      // Overall score
      NeonCard(
        borderGradient: AppColors.scoreGradient,
        glowShadows: [
          BoxShadow(
            color: AppColors.neonCyan.withOpacity(0.14),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OVERALL SCORE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: AppColors.scoreGradient,
                    ).createShader(b),
                    child: const Text(
                      '92',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  const Text(
                    '/ 100',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.neonCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.neonCyan.withOpacity(0.35),
                      ),
                    ),
                    child: const Text(
                      'EXCELLENT',
                      style: TextStyle(
                        color: AppColors.neonCyan,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const ScoreRing(score: 92, size: 110),
          ],
        ),
      ),
      const SizedBox(height: 20),
      // Individual scores
      const Text(
        'BREAKDOWN',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
      const SizedBox(height: 12),
      _ScoreBar(
        label: 'Voice Stability',
        score: 88,
        icon: Icons.mic_rounded,
        colors: AppColors.primaryGradient,
      ),
      const SizedBox(height: 10),
      _ScoreBar(
        label: 'Typing Stability',
        score: 90,
        icon: Icons.keyboard_rounded,
        colors: AppColors.accentGradient,
      ),
      const SizedBox(height: 10),
      _ScoreBar(
        label: 'Gait Stability',
        score: 89,
        icon: Icons.directions_walk_rounded,
        colors: AppColors.warmGradient,
      ),
      const SizedBox(height: 20),
      // Summary
      NeonCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: AppColors.neonCyan, size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Great job! Your overall stability is excellent today. Keep maintaining these healthy habits.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      GlowButton(
        label: 'Share Summary',
        width: double.infinity,
        height: 52,
        outlined: true,
        gradientColors: AppColors.primaryGradient,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Summary sharing will be added soon.'),
              backgroundColor: AppColors.surface,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
      if (!isEmbedded) ...[
        const SizedBox(height: 12),
        GlowButton(
          label: 'Back Home',
          width: double.infinity,
          height: 52,
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            AppRoutes.dashboard,
          ),
        ),
      ],
    ];
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final int score;
  final IconData icon;
  final List<Color> colors;

  const _ScoreBar({
    required this.label,
    required this.score,
    required this.icon,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: colors),
                ),
                child: Icon(icon, color: Colors.black87, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ShaderMask(
                shaderCallback: (b) =>
                    LinearGradient(colors: colors).createShader(b),
                child: Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text(
                ' / 100',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: AppColors.cardBorder,
              valueColor: AlwaysStoppedAnimation<Color>(colors.first),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}
