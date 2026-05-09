import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';
import '../../core/widgets/glow_button.dart';

class InsightsScreen extends StatefulWidget {
  final bool isEmbedded;

  const InsightsScreen({super.key, this.isEmbedded = false});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock 7-day data: [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  static const _voiceScores = [72, 78, 74, 85, 82, 88, 88];
  static const _typingScores = [80, 82, 79, 86, 88, 90, 90];
  static const _gaitScores = [75, 80, 76, 84, 86, 87, 89];
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLearnMore(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'About Insights',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Sapience AI gives wellness insights, not medical diagnoses.\n\n'
          'These trends help you understand your patterns over time. '
          'If you notice persistent changes, consider speaking with a healthcare professional.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppColors.neonBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isEmbedded) ...[
                  const Text(
                    'INSIGHTS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Last 7 days',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Trends'),
                    Tab(text: 'Comparison'),
                    Tab(text: 'Advice'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TrendsTab(
                  scores: _voiceScores,
                  days: _days,
                  onLearnMore: () => _showLearnMore(context),
                ),
                _ComparisonTab(
                  voiceScores: _voiceScores,
                  typingScores: _typingScores,
                  gaitScores: _gaitScores,
                  days: _days,
                ),
                _AdviceTab(onLearnMore: () => _showLearnMore(context)),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.isEmbedded) return content;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('INSIGHTS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: content,
    );
  }
}

// ─── Trends Tab ──────────────────────────────────────────────────────────────

class _TrendsTab extends StatelessWidget {
  final List<int> scores;
  final List<String> days;
  final VoidCallback onLearnMore;

  const _TrendsTab({
    required this.scores,
    required this.days,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        NeonCard(
          borderGradient: AppColors.primaryGradient,
          glowShadows: [
            BoxShadow(
              color: AppColors.neonBlue.withOpacity(0.1),
              blurRadius: 20,
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VOICE STABILITY — 7 DAYS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your stability is improving! 📈',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _BarChart(scores: scores, days: days, colors: AppColors.primaryGradient),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WEEKLY AVERAGE',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AvgChip(label: 'Voice', value: '81', colors: AppColors.primaryGradient),
                  _AvgChip(label: 'Typing', colors: AppColors.accentGradient, value: '85'),
                  _AvgChip(label: 'Gait', colors: AppColors.warmGradient, value: '82'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlowButton(
          label: 'Learn More',
          width: double.infinity,
          height: 50,
          outlined: true,
          gradientColors: AppColors.primaryGradient,
          onPressed: onLearnMore,
        ),
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<int> scores;
  final List<String> days;
  final List<Color> colors;

  const _BarChart({
    required this.scores,
    required this.days,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final maxScore = scores.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(scores.length, (i) {
          final h = (scores[i] / maxScore) * 80;
          final isLast = i == scores.length - 1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: isLast
                            ? colors
                            : [
                                colors.first.withOpacity(0.4),
                                colors.last.withOpacity(0.4),
                              ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      boxShadow: isLast
                          ? [
                              BoxShadow(
                                color: colors.first.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[i],
                    style: TextStyle(
                      color: isLast
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontSize: 10,
                      fontWeight:
                          isLast ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AvgChip extends StatelessWidget {
  final String label;
  final String value;
  final List<Color> colors;

  const _AvgChip({
    required this.label,
    required this.value,
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
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ─── Comparison Tab ───────────────────────────────────────────────────────────

class _ComparisonTab extends StatelessWidget {
  final List<int> voiceScores;
  final List<int> typingScores;
  final List<int> gaitScores;
  final List<String> days;

  const _ComparisonTab({
    required this.voiceScores,
    required this.typingScores,
    required this.gaitScores,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ALL METRICS — 7 DAYS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _MultiBarChart(
                voiceScores: voiceScores,
                typingScores: typingScores,
                gaitScores: gaitScores,
                days: days,
              ),
              const SizedBox(height: 16),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Legend(label: 'Voice', color: AppColors.neonBlue),
                  const SizedBox(width: 16),
                  _Legend(label: 'Typing', color: AppColors.neonPurple),
                  const SizedBox(width: 16),
                  _Legend(label: 'Gait', color: AppColors.neonPink),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NeonCard(
          child: const Text(
            'Typing stability is your strongest metric this week. '
            'Consider adding short voice exercises to boost vocal consistency.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiBarChart extends StatelessWidget {
  final List<int> voiceScores;
  final List<int> typingScores;
  final List<int> gaitScores;
  final List<String> days;

  const _MultiBarChart({
    required this.voiceScores,
    required this.typingScores,
    required this.gaitScores,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (i) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _miniBar(voiceScores[i], AppColors.neonBlue),
                    const SizedBox(width: 2),
                    _miniBar(typingScores[i], AppColors.neonPurple),
                    const SizedBox(width: 2),
                    _miniBar(gaitScores[i], AppColors.neonPink),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  days[i],
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _miniBar(int score, Color color) {
    return Container(
      width: 6,
      height: score * 0.7,
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;

  const _Legend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}

// ─── Advice Tab ───────────────────────────────────────────────────────────────

class _AdviceTab extends StatelessWidget {
  final VoidCallback onLearnMore;

  const _AdviceTab({required this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        NeonCard(
          borderGradient: AppColors.accentGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: AppColors.accentGradient),
                    ),
                    child: const Icon(Icons.tips_and_updates_rounded,
                        color: Colors.black87, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PERSONALIZED ADVICE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Try evening walks and deep breathing exercises.',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...[
          (
            Icons.bedtime_rounded,
            'Sleep Quality',
            'Maintain a consistent sleep schedule — aim for 7-8 hours.',
            AppColors.neonPurple,
          ),
          (
            Icons.water_drop_rounded,
            'Hydration',
            'Drink at least 8 glasses of water daily for vocal clarity.',
            AppColors.neonBlue,
          ),
          (
            Icons.self_improvement_rounded,
            'Mindfulness',
            'Short breathing exercises can improve voice stability.',
            AppColors.neonCyan,
          ),
          (
            Icons.directions_walk_rounded,
            'Movement',
            'Regular short walks support gait consistency and balance.',
            AppColors.neonPink,
          ),
        ].map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NeonCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tip.$4.withOpacity(0.12),
                    ),
                    child: Icon(tip.$1, color: tip.$4, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.$2,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tip.$3,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GlowButton(
          label: 'Learn More',
          width: double.infinity,
          height: 50,
          outlined: true,
          gradientColors: AppColors.accentGradient,
          onPressed: onLearnMore,
        ),
      ],
    );
  }
}
