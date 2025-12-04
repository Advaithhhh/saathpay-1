import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/member_model.dart';
import 'edit_member.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class MemberDetailsScreen extends StatelessWidget {
  final MemberModel member;

  const MemberDetailsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(member.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Hero(
                    tag: 'member_${member.id}',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: member.profileImage != null
                          ? NetworkImage(member.profileImage!)
                          : null,
                      child: member.profileImage == null
                          ? Text(member.name[0], style: const TextStyle(fontSize: 40))
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDetailRow('Status', member.status, 
                            color: member.status == 'Active' ? Colors.greenAccent : Colors.redAccent),
                        const Divider(color: Colors.white24),
                        _buildDetailRow('Plan', member.membershipType),
                        const Divider(color: Colors.white24),
                        _buildDetailRow('Start Date', DateFormat('yyyy-MM-dd').format(member.membershipStart)),
                        const Divider(color: Colors.white24),
                        _buildDetailRow('End Date', DateFormat('yyyy-MM-dd').format(member.membershipEnd)),
                        const Divider(color: Colors.white24),
                        _buildDetailRow('Contact', member.contact),
                        const Divider(color: Colors.white24),
                        _buildDetailRow('Email', member.email),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Progress Photos', style: AppTheme.titleMedium),
                ),
                const SizedBox(height: 16),
                member.progressImages.isEmpty
                    ? const Text('No progress photos yet.', style: TextStyle(color: Colors.white70))
                    : SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: member.progressImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(member.progressImages[index]),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.bodyMedium),
          Text(value, style: AppTheme.bodyLarge.copyWith(color: color ?? Colors.white)),
        ],
      ),
    );
  }
}
