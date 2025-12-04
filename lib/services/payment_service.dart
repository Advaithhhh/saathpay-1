import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/payment_model.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference _getPaymentsCollection() {
    if (_userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('owners').doc(_userId).collection('payments');
  }

  Stream<List<PaymentModel>> getPayments() {
    try {
      return _getPaymentsCollection().orderBy('date', descending: true).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return PaymentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      // Return empty stream if user not logged in
      return Stream.value([]);
    }
  }

  Future<void> addPayment(PaymentModel payment) async {
    await _getPaymentsCollection().add(payment.toMap());
  }

  Future<void> updatePayment(PaymentModel payment) async {
    await _getPaymentsCollection().doc(payment.id).update(payment.toMap());
  }

  Future<void> deletePayment(String id) async {
    await _getPaymentsCollection().doc(id).delete();
  }
}
