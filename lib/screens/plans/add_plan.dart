import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plan_model.dart';
import '../../providers/plan_provider.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Plan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Plan Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (Months)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              if (planProvider.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _savePlan,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save Plan'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;

    final planProvider = Provider.of<PlanProvider>(context, listen: false);

    final newPlan = PlanModel(
      id: '',
      name: _nameController.text,
      durationInMonths: int.parse(_durationController.text),
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
    );

    await planProvider.addPlan(newPlan);
    if (mounted) Navigator.pop(context);
  }
}
