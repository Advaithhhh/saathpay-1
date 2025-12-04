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
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null ? const Icon(Icons.person, size: 50) : null,
                        ),
                        const SizedBox(height: 16),
                        Text(user?.displayName ?? 'Owner', style: AppTheme.titleMedium),
                        Text(user?.email ?? '', style: AppTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.logout, color: AppTheme.maroon),
                        title: const Text('Logout', style: TextStyle(color: AppTheme.maroon)),
                        onTap: () {
                          // Reset all providers to clear cached data
                          Provider.of<MemberProvider>(context, listen: false).reset();
                          Provider.of<PlanProvider>(context, listen: false).reset();
                          Provider.of<PaymentProvider>(context, listen: false).reset();
                          Provider.of<AttendanceProvider>(context, listen: false).reset();
                          Provider.of<TrainerProvider>(context, listen: false).reset();
                          
                          // Sign out
                          Provider.of<AuthProvider>(context, listen: false).signOut();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
