import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';
import '../../core/widgets/glow_button.dart';

enum _TypingState { idle, typing, done }

class TypingTestScreen extends StatefulWidget {
  const TypingTestScreen({super.key});

  @override
  State<TypingTestScreen> createState() => _TypingTestScreenState();
}

class _TypingTestScreenState extends State<TypingTestScreen> {
  static const String _sentence =
      'The quick brown fox jumps over the lazy dog.';

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _TypingState _state = _TypingState.idle;
  int _elapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_state == _TypingState.idle && _controller.text.isNotEmpty) {
      _startTimer();
    }
    setState(() {});
  }

  void _startTimer() {
    setState(() => _state = _TypingState.typing);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed++);
    });
  }

  void _finishTest() {
    _timer?.cancel();
    _focusNode.unfocus();
    setState(() => _state = _TypingState.done);
  }

  int get _charCount => _controller.text.length;

  double get _accuracy {
    if (_controller.text.isEmpty) return 100;
    int correct = 0;
    final typed = _controller.text;
    for (int i = 0; i < typed.length && i < _sentence.length; i++) {
      if (typed[i] == _sentence[i]) correct++;
    }
    return (correct / typed.length * 100).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('TYPING TEST'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _state == _TypingState.done
              ? _buildResult(context)
              : _buildTest(),
        ),
      ),
    );
  }

  Widget _buildTest() {
    final isActive = _state == _TypingState.typing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeonCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.neonPurple.withOpacity(0.12),
                ),
                child: const Icon(Icons.keyboard_rounded,
                    color: AppColors.neonPurple, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Type the sentence below as naturally as you can.',
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
        const SizedBox(height: 20),
        // Target sentence
        NeonCard(
          borderGradient: AppColors.accentGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TYPE THIS:',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _sentence,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Live stats
        if (isActive) ...[
          Row(
            children: [
              _StatChip(
                label: 'Characters',
                value: '$_charCount',
                color: AppColors.neonBlue,
              ),
              const SizedBox(width: 10),
              _StatChip(
                label: 'Time',
                value: '${_elapsed}s',
                color: AppColors.neonCyan,
              ),
              const SizedBox(width: 10),
              _StatChip(
                label: 'Accuracy',
                value: '${_accuracy.toStringAsFixed(0)}%',
                color: AppColors.neonPurple,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        // Text input
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: _state != _TypingState.done,
          maxLines: 3,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: 'Start typing here...',
            counterText: '$_charCount / ${_sentence.length} characters',
            counterStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
          autofocus: false,
        ),
        const SizedBox(height: 24),
        GlowButton(
          label: isActive ? 'Finish Test' : 'Start Test',
          width: double.infinity,
          height: 54,
          gradientColors: isActive ? AppColors.accentGradient : AppColors.primaryGradient,
          glowColor: isActive ? AppColors.neonPurple : AppColors.neonBlue,
          onPressed: isActive
              ? _finishTest
              : () => _focusNode.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        NeonCard(
          borderGradient: AppColors.accentGradient,
          glowShadows: [
            BoxShadow(
              color: AppColors.neonPurple.withOpacity(0.16),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
          child: Column(
            children: [
              const Text(
                'TEST COMPLETE',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(
                    label: 'Speed',
                    value: '62',
                    unit: 'WPM',
                    colors: AppColors.primaryGradient,
                  ),
                  _ResultStat(
                    label: 'Accuracy',
                    value: '96',
                    unit: '%',
                    colors: AppColors.accentGradient,
                  ),
                  _ResultStat(
                    label: 'Stability',
                    value: '88',
                    unit: '%',
                    colors: AppColors.warmGradient,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.neonPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.neonPurple.withOpacity(0.35),
                  ),
                ),
                child: const Text(
                  'STABLE',
                  style: TextStyle(
                    color: AppColors.neonPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your typing pattern looks stable today.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
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
          gradientColors: AppColors.accentGradient,
          glowColor: AppColors.neonPurple,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final List<Color> colors;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) => LinearGradient(colors: colors).createShader(b),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        Text(
          unit,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
