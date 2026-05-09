import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neon_card.dart';

class SettingsPrivacyScreen extends StatefulWidget {
  final bool isEmbedded;

  const SettingsPrivacyScreen({super.key, this.isEmbedded = false});

  @override
  State<SettingsPrivacyScreen> createState() => _SettingsPrivacyScreenState();
}

class _SettingsPrivacyScreenState extends State<SettingsPrivacyScreen> {
  bool _localDataOnly = true;
  bool _syncEncrypted = false;

  void _showExportSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Export feature will be added soon.'),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'Delete all local data?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This is a demo action. No real data will be deleted.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Demo: No data was deleted.'),
                  backgroundColor: AppColors.surface,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.low),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'About Sapience AI',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sapience AI is a local-first wellness assistant.',
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Version 1.0.0 (Demo)',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            Text(
              'Not a medical diagnostic device.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.neonBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, widget.isEmbedded ? 100 : 32),
        children: [
          if (widget.isEmbedded) ...[
            const Text(
              'SETTINGS & PRIVACY',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
          // Privacy hero card
          NeonCard(
            borderGradient: AppColors.primaryGradient,
            glowShadows: [
              BoxShadow(
                color: AppColors.neonBlue.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonBlue.withOpacity(0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.lock_rounded,
                      color: Colors.black87, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your data is safe with you.',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Raw data never leaves your device.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'DATA PREFERENCES',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Local Data Only',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    'Keep all data on this device',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  value: _localDataOnly,
                  onChanged: (v) => setState(() => _localDataOnly = v),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                SwitchListTile(
                  title: const Text(
                    'Sync Encrypted Summary',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    'Upload encrypted scores only',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  value: _syncEncrypted,
                  onChanged: (v) => setState(() => _syncEncrypted = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'DATA MANAGEMENT',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.download_rounded,
                  label: 'Export My Data',
                  iconColor: AppColors.neonBlue,
                  onTap: _showExportSnackBar,
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _ActionRow(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete All Data',
                  iconColor: AppColors.low,
                  textColor: AppColors.low,
                  onTap: _showDeleteDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'APP INFO',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          NeonCard(
            padding: EdgeInsets.zero,
            child: _ActionRow(
              icon: Icons.info_outline_rounded,
              label: 'About Sapience AI',
              iconColor: AppColors.neonPurple,
              onTap: _showAbout,
            ),
          ),
          const SizedBox(height: 24),
          NeonCard(
            backgroundColor: AppColors.surface,
            child: const Text(
              'Sapience AI is a wellness monitoring tool, not a medical device. '
              'Always consult a healthcare professional for medical advice.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    if (widget.isEmbedded) return body;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SETTINGS & PRIVACY'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: body,
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.textColor = AppColors.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
        size: 20,
      ),
    );
  }
}
