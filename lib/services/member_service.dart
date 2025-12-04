import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member_model.dart';

class MemberService {
  final CollectionReference _membersCollection =
      FirebaseFirestore.instance.collection('members');

  Stream<List<MemberModel>> getMembers() {
    return _membersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MemberModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addMember(MemberModel member) async {
    await _membersCollection.add(member.toMap());
  }

  Future<void> updateMember(MemberModel member) async {
    await _membersCollection.doc(member.id).update(member.toMap());
  }

  Future<void> deleteMember(String id) async {
    await _membersCollection.doc(id).delete();
  }
}
