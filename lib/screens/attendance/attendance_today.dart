import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/member_provider.dart';
import '../../models/attendance_model.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);

    // Get all active members
    final activeMembers = memberProvider.members.where((m) => m.status == 'Active').toList();
    
    // Count present members
    final presentCount = attendanceProvider.todayAttendance.where((a) => a.status == 'Present').length;
    final selectedDate = attendanceProvider.selectedDate;
    final isToday = DateFormat('yyyy-MM-dd').format(selectedDate) == DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: AppTheme.radiusMedium,
            ),
            child: IconButton(
              icon: const Icon(Icons.calendar_month_rounded, size: 22),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: attendanceProvider.selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: AppTheme.warmTheme.copyWith(
                        colorScheme: AppTheme.warmTheme.colorScheme.copyWith(
                          primary: AppTheme.maroon,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: AppTheme.textPrimary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  attendanceProvider.setDate(date);
                }
              },
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
                // Date & Stats Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.warmPink.withOpacity(0.12),
                                borderRadius: AppTheme.radiusMedium,
                              ),
                              child: Icon(
                                Icons.fact_check_rounded,
                                color: AppTheme.warmPink,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('EEEE').format(selectedDate),
                                        style: AppTheme.titleSmall,
                                      ),
                                      if (isToday) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.successGreen.withOpacity(0.15),
                                            borderRadius: AppTheme.radiusSmall,
                                          ),
                                          child: Text(
                                            'Today',
                                            style: AppTheme.caption.copyWith(
                                              color: AppTheme.successGreen,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat('MMMM d, yyyy').format(selectedDate),
                                    style: AppTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.beige.withOpacity(0.5),
                            borderRadius: AppTheme.radiusMedium,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.groups_rounded,
                                'Total',
                                '${activeMembers.length}',
                                AppTheme.textSecondary,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppTheme.textMuted.withOpacity(0.2),
                              ),
                              _buildStatItem(
                                Icons.check_circle_rounded,
                                'Present',
                                '$presentCount',
                                AppTheme.statusActive,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppTheme.textMuted.withOpacity(0.2),
                              ),
                              _buildStatItem(
                                Icons.cancel_rounded,
                                'Absent',
                                '${activeMembers.length - presentCount}',
                                AppTheme.statusInactive,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Member list header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'Mark Attendance',
                        style: AppTheme.titleSmallLight,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Member list
                Expanded(
                  child: activeMembers.isEmpty
                      ? EmptyState(
                          icon: Icons.groups_rounded,
                          title: 'No active members',
                          subtitle: 'Add active members to mark attendance',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: activeMembers.length,
                          itemBuilder: (context, index) {
                            final member = activeMembers[index];
                            final attendance = attendanceProvider.todayAttendance.firstWhere(
                              (a) => a.memberId == member.id,
                              orElse: () => AttendanceModel(
                                id: '',
                                memberId: member.id,
                                memberName: member.name,
                                date: attendanceProvider.selectedDate,
                                status: 'Absent',
                              ),
                            );

                            final isPresent = attendance.status == 'Present';
                            final isMarked = attendance.id.isNotEmpty;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GlassCard(
                                onTap: () {
                                  if (!isMarked && !isPresent) {
                                    attendanceProvider.markAttendance(AttendanceModel(
                                      id: '',
                                      memberId: member.id,
                                      memberName: member.name,
                                      date: attendanceProvider.selectedDate,
                                      status: 'Present',
                                      checkInTime: DateTime.now(),
                                    ));
                                  } else if (isMarked) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                                            const SizedBox(width: 10),
                                            Text('Attendance already marked for ${member.name}'),
                                          ],
                                        ),
                                        backgroundColor: AppTheme.warmPink,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                                      ),
                                    );
                                  }
                                },
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isPresent 
                                              ? AppTheme.statusActive.withOpacity(0.5)
                                              : AppTheme.textMuted.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: AppTheme.peach.withOpacity(0.3),
                                        backgroundImage: member.profileImage != null
                                            ? NetworkImage(member.profileImage!)
                                            : null,
                                        child: member.profileImage == null
                                            ? Text(
                                                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                                                style: AppTheme.titleSmall.copyWith(
                                                  color: AppTheme.maroon,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    
                                    // Name
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
                                          if (isPresent && attendance.checkInTime != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              'Checked in at ${DateFormat('hh:mm a').format(attendance.checkInTime!)}',
                                              style: AppTheme.caption.copyWith(color: AppTheme.statusActive),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    
                                    // Status indicator
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isPresent 
                                            ? AppTheme.statusActive.withOpacity(0.15)
                                            : AppTheme.textMuted.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isPresent ? Icons.check_rounded : Icons.circle_outlined,
                                        color: isPresent ? AppTheme.statusActive : AppTheme.textMuted,
                                        size: 20,
                                      ),
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
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTheme.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption,
        ),
      ],
    );
  }
}
