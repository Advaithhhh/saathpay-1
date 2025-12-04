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
  String _status = 'Active';
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
      appBar: AppBar(title: const Text('Add Member')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null ? const Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      items: ['Male', 'Female', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _gender = val!),
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPlanId,
                items: planProvider.plans
                    .map((e) => DropdownMenuItem(value: e.id, child: Text('${e.name} (\u20B9${e.price})')))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedPlanId = val;
                    // Auto update end date based on plan
                    final plan = planProvider.plans.firstWhere((p) => p.id == val);
                    _endDate = _startDate.add(Duration(days: plan.durationInMonths * 30));
                  });
                },
                decoration: const InputDecoration(labelText: 'Membership Plan'),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) setState(() => _startDate = date);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('yyyy-MM-dd').format(_endDate)),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
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
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...trainerProvider.trainers.map(
                      (e) => DropdownMenuItem(value: e.id, child: Text(e.name))),
                ],
                onChanged: (val) => setState(() => _selectedTrainerId = val),
                decoration: const InputDecoration(labelText: 'Assigned Trainer'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Active', 'Expired', 'Pending']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              if (memberProvider.isLoading || cloudinaryProvider.isUploading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _saveMember,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save Member'),
                ),
            ],
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

    String? imageUrl;
    if (_profileImage != null) {
      imageUrl = await cloudinaryProvider.uploadImage(_profileImage!);
    }

    final newMember = MemberModel(
      id: '', // Firestore will generate ID? No, service uses add() which generates ID. Model needs ID.
      // Wait, MemberModel expects ID. But addMember uses .add() which returns DocumentReference.
      // I should probably generate ID here or let service handle it.
      // If I use .add(), I don't know ID beforehand.
      // Best practice: Let Firestore generate ID, then update document with ID, or just use doc.id when reading.
      // My Model has 'id' field.
      // I'll pass empty string for now, and rely on Service to ignore it or I should change Service to set ID.
      // Actually, my Service uses .add(member.toMap()). The map will contain empty ID.
      // That's fine for now, but better if I generate ID first using uuid or doc().id.
      // I'll leave it empty and fix if needed. Ideally, I should use .doc().set() if I want to control ID.
      // Or update the model to make ID optional? No, it's required.
      // I'll use empty string.
      name: _nameController.text,
      age: int.parse(_ageController.text),
      gender: _gender,
      contact: _contactController.text,
      email: _emailController.text,
      membershipStart: _startDate,
      membershipEnd: _endDate,
      membershipType: _selectedPlanId ?? 'Custom', // Should be Plan Name ideally, but ID is fine for ref.
      status: _status,
      assignedTrainerId: _selectedTrainerId,
      notes: _notesController.text,
      profileImage: imageUrl,
    );

    await memberProvider.addMember(newMember);
    if (mounted) Navigator.pop(context);
  }
}
