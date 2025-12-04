import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String memberId;
  final String memberName; // Denormalized
  final DateTime date;
  final String status; // Present, Absent
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  AttendanceModel({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'memberName': memberName,
      'date': Timestamp.fromDate(date),
      'status': status,
      'checkInTime': checkInTime != null ? Timestamp.fromDate(checkInTime!) : null,
      'checkOutTime': checkOutTime != null ? Timestamp.fromDate(checkOutTime!) : null,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceModel(
      id: id,
      memberId: map['memberId'] ?? '',
      memberName: map['memberName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? 'Present',
      checkInTime: (map['checkInTime'] as Timestamp?)?.toDate(),
      checkOutTime: (map['checkOutTime'] as Timestamp?)?.toDate(),
    );
  }
}
