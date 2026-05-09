import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/score_ring.dart';

enum _GaitState { idle, walking, done }

class GaitTestScreen extends StatefulWidget {
  const GaitTestScreen({super.key});

  @override
  State<GaitTestScreen> createState() => _GaitTestScreenState();
}

class _GaitTestScreenState extends State<GaitTestScreen>
    with SingleTickerProviderStateMixin {
  _GaitState _state = _GaitState.idle;
  int _elapsed = 0;
  Timer? _timer;
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  static const int _duration = 20;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bounceCtrl.dispose();
    super.dispose();
  }

  String get _timerText {
    final e = Duration(seconds: _elapsed);
    final t = const Duration(seconds: _duration);
    String fmt(Duration d) =>
        '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return '${fmt(e)} / ${fmt(t)}';
  }

  int get _progressPct => ((_elapsed / _duration) * 100).clamp(0, 100).toInt();

  void _startWalking() {
    setState(() {
      _state = _GaitState.walking;
      _elapsed = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_elapsed >= _duration) {
        t.cancel();
        setState(() => _state = _GaitState.done);
      } else {
        setState(() => _elapsed++);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('GAIT TEST'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _state == _GaitState.done
              ? _buildResult(context)
              : _buildWalker(),
        ),
      ),
    );
  }

  Widget _buildWalker() {
    final isWalking = _state == _GaitState.walking;
    return Column(
      children: [
        const SizedBox(height: 12),
        NeonCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.neonPink.withOpacity(0.12),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: AppColors.neonPink, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Hold your phone and walk normally for 20 seconds.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        // Walking icon with bounce animation
        AnimatedBuilder(
          animation: _bounceAnim,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, isWalking ? -_bounceAnim.value : 0),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isWalking
                      ? AppColors.warmGradient
                      : [AppColors.neonPurple, AppColors.neonBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isWalking ? AppColors.neonPink : AppColors.neonPurple)
                        .withOpacity(0.45),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_walk_rounded,
                color: Colors.black87,
                size: 68,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          _timerText,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        if (isWalking) ...[
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _elapsed / _duration,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonPink),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_progressPct% complete',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 40),
        GlowButton(
          label: isWalking ? 'Walking...' : 'Start Walking',
          width: double.infinity,
          height: 54,
          gradientColors:
              isWalking ? AppColors.warmGradient : AppColors.accentGradient,
          glowColor: isWalking ? AppColors.neonPink : AppColors.neonPurple,
          onPressed: isWalking ? null : _startWalking,
        ),
        const SizedBox(height: 32),
        NeonCard(
          child: Row(
            children: [
              const Icon(Icons.tips_and_updates_rounded,
                  color: AppColors.neonPurple, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Make sure your steps are natural. You don\'t need to walk fast.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        NeonCard(
          borderGradient: AppColors.warmGradient,
          glowShadows: [
            BoxShadow(
              color: AppColors.neonPink.withOpacity(0.16),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
          child: Column(
            children: [
              const Text(
                'ANALYSIS COMPLETE',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              const ScoreRing(
                score: 89,
                size: 150,
                strokeWidth: 12,
                colors: AppColors.warmGradient,
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.neonPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.neonPink.withOpacity(0.35),
                  ),
                ),
                child: const Text(
                  'GOOD',
                  style: TextStyle(
                    color: AppColors.neonPink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your walking pattern looks steady today.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Regular short walks help maintain this stability.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GlowButton(
          label: 'Done',
          width: double.infinity,
          height: 54,
          gradientColors: AppColors.warmGradient,
          glowColor: AppColors.neonPink,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
