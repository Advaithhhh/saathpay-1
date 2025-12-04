import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/payment_model.dart';
import '../../providers/payment_provider.dart';
import '../../providers/member_provider.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  String? _selectedMemberId;
  String _type = 'Cash';
  String _status = 'Paid';
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Payment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedMemberId,
                        dropdownColor: AppTheme.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        items: memberProvider.members
                            .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedMemberId = val),
                        decoration: const InputDecoration(labelText: 'Member', labelStyle: TextStyle(color: Colors.white70)),
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Amount', labelStyle: TextStyle(color: Colors.white70)),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _type,
                        dropdownColor: AppTheme.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        items: ['Cash', 'Online', 'Card']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _type = val!),
                        decoration: const InputDecoration(labelText: 'Payment Type', labelStyle: TextStyle(color: Colors.white70)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _status,
                        dropdownColor: AppTheme.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        items: ['Paid', 'Due']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _status = val!),
                        decoration: const InputDecoration(labelText: 'Status', labelStyle: TextStyle(color: Colors.white70)),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, color: AppTheme.accentColor),
                        label: Text(DateFormat('yyyy-MM-dd').format(_date), style: const TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (context, child) => Theme(data: AppTheme.darkTheme, child: child!),
                          );
                          if (date != null) setState(() => _date = date);
                        },
                      ),
                      const SizedBox(height: 24),
                      if (paymentProvider.isLoading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        ElevatedButton(
                          onPressed: _savePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Save Payment'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    
    final member = memberProvider.members.firstWhere((m) => m.id == _selectedMemberId);

    final newPayment = PaymentModel(
      id: '',
      memberId: _selectedMemberId!,
      memberName: member.name,
      amount: double.parse(_amountController.text),
      date: _date,
      type: _type,
      status: _status,
    );

    await paymentProvider.addPayment(newPayment);
    if (mounted) Navigator.pop(context);
  }
}
