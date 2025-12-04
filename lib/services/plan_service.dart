import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plan_model.dart';

class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference _getPlansCollection() {
    if (_userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('owners').doc(_userId).collection('plans');
  }

  Stream<List<PlanModel>> getPlans() {
    try {
      return _getPlansCollection().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return PlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      // Return empty stream if user not logged in
      return Stream.value([]);
    }
  }

  Future<void> addPlan(PlanModel plan) async {
    await _getPlansCollection().add(plan.toMap());
  }

  Future<void> updatePlan(PlanModel plan) async {
    await _getPlansCollection().doc(plan.id).update(plan.toMap());
  }

  Future<void> deletePlan(String id) async {
    await _getPlansCollection().doc(id).delete();
  }
}
