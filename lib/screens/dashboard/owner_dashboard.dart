import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saathpay/providers/auth_provider.dart';
import 'package:saathpay/providers/member_provider.dart';
import 'package:saathpay/providers/payment_provider.dart';
import 'package:saathpay/providers/plan_provider.dart';
import 'package:saathpay/providers/trainer_provider.dart';
import 'package:saathpay/screens/members/member_list.dart';
import 'package:saathpay/screens/payments/payment_list.dart';
import 'package:saathpay/screens/plans/plan_list.dart';
import 'package:saathpay/screens/trainers/trainer_list.dart';
import 'package:saathpay/providers/attendance_provider.dart';
import 'package:saathpay/screens/attendance/attendance_today.dart';
import 'package:saathpay/screens/settings/settings_screen.dart';
import 'package:saathpay/screens/members/add_member.dart';
import 'package:saathpay/screens/payments/add_payment.dart';
import 'package:saathpay/widgets/glass_card.dart';
import 'package:saathpay/theme/app_theme.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  @override
  void initState() {
    super.initState();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    // Initialize data listeners after login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      Provider.of<PlanProvider>(context, listen: false).startListening();
      Provider.of<MemberProvider>(context, listen: false).startListening();
      Provider.of<TrainerProvider>(context, listen: false).startListening();
      Provider.of<PaymentProvider>(context, listen: false).startListening();
      Provider.of<AttendanceProvider>(context, listen: false).startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final memberProvider = Provider.of<MemberProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final planProvider = Provider.of<PlanProvider>(context);

    // Calculate total revenue
    final totalRevenue = paymentProvider.payments.fold(0.0, (sum, item) => sum + item.amount);
    
    // Count active members
    final activeMembers = memberProvider.members.where((m) => m.status == 'Active').length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: AppTheme.radiusMedium,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 22),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, user),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(user),
                  const SizedBox(height: 28),
                  
                  // Section Header
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Overview', style: AppTheme.titleMediumLight),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.95,
                    children: [
                      StatCard(
                        title: 'Members',
                        value: '${memberProvider.members.length}',
                        subtitle: '$activeMembers active',
                        icon: Icons.groups_rounded,
                        iconColor: AppTheme.warmPink,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberListScreen())),
                      ),
                      StatCard(
                        title: 'Revenue',
                        value: '₹${_formatNumber(totalRevenue)}',
                        subtitle: 'Total collected',
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: AppTheme.successGreen,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentListScreen())),
                      ),
                      StatCard(
                        title: 'Plans',
                        value: '${planProvider.plans.length}',
                        subtitle: 'Available plans',
                        icon: Icons.workspace_premium_rounded,
                        iconColor: AppTheme.gold,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanListScreen())),
                      ),
                      StatCard(
                        title: 'Trainers',
                        value: '${trainerProvider.trainers.length}',
                        subtitle: 'Team members',
                        icon: Icons.sports_gymnastics_rounded,
                        iconColor: AppTheme.coral,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainerListScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  
                  // Quick Actions Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Quick Actions', style: AppTheme.titleMediumLight),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ActionButton(
                        label: 'Add Member',
                        icon: Icons.person_add_rounded,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMemberScreen())),
                      ),
                      ActionButton(
                        label: 'Add Payment',
                        icon: Icons.payments_rounded,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPaymentScreen())),
                      ),
                      ActionButton(
                        label: 'Attendance',
                        icon: Icons.fact_check_rounded,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  Widget _buildWelcomeCard(user) {
    final now = DateTime.now();
    String greeting;
    IconData greetingIcon;
    
    if (now.hour < 12) {
      greeting = 'Good Morning';
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (now.hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_cloudy_rounded;
    } else {
      greeting = 'Good Evening';
      greetingIcon = Icons.nights_stay_rounded;
    }
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.softGradient,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null 
                  ? Icon(Icons.person_rounded, size: 28, color: AppTheme.maroon) 
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(greetingIcon, size: 16, color: AppTheme.warmPink),
                    const SizedBox(width: 6),
                    Text(
                      greeting,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user?.displayName ?? 'Owner',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, user) {
    return Drawer(
      backgroundColor: AppTheme.beige,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user?.photoURL == null 
                        ? const Icon(Icons.person_rounded, color: AppTheme.maroon, size: 36) 
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? 'Owner',
                  style: AppTheme.titleMediumLight,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: AppTheme.bodySmallLight,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: [
                _buildDrawerItem(context, Icons.dashboard_rounded, 'Dashboard', null, isSelected: true),
                _buildDrawerItem(context, Icons.groups_rounded, 'Members', const MemberListScreen()),
                _buildDrawerItem(context, Icons.sports_gymnastics_rounded, 'Trainers', const TrainerListScreen()),
                _buildDrawerItem(context, Icons.workspace_premium_rounded, 'Plans', const PlanListScreen()),
                _buildDrawerItem(context, Icons.payments_rounded, 'Payments', const PaymentListScreen()),
                _buildDrawerItem(context, Icons.fact_check_rounded, 'Attendance', const AttendanceScreen()),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Divider(),
                ),
                _buildDrawerItem(context, Icons.settings_rounded, 'Settings', const SettingsScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget? screen, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.maroon.withOpacity(0.1) : Colors.transparent,
        borderRadius: AppTheme.radiusMedium,
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          color: isSelected ? AppTheme.maroon : AppTheme.iconSecondary,
          size: 22,
        ),
        title: Text(
          title, 
          style: AppTheme.bodyLarge.copyWith(
            color: isSelected ? AppTheme.maroon : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
        onTap: () {
          Navigator.pop(context);
          if (screen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          }
        },
      ),
    );
  }
}
