import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/member_provider.dart';
import '../../providers/plan_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/trainer_provider.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Profile picture with gradient border
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.softGradient,
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null 
                              ? const Icon(Icons.person_rounded, size: 48, color: AppTheme.maroon) 
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user?.displayName ?? 'Owner',
                        style: AppTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: AppTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withOpacity(0.1),
                          borderRadius: AppTheme.radiusSmall,
                          border: Border.all(
                            color: AppTheme.successGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppTheme.successGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Verified Account',
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.successGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Settings Options
                GlassCard(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        icon: Icons.person_outline_rounded,
                        title: 'Account Settings',
                        subtitle: 'Manage your profile',
                        onTap: () {
                          // TODO: Navigate to account settings
                          _showComingSoonSnackbar(context, 'Account Settings');
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        context,
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage alerts and reminders',
                        onTap: () {
                          _showComingSoonSnackbar(context, 'Notifications');
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        context,
                        icon: Icons.business_outlined,
                        title: 'Gym Details',
                        subtitle: 'Update gym information',
                        onTap: () {
                          _showComingSoonSnackbar(context, 'Gym Details');
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        context,
                        icon: Icons.palette_outlined,
                        title: 'Appearance',
                        subtitle: 'Theme and display options',
                        onTap: () {
                          _showComingSoonSnackbar(context, 'Appearance');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Support Section
                GlassCard(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        subtitle: 'FAQs and contact support',
                        onTap: () {
                          _showComingSoonSnackbar(context, 'Help & Support');
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        context,
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        subtitle: 'App version and info',
                        onTap: () {
                          _showAboutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Logout Button
                GlassCard(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showLogoutDialog(context),
                      borderRadius: AppTheme.radiusMedium,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed.withOpacity(0.1),
                                borderRadius: AppTheme.radiusMedium,
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: AppTheme.errorRed,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Logout',
                                style: AppTheme.titleSmall.copyWith(
                                  color: AppTheme.errorRed,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppTheme.errorRed.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // App version
                Center(
                  child: Text(
                    'SaathPay v1.0.0',
                    style: AppTheme.caption.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.warmPink.withOpacity(0.1),
                  borderRadius: AppTheme.radiusMedium,
                ),
                child: Icon(
                  icon,
                  color: AppTheme.warmPink,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.iconMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: AppTheme.textMuted.withOpacity(0.15),
        height: 1,
      ),
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.construction_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('$feature coming soon!'),
          ],
        ),
        backgroundColor: AppTheme.warmPink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLarge),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.warmPink.withOpacity(0.1),
                borderRadius: AppTheme.radiusSmall,
              ),
              child: const Icon(Icons.fitness_center_rounded, color: AppTheme.maroon, size: 24),
            ),
            const SizedBox(width: 12),
            Text('SaathPay', style: AppTheme.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gym Management Made Simple',
              style: AppTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildAboutRow('Version', '1.0.0'),
            _buildAboutRow('Build', '2024.12'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: AppTheme.labelLarge.copyWith(color: AppTheme.maroon)),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.bodyMedium),
          Text(value, style: AppTheme.labelMedium),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLarge),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: AppTheme.radiusSmall,
              ),
              child: const Icon(Icons.logout_rounded, color: AppTheme.errorRed, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Logout?', style: AppTheme.titleSmall),
          ],
        ),
        content: Text(
          'Are you sure you want to logout? You\'ll need to sign in again to access your account.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTheme.labelLarge.copyWith(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              // Reset all providers
              Provider.of<MemberProvider>(context, listen: false).reset();
              Provider.of<PlanProvider>(context, listen: false).reset();
              Provider.of<PaymentProvider>(context, listen: false).reset();
              Provider.of<AttendanceProvider>(context, listen: false).reset();
              Provider.of<TrainerProvider>(context, listen: false).reset();
              
              // Sign out
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.pop(ctx);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
