import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Presentational bottom nav bar shell.
/// State (currentIndex) is managed by the parent (DashboardScreen).
class BottomNavShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;
  final VoidCallback onPlusTap;
  final List<Widget> pages;

  const BottomNavShell({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
    required this.onPlusTap,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _NavBar(
        currentIndex: currentIndex,
        onTabChange: onTabChange,
        onPlusTap: onPlusTap,
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;
  final VoidCallback onPlusTap;

  const _NavBar({
    required this.currentIndex,
    required this.onTabChange,
    required this.onPlusTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(0, Icons.home_rounded, 'Home'),
              _item(1, Icons.bar_chart_rounded, 'Reports'),
              _plusBtn(),
              _item(2, Icons.insights_rounded, 'Insights'),
              _item(3, Icons.settings_rounded, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int index, IconData icon, String label) {
    final active = currentIndex == index;
    final color = active ? AppColors.neonBlue : AppColors.textMuted;
    return GestureDetector(
      onTap: () => onTabChange(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _plusBtn() {
    return GestureDetector(
      onTap: onPlusTap,
      child: Container(
        width: 50,
        height: 50,
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
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.black87, size: 28),
      ),
    );
  }
}
