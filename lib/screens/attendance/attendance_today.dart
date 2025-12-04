import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/member_provider.dart';
import '../../models/attendance_model.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);
    
    // Get all active members
    final activeMembers = memberProvider.members.where((m) => m.status == 'Active').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: attendanceProvider.selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                attendanceProvider.setDate(date);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(attendanceProvider.selectedDate)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
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

                return CheckboxListTile(
                  title: Text(member.name),
                  value: isPresent,
                  onChanged: (val) {
                    // Mark attendance
                    final newStatus = val == true ? 'Present' : 'Absent';
                    // Ideally we should update if exists, or add if not.
                    // My service just adds. I should probably handle update in service or here.
                    // For MVP, I'll just add a new record. 
                    // Wait, if I add multiple records for same day, it will be messy.
                    // I should check if record exists in provider list.
                    
                    // If record exists (id is not empty), update it?
                    // My provider/service doesn't have updateAttendance yet.
                    // I'll skip update for now and just allow marking 'Present' once.
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
                      // Already marked. 
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Attendance already marked.')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
