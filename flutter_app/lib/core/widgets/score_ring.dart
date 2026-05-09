import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ScoreRing extends StatelessWidget {
  final int score;
  final double size;
  final double strokeWidth;
  final List<Color>? colors;
  final String? centerLabel;

  const ScoreRing({
    super.key,
    required this.score,
    this.size = 140,
    this.strokeWidth = 10,
    this.colors,
    this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    final ringColors = colors ?? AppColors.scoreGradient;
    final glowColor = ringColors.first;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.18),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ScoreRingPainter(
          progress: score / 100.0,
          colors: ringColors,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  color: glowColor,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              Text(
                centerLabel ?? '/ 100',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: size * 0.08,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  _ScoreRingPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    if (progress <= 0) return;

    // Glow halo
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = colors.first.withOpacity(0.22)
        ..strokeWidth = strokeWidth + 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Gradient arc
    final sweepGradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: colors.length >= 2 ? colors : [colors.first, colors.first],
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..shader = sweepGradient.createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) =>
      old.progress != progress || old.colors != colors;
}
