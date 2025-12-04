import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final CollectionReference _attendanceCollection =
      FirebaseFirestore.instance.collection('attendance');

  Stream<List<AttendanceModel>> getAttendanceForDate(DateTime date) {
    // Basic date filtering (start of day to end of day)
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _attendanceCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> markAttendance(AttendanceModel attendance) async {
    // Check if already marked for this member today?
    // For now, just add.
    await _attendanceCollection.add(attendance.toMap());
  }
  
  Stream<List<AttendanceModel>> getAttendanceHistory(String memberId) {
    return _attendanceCollection
        .where('memberId', isEqualTo: memberId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
