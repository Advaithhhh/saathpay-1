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
          child: payments.isEmpty
              ? const Center(child: Text('No payments found', style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(payment.memberName, style: AppTheme.titleMedium.copyWith(fontSize: 16)),
                          subtitle: Text(
                            '${DateFormat('yyyy-MM-dd').format(payment.date)} • ${payment.type}',
                            style: AppTheme.bodyMedium,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\u20B9${payment.amount}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.accentColor),
                              ),
                              Text(
                                payment.status,
                                style: TextStyle(
                                  color: payment.status == 'Paid' ? Colors.greenAccent : Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
