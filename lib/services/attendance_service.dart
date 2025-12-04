import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference _getAttendanceCollection() {
    if (_userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('owners').doc(_userId).collection('attendance');
  }

  Stream<List<AttendanceModel>> getAttendanceForDate(DateTime date) {
    try {
      // Basic date filtering (start of day to end of day)
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

      return _getAttendanceCollection()
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      // Return empty stream if user not logged in
      return Stream.value([]);
    }
  }

  Future<void> markAttendance(AttendanceModel attendance) async {
    // Check if already marked for this member today?
    // For now, just add.
    await _getAttendanceCollection().add(attendance.toMap());
  }
  
  Stream<List<AttendanceModel>> getAttendanceHistory(String memberId) {
    try {
      return _getAttendanceCollection()
          .where('memberId', isEqualTo: memberId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return AttendanceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      // Return empty stream if user not logged in
      return Stream.value([]);
    }
  }
}
