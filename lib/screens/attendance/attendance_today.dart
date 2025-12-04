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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: attendanceProvider.selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: AppTheme.warmTheme, // Ensure date picker matches theme
                    child: child!,
                  );
                },
              );
              if (date != null) {
                attendanceProvider.setDate(date);
              }
            },
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date:',
                            style: AppTheme.bodyLarge,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(attendanceProvider.selectedDate),
                            style: AppTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: activeMembers.length,
                    itemBuilder: (context, index) {
                      final member = activeMembers[index];
                      // Check if attendance exists for this member on selected date
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

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          child: CheckboxListTile(
                            title: Text(member.name, style: const TextStyle(color: AppTheme.textPrimary)),
                            value: isPresent,
                            activeColor: AppTheme.maroon,
                            checkColor: Colors.white,
                            side: const BorderSide(color: AppTheme.textSecondary),
                            onChanged: (val) {
                              if (attendance.id.isEmpty && val == true) {
                                attendanceProvider.markAttendance(AttendanceModel(
                                  id: '',
                                  memberId: member.id,
                                  memberName: member.name,
                                  date: attendanceProvider.selectedDate,
                                  status: 'Present',
                                  checkInTime: DateTime.now(),
                                ));
                              } else if (attendance.id.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Attendance already marked.')),
                                );
                              }
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
      ),
    );
  }
}
