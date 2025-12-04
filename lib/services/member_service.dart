import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/member_model.dart';

class MemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference _getMembersCollection() {
    if (_userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('owners').doc(_userId).collection('members');
  }

  Stream<List<MemberModel>> getMembers() {
    try {
      return _getMembersCollection().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return MemberModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      // Return empty stream if user not logged in
      return Stream.value([]);
    }
  }

  Future<void> addMember(MemberModel member) async {
    await _getMembersCollection().add(member.toMap());
  }

  Future<void> updateMember(MemberModel member) async {
    await _getMembersCollection().doc(member.id).update(member.toMap());
  }

  Future<void> deleteMember(String id) async {
    await _getMembersCollection().doc(id).delete();
  }
}
