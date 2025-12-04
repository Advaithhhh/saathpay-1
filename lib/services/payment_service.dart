import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class PaymentService {
  final CollectionReference _paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

  Stream<List<PaymentModel>> getPayments() {
    return _paymentsCollection.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PaymentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addPayment(PaymentModel payment) async {
    await _paymentsCollection.add(payment.toMap());
  }

  Future<void> updatePayment(PaymentModel payment) async {
    await _paymentsCollection.doc(payment.id).update(payment.toMap());
  }

  Future<void> deletePayment(String id) async {
    await _paymentsCollection.doc(id).delete();
  }
}
