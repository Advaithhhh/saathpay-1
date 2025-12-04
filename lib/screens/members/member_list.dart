import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/member_provider.dart';
import 'add_member.dart';
import 'member_details.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final members = memberProvider.members.where((member) {
      return member.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Members'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassCard(
                  borderRadius: 12,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search members...',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: false,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: members.isEmpty
                    ? const Center(child: Text('No members found', style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GlassCard(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Hero(
                                  tag: 'member_${member.id}',
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: member.profileImage != null
                                        ? NetworkImage(member.profileImage!)
                                        : null,
                                    child: member.profileImage == null
                                        ? Text(member.name[0], style: const TextStyle(fontWeight: FontWeight.bold))
                                        : null,
                                  ),
                                ),
                                title: Text(member.name, style: AppTheme.titleMedium.copyWith(fontSize: 16)),
                                subtitle: Text(
                                  '${member.membershipType} • ${member.status}',
                                  style: TextStyle(
                                    color: member.status == 'Active' ? Colors.greenAccent : Colors.redAccent,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MemberDetailsScreen(member: member),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMemberScreen()),
          );
        },
        child: const Icon(Icons.person_add, color: Colors.black),
      ),
    );
  }
}
