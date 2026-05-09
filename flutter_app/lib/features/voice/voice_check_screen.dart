import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/score_ring.dart';

enum _VoiceState { idle, recording, done }

class VoiceCheckScreen extends StatefulWidget {
  const VoiceCheckScreen({super.key});

  @override
  State<VoiceCheckScreen> createState() => _VoiceCheckScreenState();
}

class _VoiceCheckScreenState extends State<VoiceCheckScreen>
    with SingleTickerProviderStateMixin {
  _VoiceState _state = _VoiceState.idle;
  int _elapsed = 0;
  Timer? _timer;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const int _duration = 10;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String get _timerText {
    final e = Duration(seconds: _elapsed);
    final t = const Duration(seconds: _duration);
    String fmt(Duration d) =>
        '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return '${fmt(e)} / ${fmt(t)}';
  }

  void _startRecording() {
    setState(() {
      _state = _VoiceState.recording;
      _elapsed = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_elapsed >= _duration) {
        t.cancel();
        setState(() => _state = _VoiceState.done);
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
        title: const Text('VOICE CHECK'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _state == _VoiceState.done
              ? _buildResult(context)
              : _buildRecorder(),
        ),
      ),
    );
  }

  Widget _buildRecorder() {
    final isRecording = _state == _VoiceState.recording;
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
                  color: AppColors.neonBlue.withOpacity(0.12),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: AppColors.neonBlue, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Speak naturally for 10 seconds in a quiet place.',
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
        // Glowing microphone
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => Transform.scale(
            scale: isRecording ? _pulseAnim.value : 1.0,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isRecording
                      ? [AppColors.neonPink, AppColors.neonPurple]
                      : AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isRecording ? AppColors.neonPink : AppColors.neonBlue)
                        .withOpacity(0.45),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: Colors.black87,
                size: 64,
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
        const SizedBox(height: 40),
        GlowButton(
          label: isRecording ? 'Recording...' : 'Start Recording',
          width: double.infinity,
          height: 54,
          gradientColors: isRecording
              ? [AppColors.neonPink, AppColors.neonPurple]
              : AppColors.primaryGradient,
          glowColor: isRecording ? AppColors.neonPink : AppColors.neonBlue,
          onPressed: isRecording ? null : _startRecording,
        ),
        const SizedBox(height: 32),
        _buildTips(),
      ],
    );
  }

  Widget _buildTips() {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TIPS FOR BEST RESULTS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...[
            (Icons.record_voice_over_rounded, 'Speak clearly and naturally'),
            (Icons.volume_off_rounded, 'Avoid background noise'),
            (Icons.self_improvement_rounded, 'Relax — just be yourself'),
          ].map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(tip.$1, color: AppColors.neonBlue, size: 16),
                  const SizedBox(width: 10),
                  Text(
                    tip.$2,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        NeonCard(
          borderGradient: AppColors.primaryGradient,
          glowShadows: [
            BoxShadow(
              color: AppColors.neonCyan.withOpacity(0.18),
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
                score: 88,
                size: 150,
                strokeWidth: 12,
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.neonBlue.withOpacity(0.35),
                  ),
                ),
                child: const Text(
                  'GOOD',
                  style: TextStyle(
                    color: AppColors.neonBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your voice stability looks good today.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep checking daily for meaningful trends.',
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
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
