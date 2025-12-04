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
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.softGradient,
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                              child: _profileImage == null 
                                  ? const Icon(Icons.person_rounded, size: 55, color: AppTheme.maroon) 
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.warmPink,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Basic Info Section
                  _buildSectionHeader('Basic Information'),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline_rounded,
                          validator: (value) => value!.isEmpty ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _ageController,
                                label: 'Age',
                                icon: Icons.cake_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                value: _gender,
                                items: ['Male', 'Female', 'Other'],
                                label: 'Gender',
                                icon: Icons.wc_rounded,
                                onChanged: (val) => setState(() => _gender = val!),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Section
                  _buildSectionHeader('Contact Details'),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _contactController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty ? 'Phone is required' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email (Optional)',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Membership Section
                  _buildSectionHeader('Membership'),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildPlanDropdown(planProvider.plans),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildDatePicker('Start Date', _startDate, (date) {
                              setState(() {
                                _startDate = date;
                                if (_selectedPlanId != null) {
                                  final plan = planProvider.plans.firstWhere((p) => p.id == _selectedPlanId);
                                  _endDate = date.add(Duration(days: plan.durationInMonths * 30));
                                }
                              });
                            })),
                            const SizedBox(width: 12),
                            Expanded(child: _buildDatePicker('End Date', _endDate, (date) {
                              setState(() => _endDate = date);
                            })),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTrainerDropdown(trainerProvider.trainers),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notes Section
                  _buildSectionHeader('Additional Notes'),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: _buildTextField(
                      controller: _notesController,
                      label: 'Notes (Optional)',
                      icon: Icons.note_outlined,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  if (memberProvider.isLoading || cloudinaryProvider.isUploading)
                    Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 12),
                          Text(
                            cloudinaryProvider.isUploading ? 'Uploading image...' : 'Saving...',
                            style: AppTheme.bodyMediumLight,
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveMember,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Save Member'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.maroon,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: AppTheme.labelLarge,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTheme.titleSmallLight),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
        prefixIcon: Icon(icon, color: AppTheme.iconSecondary, size: 22),
        filled: true,
        fillColor: AppTheme.beige.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: BorderSide(color: AppTheme.textMuted.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: const BorderSide(color: AppTheme.warmPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: const BorderSide(color: AppTheme.errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white,
      style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.iconMuted),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
        prefixIcon: Icon(icon, color: AppTheme.iconSecondary, size: 22),
        filled: true,
        fillColor: AppTheme.beige.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildPlanDropdown(List plans) {
    return DropdownButtonFormField<String>(
      value: _selectedPlanId,
      dropdownColor: Colors.white,
      style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.iconMuted),
      items: plans.map((e) => DropdownMenuItem(
        value: e.id as String,
        child: Text('${e.name} (₹${e.price})'),
      )).toList(),
      onChanged: (val) {
        setState(() {
          _selectedPlanId = val;
          if (val != null) {
            final plan = plans.firstWhere((p) => p.id == val);
            _endDate = _startDate.add(Duration(days: plan.durationInMonths * 30));
          }
        });
      },
      decoration: InputDecoration(
        labelText: 'Membership Plan',
        labelStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
        prefixIcon: const Icon(Icons.workspace_premium_rounded, color: AppTheme.iconSecondary, size: 22),
        filled: true,
        fillColor: AppTheme.beige.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) => value == null ? 'Please select a plan' : null,
    );
  }

  Widget _buildTrainerDropdown(List trainers) {
    return DropdownButtonFormField<String>(
      value: _selectedTrainerId,
      dropdownColor: Colors.white,
      style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.iconMuted),
      items: [
        const DropdownMenuItem(value: null, child: Text('No trainer assigned')),
        ...trainers.map((e) => DropdownMenuItem(value: e.id as String, child: Text(e.name as String))),
      ],
      onChanged: (val) => setState(() => _selectedTrainerId = val),
      decoration: InputDecoration(
        labelText: 'Assign Trainer (Optional)',
        labelStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
        prefixIcon: const Icon(Icons.sports_gymnastics_rounded, color: AppTheme.iconSecondary, size: 22),
        filled: true,
        fillColor: AppTheme.beige.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: AppTheme.radiusMedium,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: AppTheme.warmTheme.copyWith(
                colorScheme: AppTheme.warmTheme.colorScheme.copyWith(
                  primary: AppTheme.maroon,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: AppTheme.radiusMedium,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.beige.withOpacity(0.5),
          borderRadius: AppTheme.radiusMedium,
          border: Border.all(color: AppTheme.textMuted.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.caption),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.iconSecondary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
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
      if (imageUrl == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.warning_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text('Photo upload failed. Saving without photo.'),
              ],
            ),
            backgroundColor: AppTheme.warningOrange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    
    final plan = planProvider.plans.firstWhere((p) => p.id == _selectedPlanId);

    final newMember = MemberModel(
      id: '',
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      gender: _gender,
      contact: _contactController.text.trim(),
      email: _emailController.text.trim(),
      membershipStart: _startDate,
      membershipEnd: _endDate,
      membershipType: plan.name,
      status: 'Active',
      assignedTrainerId: _selectedTrainerId,
      notes: _notesController.text.trim(),
      profileImage: imageUrl,
      progressImages: [],
    );

    await memberProvider.addMember(newMember);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Member added successfully!'),
            ],
          ),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }
}
