import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/trainer_model.dart';
import '../../providers/trainer_provider.dart';
import '../../providers/cloudinary_provider.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class EditTrainerScreen extends StatefulWidget {
  final TrainerModel trainer;
  const EditTrainerScreen({super.key, required this.trainer});

  @override
  State<EditTrainerScreen> createState() => _EditTrainerScreenState();
}

class _EditTrainerScreenState extends State<EditTrainerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  File? _photo;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.trainer.name);
    _contactController = TextEditingController(text: widget.trainer.contact);
    _emailController = TextEditingController(text: widget.trainer.email);
  }

  @override
  Widget build(BuildContext context) {
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Trainer'),
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
                          backgroundImage: _photo != null 
                              ? FileImage(_photo!) 
                              : (widget.trainer.photoUrl != null ? NetworkImage(widget.trainer.photoUrl!) : null) as ImageProvider?,
                          child: (_photo == null && widget.trainer.photoUrl == null) 
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
                      const SizedBox(height: 24),
                      if (trainerProvider.isLoading || cloudinaryProvider.isUploading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        ElevatedButton(
                          onPressed: _saveTrainer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Update Trainer'),
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
        _photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveTrainer() async {
    if (!_formKey.currentState!.validate()) return;

    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final trainerProvider = Provider.of<TrainerProvider>(context, listen: false);

    String? imageUrl = widget.trainer.photoUrl;
    if (_photo != null) {
      imageUrl = await cloudinaryProvider.uploadImage(_photo!);
    }

    final updatedTrainer = TrainerModel(
      id: widget.trainer.id,
      name: _nameController.text,
      contact: _contactController.text,
      email: _emailController.text,
      photoUrl: imageUrl,
    );

    await trainerProvider.updateTrainer(updatedTrainer);
    if (mounted) Navigator.pop(context);
  }
}
