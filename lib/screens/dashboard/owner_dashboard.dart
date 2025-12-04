import 'package:flutter/material.dart';
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, user),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient, // Use theme gradient
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(user),
                const SizedBox(height: 24),
                Text('Overview', style: AppTheme.titleMedium),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                      'Members',
                      '${memberProvider.members.length}',
                      Icons.people,
                      Colors.blue,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberListScreen())),
                    ),
                    _buildStatCard(
                      'Revenue',
                      '\u20B9${paymentProvider.payments.fold(0.0, (sum, item) => sum + item.amount)}',
                      Icons.attach_money,
                      Colors.green,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentListScreen())),
                    ),
                    _buildStatCard(
                      'Plans',
                      'Manage',
                      Icons.card_membership,
                      Colors.orange,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanListScreen())),
                    ),
                    _buildStatCard(
                      'Trainers',
                      'Manage',
                      Icons.fitness_center,
                      Colors.purple,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainerListScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Quick Actions', style: AppTheme.titleMedium),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildActionChip(context, 'Add Member', Icons.person_add, const AddMemberScreen()),
                      const SizedBox(width: 12),
                      _buildActionChip(context, 'Add Payment', Icons.payment, const AddPaymentScreen()),
                      const SizedBox(width: 12),
                      _buildActionChip(context, 'Attendance', Icons.calendar_today, const AttendanceScreen()),
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

  Widget _buildWelcomeCard(user) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person, size: 30) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back,', style: AppTheme.bodyMedium),
                  Text(
                    user?.displayName ?? 'Owner',
                    style: AppTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(value, style: AppTheme.titleLarge.copyWith(fontSize: 24)),
              const SizedBox(height: 4),
              Text(title, style: AppTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, String label, IconData icon, Widget screen) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.white.withOpacity(0.1),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }

  Widget _buildDrawer(BuildContext context, user) {
    return Drawer(
      backgroundColor: AppTheme.cardBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            accountName: Text(user?.displayName ?? 'Owner'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person) : null,
            ),
          ),
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', null),
          _buildDrawerItem(context, Icons.people, 'Members', const MemberListScreen()),
          _buildDrawerItem(context, Icons.fitness_center, 'Trainers', const TrainerListScreen()),
          _buildDrawerItem(context, Icons.card_membership, 'Plans', const PlanListScreen()),
          _buildDrawerItem(context, Icons.payment, 'Payments', const PaymentListScreen()),
          _buildDrawerItem(context, Icons.calendar_today, 'Attendance', const AttendanceScreen()),
          const Divider(color: Colors.white24),
          _buildDrawerItem(context, Icons.settings, 'Settings', const SettingsScreen()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
    );
  }
}
