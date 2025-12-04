import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerModel {
  final String id;
  final String name;
  final String contact;
  final String email;
  final String? photoUrl;
  final List<String> assignedMembers; // List of Member IDs

  TrainerModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    this.photoUrl,
    this.assignedMembers = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'photoUrl': photoUrl,
      'assignedMembers': assignedMembers,
    };
  }

  factory TrainerModel.fromMap(Map<String, dynamic> map, String id) {
    return TrainerModel(
      id: id,
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      assignedMembers: List<String>.from(map['assignedMembers'] ?? []),
    );
  }
}
