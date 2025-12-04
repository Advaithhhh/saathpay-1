import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/plan_provider.dart';
import 'add_plan.dart';
import 'edit_plan.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class PlanListScreen extends StatelessWidget {
  const PlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    final plans = planProvider.plans;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Membership Plans'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: AppTheme.radiusMedium,
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${plans.length} ${plans.length == 1 ? 'Plan' : 'Plans'}',
                            style: AppTheme.titleMediumLight,
                          ),
                          Text(
                            'Manage membership options',
                            style: AppTheme.bodySmallLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Plans list
              Expanded(
                child: plans.isEmpty
                    ? EmptyState(
                        icon: Icons.workspace_premium_rounded,
                        title: 'No plans created',
                        subtitle: 'Add membership plans for your gym',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Plan icon
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppTheme.gold.withOpacity(0.15),
                                          borderRadius: AppTheme.radiusMedium,
                                        ),
                                        child: Icon(
                                          Icons.star_rounded,
                                          color: AppTheme.gold,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      
                                      // Plan details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              plan.name,
                                              style: AppTheme.titleSmall.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                _buildTag(
                                                  Icons.schedule_rounded,
                                                  '${plan.durationInMonths} ${plan.durationInMonths == 1 ? 'Month' : 'Months'}',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Price
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₹${plan.price.toStringAsFixed(0)}',
                                            style: AppTheme.titleMedium.copyWith(
                                              color: AppTheme.maroon,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            '/plan',
                                            style: AppTheme.caption,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Description if available
                                  if (plan.description.isNotEmpty) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.beige.withOpacity(0.5),
                                        borderRadius: AppTheme.radiusSmall,
                                      ),
                                      child: Text(
                                        plan.description,
                                        style: AppTheme.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  
                                  // Action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => EditPlanScreen(plan: plan),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.edit_rounded, size: 18),
                                          label: const Text('Edit'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppTheme.maroon,
                                            side: BorderSide(color: AppTheme.maroon.withOpacity(0.3)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _showDeleteDialog(context, planProvider, plan.id),
                                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                          label: const Text('Delete'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppTheme.errorRed,
                                            side: BorderSide(color: AppTheme.errorRed.withOpacity(0.3)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPlanScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text('Add Plan'),
        backgroundColor: AppTheme.warmPink,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.warmPink.withOpacity(0.1),
        borderRadius: AppTheme.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.warmPink),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.caption.copyWith(
              color: AppTheme.warmPink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PlanProvider planProvider, String planId) {
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
              child: const Icon(Icons.warning_rounded, color: AppTheme.errorRed, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Delete Plan?', style: AppTheme.titleSmall),
          ],
        ),
        content: Text(
          'This action cannot be undone. Members with this plan will not be affected.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTheme.labelLarge.copyWith(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              planProvider.deletePlan(planId);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
