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

class EditMemberScreen extends StatefulWidget {
  final MemberModel member;
  const EditMemberScreen({super.key, required this.member});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;
  
  late String _gender;
  late String _status;
  String? _selectedPlanId;
  String? _selectedTrainerId;
  late DateTime _startDate;
  late DateTime _endDate;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _ageController = TextEditingController(text: widget.member.age.toString());
    _contactController = TextEditingController(text: widget.member.contact);
    _emailController = TextEditingController(text: widget.member.email);
    _notesController = TextEditingController(text: widget.member.notes);
    _gender = widget.member.gender;
    _status = widget.member.status;
    _selectedTrainerId = widget.member.assignedTrainerId;
    _startDate = widget.member.membershipStart;
    _endDate = widget.member.membershipEnd;
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Member'),
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
                          backgroundImage: _profileImage != null 
                              ? FileImage(_profileImage!) 
                              : (widget.member.profileImage != null ? NetworkImage(widget.member.profileImage!) : null) as ImageProvider?,
                          child: (_profileImage == null && widget.member.profileImage == null) 
                              ? const Icon(Icons.camera_alt, size: 50, color: Colors.white) 
                              : null,
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
                        hint: Text(widget.member.membershipType, style: const TextStyle(color: Colors.white70)),
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
                        decoration: const InputDecoration(labelText: 'Change Membership Plan', labelStyle: TextStyle(color: Colors.white70)),
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
                        decoration: const InputDecoration(labelText: 'Assigned Trainer', labelStyle: TextStyle(color: Colors.white70)),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _status,
                        dropdownColor: AppTheme.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        items: ['Active', 'Expired', 'Pending']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _status = val!),
                        decoration: const InputDecoration(labelText: 'Status', labelStyle: TextStyle(color: Colors.white70)),
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
                          child: const Text('Update Member'),
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

    String? imageUrl = widget.member.profileImage;
    if (_profileImage != null) {
      imageUrl = await cloudinaryProvider.uploadImage(_profileImage!);
    }
    
    String membershipType = widget.member.membershipType;
    if (_selectedPlanId != null) {
       final plan = planProvider.plans.firstWhere((p) => p.id == _selectedPlanId);
       membershipType = plan.name;
    }

    final updatedMember = MemberModel(
      id: widget.member.id,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      gender: _gender,
      contact: _contactController.text,
      email: _emailController.text,
      membershipStart: _startDate,
      membershipEnd: _endDate,
      membershipType: membershipType,
      status: _status,
      assignedTrainerId: _selectedTrainerId,
      notes: _notesController.text,
      profileImage: imageUrl,
      progressImages: widget.member.progressImages,
    );

    await memberProvider.updateMember(updatedMember);
    if (mounted) Navigator.pop(context);
  }
}
