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
  String _filterStatus = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    var members = memberProvider.members.where((member) {
      final matchesSearch = member.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == 'All' || member.status == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();

    // Sort by name
    members.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Members'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: AppTheme.radiusMedium,
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list_rounded, size: 22),
              shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
              onSelected: (value) {
                setState(() {
                  _filterStatus = value;
                });
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem('All', _filterStatus == 'All'),
                _buildPopupMenuItem('Active', _filterStatus == 'Active'),
                _buildPopupMenuItem('Inactive', _filterStatus == 'Inactive'),
              ],
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GlassCard(
                    borderRadius: 14,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _searchController,
                      style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search members...',
                        hintStyle: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textMuted,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.iconSecondary,
                          size: 22,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, size: 20),
                                color: AppTheme.iconMuted,
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                
                // Filter chips
                if (_filterStatus != 'All')
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(_filterStatus),
                        labelStyle: AppTheme.labelMedium.copyWith(color: Colors.white),
                        backgroundColor: AppTheme.warmPink,
                        deleteIcon: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                        onDeleted: () {
                          setState(() {
                            _filterStatus = 'All';
                          });
                        },
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                
                // Member count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '${members.length} ${members.length == 1 ? 'member' : 'members'}',
                        style: AppTheme.bodySmallLight,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Member list
                Expanded(
                  child: members.isEmpty
                      ? EmptyState(
                          icon: Icons.groups_rounded,
                          title: 'No members found',
                          subtitle: _searchQuery.isNotEmpty 
                              ? 'Try a different search term'
                              : 'Add your first member to get started',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GlassCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MemberDetailsScreen(member: member),
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Hero(
                                      tag: 'member_${member.id}',
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: member.status == 'Active' 
                                                ? AppTheme.statusActive.withOpacity(0.5)
                                                : AppTheme.statusInactive.withOpacity(0.5),
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 26,
                                          backgroundColor: AppTheme.peach.withOpacity(0.3),
                                          backgroundImage: member.profileImage != null
                                              ? NetworkImage(member.profileImage!)
                                              : null,
                                          child: member.profileImage == null
                                              ? Text(
                                                  member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                                                  style: AppTheme.titleMedium.copyWith(
                                                    color: AppTheme.maroon,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    
                                    // Member info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.name,
                                            style: AppTheme.titleSmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.workspace_premium_rounded,
                                                size: 14,
                                                color: AppTheme.iconMuted,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                member.membershipType,
                                                style: AppTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Status badge
                                    StatusBadge(status: member.status),
                                    const SizedBox(width: 8),
                                    
                                    // Arrow
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppTheme.iconMuted,
                                      size: 24,
                                    ),
                                  ],
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMemberScreen()),
          );
        },
        icon: const Icon(Icons.person_add_rounded, size: 22),
        label: const Text('Add Member'),
        backgroundColor: AppTheme.warmPink,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, bool isSelected) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (isSelected)
            const Icon(Icons.check_rounded, size: 18, color: AppTheme.maroon)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              color: isSelected ? AppTheme.maroon : AppTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
