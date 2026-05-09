import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/neon_card.dart';
import '../../navigation/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient background glow
          const Positioned.fill(
            child: IgnorePointer(child: _AmbientBackground()),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 52),
                  _buildLogo(),
                  const SizedBox(height: 24),
                  _buildHeadline(),
                  const SizedBox(height: 52),
                  _buildFeatureRow(),
                  const SizedBox(height: 48),
                  GlowButton(
                    label: 'GET STARTED',
                    width: double.infinity,
                    height: 56,
                    fontSize: 16,
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your raw data never leaves your device.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonBlue.withOpacity(0.45),
                blurRadius: 36,
                spreadRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: Colors.black87,
            size: 52,
          ),
        ),
      ],
    );
  }

  Widget _buildHeadline() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: AppColors.primaryGradient,
          ).createShader(bounds),
          child: Text(
            'SAPIENCE AI',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Understand today. Empower tomorrow.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            letterSpacing: 0.5,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureRow() {
    return Row(
      children: [
        Expanded(
          child: _FeaturePill(
            icon: Icons.mic_rounded,
            label: 'Voice',
            desc: 'Analyze voice stability',
            colors: AppColors.primaryGradient,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeaturePill(
            icon: Icons.keyboard_rounded,
            label: 'Typing',
            desc: 'Check typing patterns',
            colors: AppColors.accentGradient,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeaturePill(
            icon: Icons.directions_walk_rounded,
            label: 'Gait',
            desc: 'Track your walk',
            colors: AppColors.warmGradient,
          ),
        ),
      ],
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final List<Color> colors;

  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.desc,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      glowShadows: [
        BoxShadow(
          color: colors.first.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: colors),
            ),
            child: Icon(icon, color: Colors.black87, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GlowPainter());
  }
}

class _GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void drawGlow(Offset center, double radius, Color color) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
      );
    }

    drawGlow(
      Offset(size.width * 0.1, size.height * 0.15),
      160,
      AppColors.neonBlue.withOpacity(0.07),
    );
    drawGlow(
      Offset(size.width * 0.9, size.height * 0.65),
      180,
      AppColors.neonPurple.withOpacity(0.07),
    );
    drawGlow(
      Offset(size.width * 0.5, size.height * 0.9),
      120,
      AppColors.neonCyan.withOpacity(0.05),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
