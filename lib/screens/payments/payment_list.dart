import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/payment_provider.dart';
import 'add_payment.dart';

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final payments = paymentProvider.payments;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: payments.isEmpty
          ? const Center(child: Text('No payments found'))
          : ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return ListTile(
                  title: Text(payment.memberName),
                  subtitle: Text('${DateFormat('yyyy-MM-dd').format(payment.date)} • ${payment.type}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\u20B9${payment.amount}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        payment.status,
                        style: TextStyle(
                          color: payment.status == 'Paid' ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
