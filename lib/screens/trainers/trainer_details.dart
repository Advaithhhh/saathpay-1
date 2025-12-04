import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trainer_model.dart';
import '../../providers/member_provider.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

import 'edit_trainer.dart';

class TrainerDetailsScreen extends StatelessWidget {
  final TrainerModel trainer;

  const TrainerDetailsScreen({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final assignedMembers = memberProvider.members
        .where((m) => m.assignedTrainerId == trainer.id)
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(trainer.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditTrainerScreen(trainer: trainer),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: trainer.photoUrl != null
                        ? NetworkImage(trainer.photoUrl!)
                        : null,
                    child: trainer.photoUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.phone, trainer.contact),
                        const Divider(color: Colors.white24),
                        _buildDetailRow(Icons.email, trainer.email),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Assigned Members (${assignedMembers.length})',
                    style: AppTheme.titleMedium),
                const SizedBox(height: 16),
                assignedMembers.isEmpty
                    ? const Text('No members assigned.', style: TextStyle(color: Colors.white70))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: assignedMembers.length,
                        itemBuilder: (context, index) {
                          final member = assignedMembers[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GlassCard(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: member.profileImage != null
                                      ? NetworkImage(member.profileImage!)
                                      : null,
                                  child: member.profileImage == null
                                      ? Text(member.name[0])
                                      : null,
                                ),
                                title: Text(member.name, style: const TextStyle(color: Colors.white)),
                                subtitle: Text(member.status, style: const TextStyle(color: Colors.white70)),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor),
          const SizedBox(width: 16),
          Text(value, style: AppTheme.bodyLarge),
        ],
      ),
    );
  }
}
