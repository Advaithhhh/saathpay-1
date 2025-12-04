import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trainer_model.dart';
import '../../providers/member_provider.dart';

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
      appBar: AppBar(title: Text(trainer.name)),
      body: SingleChildScrollView(
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
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(trainer.contact),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(trainer.email),
            ),
            const Divider(),
            Text('Assigned Members (${assignedMembers.length})',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            assignedMembers.isEmpty
                ? const Text('No members assigned.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assignedMembers.length,
                    itemBuilder: (context, index) {
                      final member = assignedMembers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: member.profileImage != null
                              ? NetworkImage(member.profileImage!)
                              : null,
                          child: member.profileImage == null
                              ? Text(member.name[0])
                              : null,
                        ),
                        title: Text(member.name),
                        subtitle: Text(member.status),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
