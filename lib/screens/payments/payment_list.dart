import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/payment_provider.dart';
import 'add_payment.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final payments = paymentProvider.payments;
    
    // Calculate totals
    final totalAmount = payments.fold(0.0, (sum, p) => sum + p.amount);
    final paidCount = payments.where((p) => p.status == 'Paid').length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Payments'),
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
              // Summary header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          Icons.account_balance_wallet_rounded,
                          'Total Revenue',
                          '₹${NumberFormat('#,##0').format(totalAmount)}',
                          AppTheme.successGreen,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppTheme.textMuted.withOpacity(0.2),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          Icons.receipt_long_rounded,
                          'Transactions',
                          '${payments.length}',
                          AppTheme.warmPink,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppTheme.textMuted.withOpacity(0.2),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          Icons.check_circle_rounded,
                          'Paid',
                          '$paidCount',
                          AppTheme.statusActive,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Payments list header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Recent Transactions',
                      style: AppTheme.titleSmallLight,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // Payments list
              Expanded(
                child: payments.isEmpty
                    ? EmptyState(
                        icon: Icons.payments_rounded,
                        title: 'No payments yet',
                        subtitle: 'Record payments from your members',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          final dateStr = DateFormat('MMM dd, yyyy').format(payment.date);
                          final isPaid = payment.status == 'Paid';
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Payment type icon
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (isPaid ? AppTheme.successGreen : AppTheme.warningOrange).withOpacity(0.12),
                                      borderRadius: AppTheme.radiusMedium,
                                    ),
                                    child: Icon(
                                      isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                                      color: isPaid ? AppTheme.successGreen : AppTheme.warningOrange,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  
                                  // Payment details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          payment.memberName,
                                          style: AppTheme.titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              size: 12,
                                              color: AppTheme.iconMuted,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              dateStr,
                                              style: AppTheme.bodySmall,
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppTheme.warmPink.withOpacity(0.1),
                                                borderRadius: AppTheme.radiusSmall,
                                              ),
                                              child: Text(
                                                payment.type,
                                                style: AppTheme.caption.copyWith(
                                                  color: AppTheme.warmPink,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Amount and status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${NumberFormat('#,##0').format(payment.amount)}',
                                        style: AppTheme.titleSmall.copyWith(
                                          color: AppTheme.maroon,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      StatusBadge(status: payment.status),
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
            MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text('Add Payment'),
        backgroundColor: AppTheme.warmPink,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
