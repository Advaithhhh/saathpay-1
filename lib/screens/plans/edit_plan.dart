import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plan_model.dart';
import '../../providers/plan_provider.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class EditPlanScreen extends StatefulWidget {
  final PlanModel plan;
  const EditPlanScreen({super.key, required this.plan});

  @override
  State<EditPlanScreen> createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plan.name);
    _durationController = TextEditingController(text: widget.plan.durationInMonths.toString());
    _priceController = TextEditingController(text: widget.plan.price.toString());
    _descriptionController = TextEditingController(text: widget.plan.description);
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Plan'),
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
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Plan Name', labelStyle: TextStyle(color: AppTheme.textSecondary)),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _durationController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Duration (Months)', labelStyle: TextStyle(color: AppTheme.textSecondary)),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _priceController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Price', labelStyle: TextStyle(color: AppTheme.textSecondary)),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: AppTheme.textSecondary)),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      if (planProvider.isLoading)
                        const CircularProgressIndicator(color: AppTheme.maroon)
                      else
                        ElevatedButton(
                          onPressed: _savePlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.maroon,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Update Plan'),
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

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;

    final planProvider = Provider.of<PlanProvider>(context, listen: false);

    final updatedPlan = PlanModel(
      id: widget.plan.id,
      name: _nameController.text,
      durationInMonths: int.parse(_durationController.text),
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
    );

    await planProvider.updatePlan(updatedPlan);
    if (mounted) Navigator.pop(context);
  }
}
