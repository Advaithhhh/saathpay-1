import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String contact;
  final String email;
  final DateTime membershipStart;
  final DateTime membershipEnd;
  final String membershipType; // Plan Name or ID
  final String status; // Active, Expired, Pending
  final String? assignedTrainerId;
  final String? notes;
  final List<String> progressImages;
  final String? profileImage;

  MemberModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.contact,
    required this.email,
    required this.membershipStart,
    required this.membershipEnd,
    required this.membershipType,
    required this.status,
    this.assignedTrainerId,
    this.notes,
    this.progressImages = const [],
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'contact': contact,
      'email': email,
      'membershipStart': Timestamp.fromDate(membershipStart),
      'membershipEnd': Timestamp.fromDate(membershipEnd),
      'membershipType': membershipType,
      'status': status,
      'assignedTrainerId': assignedTrainerId,
      'notes': notes,
      'progressImages': progressImages,
      'profileImage': profileImage,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map, String id) {
    return MemberModel(
      id: id,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      membershipStart: (map['membershipStart'] as Timestamp).toDate(),
      membershipEnd: (map['membershipEnd'] as Timestamp).toDate(),
      membershipType: map['membershipType'] ?? '',
      status: map['status'] ?? 'Pending',
      assignedTrainerId: map['assignedTrainerId'],
      notes: map['notes'],
      progressImages: List<String>.from(map['progressImages'] ?? []),
      profileImage: map['profileImage'],
    );
  }
}
