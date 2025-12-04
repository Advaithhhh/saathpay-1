import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plan_model.dart';

class PlanService {
  final CollectionReference _plansCollection =
      FirebaseFirestore.instance.collection('plans');

  Stream<List<PlanModel>> getPlans() {
    return _plansCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addPlan(PlanModel plan) async {
    await _plansCollection.add(plan.toMap());
  }

  Future<void> updatePlan(PlanModel plan) async {
    await _plansCollection.doc(plan.id).update(plan.toMap());
  }

  Future<void> deletePlan(String id) async {
    await _plansCollection.doc(id).delete();
  }
}
