import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String memberId;
  final String memberName; // Denormalized for easier display
  final double amount;
  final DateTime date;
  final String type; // Cash, Online
  final String status; // Paid, Due
  final String? planId;

  PaymentModel({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.planId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'memberName': memberName,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'type': type,
      'status': status,
      'planId': planId,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentModel(
      id: id,
      memberId: map['memberId'] ?? '',
      memberName: map['memberName'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      type: map['type'] ?? 'Cash',
      status: map['status'] ?? 'Paid',
      planId: map['planId'],
    );
  }
}
