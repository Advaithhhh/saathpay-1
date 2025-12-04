import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/member_model.dart';
import '../../providers/member_provider.dart';
import '../../providers/plan_provider.dart';
import '../../providers/trainer_provider.dart';
import '../../providers/cloudinary_provider.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _gender = 'Male';
  String? _selectedPlanId;
  String? _selectedTrainerId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Member'),
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
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null ? const Icon(Icons.camera_alt, size: 50, color: Colors.white) : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white70)),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(labelText: 'Age', labelStyle: TextStyle(color: Colors.white70)),
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              dropdownColor: AppTheme.cardBackground,
                              style: const TextStyle(color: Colors.white),
                              items: ['Male', 'Female', 'Other']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) => setState(() => _gender = val!),
                              decoration: const InputDecoration(labelText: 'Gender', labelStyle: TextStyle(color: Colors.white70)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _contactController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Contact', labelStyle: TextStyle(color: Colors.white70)),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white70)),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedPlanId,
                        dropdownColor: AppTheme.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        items: planProvider.plans
                            .map((e) => DropdownMenuItem(value: e.id, child: Text('${e.name} (\u20B9${e.price})')))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedPlanId = val;
                            final plan = planProvider.plans.firstWhere((p) => p.id == val);
                            _endDate = _startDate.add(Duration(days: plan.durationInMonths * 30));
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Membership Plan', labelStyle: TextStyle(color: Colors.white70)),
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              icon: const Icon(Icons.calendar_today, color: AppTheme.accentColor),
                              label: Text(DateFormat('yyyy-MM-dd').format(_startDate), style: const TextStyle(color: Colors.white)),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) => Theme(data: AppTheme.darkTheme, child: child!),
                                );
                                if (date != null) setState(() => _startDate = date);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextButton.icon(
                              icon: const Icon(Icons.calendar_today, color: AppTheme.accentColor),
                              label: Text(DateFormat('yyyy-MM-dd').format(_endDate), style: const TextStyle(color: Colors.white)),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _endDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) => Theme(data: AppTheme.darkTheme, child: child!),
                                );
                                if (date != null) setState(() => _endDate = date);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedTrainerId,
                        dropdownColor: AppTheme.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('None')),
                          ...trainerProvider.trainers.map(
                              (e) => DropdownMenuItem(value: e.id, child: Text(e.name))),
                        ],
                        onChanged: (val) => setState(() => _selectedTrainerId = val),
                        decoration: const InputDecoration(labelText: 'Assign Trainer', labelStyle: TextStyle(color: Colors.white70)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Notes', labelStyle: TextStyle(color: Colors.white70)),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      if (memberProvider.isLoading || cloudinaryProvider.isUploading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        ElevatedButton(
                          onPressed: _saveMember,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Save Member'),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    final planProvider = Provider.of<PlanProvider>(context, listen: false);

    String? imageUrl;
    if (_profileImage != null) {
      imageUrl = await cloudinaryProvider.uploadImage(_profileImage!);
    }
    
    final plan = planProvider.plans.firstWhere((p) => p.id == _selectedPlanId);

    final newMember = MemberModel(
      id: '',
      name: _nameController.text,
      age: int.parse(_ageController.text),
      gender: _gender,
      contact: _contactController.text,
      email: _emailController.text,
      membershipStart: _startDate,
      membershipEnd: _endDate,
      membershipType: plan.name,
      status: 'Active',
      assignedTrainerId: _selectedTrainerId,
      notes: _notesController.text,
      profileImage: imageUrl,
      progressImages: [],
    );

    await memberProvider.addMember(newMember);
    if (mounted) Navigator.pop(context);
  }
}
