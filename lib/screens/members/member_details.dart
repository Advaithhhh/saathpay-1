import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/member_model.dart';
import '../../providers/member_provider.dart';
import '../../providers/cloudinary_provider.dart';

import 'edit_member.dart';

class MemberDetailsScreen extends StatelessWidget {
  final MemberModel member;

  const MemberDetailsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditMemberScreen(member: member),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: member.profileImage != null
                    ? NetworkImage(member.profileImage!)
                    : null,
                child: member.profileImage == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Status', member.status),
            _buildInfoRow('Plan', member.membershipType),
            _buildInfoRow('Expires', DateFormat('yyyy-MM-dd').format(member.membershipEnd)),
            _buildInfoRow('Contact', member.contact),
            _buildInfoRow('Email', member.email),
            _buildInfoRow('Gender', member.gender),
            _buildInfoRow('Age', member.age.toString()),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress Photos', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () => _uploadProgressPhoto(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            member.progressImages.isEmpty
                ? const Text('No progress photos yet.')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: member.progressImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Show full screen image
                        },
                        child: Image.network(
                          member.progressImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _uploadProgressPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null && context.mounted) {
      final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      
      // Show loading?
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading...')));
      
      final imageUrl = await cloudinaryProvider.uploadImage(File(pickedFile.path));
      
      if (imageUrl != null) {
        // Update member
        final updatedMember = MemberModel(
          id: member.id,
          name: member.name,
          age: member.age,
          gender: member.gender,
          contact: member.contact,
          email: member.email,
          membershipStart: member.membershipStart,
          membershipEnd: member.membershipEnd,
          membershipType: member.membershipType,
          status: member.status,
          assignedTrainerId: member.assignedTrainerId,
          notes: member.notes,
          profileImage: member.profileImage,
          progressImages: [...member.progressImages, imageUrl],
        );
        
        await memberProvider.updateMember(updatedMember);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo uploaded!')));
        }
      }
    }
  }
}
