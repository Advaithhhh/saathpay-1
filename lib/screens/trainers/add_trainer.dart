import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/trainer_model.dart';
import '../../providers/trainer_provider.dart';
import '../../providers/cloudinary_provider.dart';

class AddTrainerScreen extends StatefulWidget {
  const AddTrainerScreen({super.key});

  @override
  State<AddTrainerScreen> createState() => _AddTrainerScreenState();
}

class _AddTrainerScreenState extends State<AddTrainerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  File? _photo;

  @override
  Widget build(BuildContext context) {
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Trainer')),
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
                  backgroundImage: _photo != null ? FileImage(_photo!) : null,
                  child: _photo == null ? const Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
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
              const SizedBox(height: 24),
              if (trainerProvider.isLoading || cloudinaryProvider.isUploading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _saveTrainer,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save Trainer'),
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
        _photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveTrainer() async {
    if (!_formKey.currentState!.validate()) return;

    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final trainerProvider = Provider.of<TrainerProvider>(context, listen: false);

    String? imageUrl;
    if (_photo != null) {
      imageUrl = await cloudinaryProvider.uploadImage(_photo!);
    }

    final newTrainer = TrainerModel(
      id: '',
      name: _nameController.text,
      contact: _contactController.text,
      email: _emailController.text,
      photoUrl: imageUrl,
    );

    await trainerProvider.addTrainer(newTrainer);
    if (mounted) Navigator.pop(context);
  }
}
