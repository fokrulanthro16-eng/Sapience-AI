import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/score_ring.dart';
import '../../core/widgets/action_card.dart';
import '../../core/widgets/bottom_nav_shell.dart';
import '../../navigation/app_routes.dart';
import '../reports/daily_report_screen.dart';
import '../insights/insights_screen.dart';
import '../settings/settings_privacy_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tabIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _HomeTab(onSwitchToInsights: () => setState(() => _tabIndex = 2)),
      const DailyReportScreen(isEmbedded: true),
      const InsightsScreen(isEmbedded: true),
      const SettingsPrivacyScreen(isEmbedded: true),
    ];
  }

  void _showTestPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _TestPickerSheet(parentContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: _tabIndex,
      onTabChange: (i) => setState(() => _tabIndex = i),
      onPlusTap: _showTestPicker,
      pages: _pages,
    );
  }
}

// ─── Home Tab ────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final VoidCallback onSwitchToInsights;

  const _HomeTab({required this.onSwitchToInsights});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildGreeting(),
                const SizedBox(height: 20),
                _buildMainScoreCard(context),
                const SizedBox(height: 24),
                const Text(
                  "TODAY'S TESTS",
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTestCards(context),
                const SizedBox(height: 20),
                _buildDailyTip(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning, Alex 👋',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'May 9, 2025',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: AppColors.accentGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonPurple.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainScoreCard(BuildContext context) {
    return NeonCard(
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
                  "TODAY'S WELLNESS",
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 6),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: AppColors.scoreGradient,
                  ).createShader(b),
                  child: const Text(
                    '92',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 16),
                GlowButton(
                  label: 'View Insights',
                  height: 42,
                  fontSize: 14,
                  onPressed: onSwitchToInsights,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const ScoreRing(score: 92, size: 118),
        ],
      ),
    );
  }

  Widget _buildTestCards(BuildContext context) {
    return Column(
      children: [
        ActionCard(
          title: 'Voice Check',
          subtitle: 'Vocal stability analysis',
          icon: Icons.mic_rounded,
          score: 88,
          accentColors: AppColors.primaryGradient,
          onTap: () => Navigator.pushNamed(context, AppRoutes.voiceCheck),
        ),
        const SizedBox(height: 10),
        ActionCard(
          title: 'Typing Test',
          subtitle: 'Typing rhythm & speed',
          icon: Icons.keyboard_rounded,
          score: 90,
          accentColors: AppColors.accentGradient,
          onTap: () => Navigator.pushNamed(context, AppRoutes.typingTest),
        ),
        const SizedBox(height: 10),
        ActionCard(
          title: 'Gait Test',
          subtitle: 'Walking stability tracker',
          icon: Icons.directions_walk_rounded,
          score: 89,
          accentColors: AppColors.warmGradient,
          onTap: () => Navigator.pushNamed(context, AppRoutes.gaitTest),
        ),
      ],
    );
  }

  Widget _buildDailyTip() {
    return NeonCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.neonPurple.withOpacity(0.12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.neonPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY TIP',
                  style: TextStyle(
                    color: AppColors.neonPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Drink enough water and take short walks throughout your day to maintain steady energy levels.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Test Picker Bottom Sheet ─────────────────────────────────────────────────

class _TestPickerSheet extends StatelessWidget {
  final BuildContext parentContext;

  const _TestPickerSheet({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose a Test',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ActionCard(
            title: 'Voice Check',
            subtitle: 'Analyze your vocal stability',
            icon: Icons.mic_rounded,
            accentColors: AppColors.primaryGradient,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(parentContext, AppRoutes.voiceCheck);
            },
          ),
          const SizedBox(height: 10),
          ActionCard(
            title: 'Typing Test',
            subtitle: 'Measure typing rhythm & speed',
            icon: Icons.keyboard_rounded,
            accentColors: AppColors.accentGradient,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(parentContext, AppRoutes.typingTest);
            },
          ),
          const SizedBox(height: 10),
          ActionCard(
            title: 'Gait Test',
            subtitle: 'Track your walking stability',
            icon: Icons.directions_walk_rounded,
            accentColors: AppColors.warmGradient,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(parentContext, AppRoutes.gaitTest);
            },
          ),
        ],
      ),
    );
  }
}
