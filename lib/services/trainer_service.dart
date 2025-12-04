import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/trainer_model.dart';

class TrainerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference _getTrainersCollection() {
    if (_userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('owners').doc(_userId).collection('trainers');
  }

  Stream<List<TrainerModel>> getTrainers() {
    try {
      return _getTrainersCollection().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return TrainerModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      // Return empty stream if user not logged in
      return Stream.value([]);
    }
  }

  Future<void> addTrainer(TrainerModel trainer) async {
    await _getTrainersCollection().add(trainer.toMap());
  }

  Future<void> updateTrainer(TrainerModel trainer) async {
    await _getTrainersCollection().doc(trainer.id).update(trainer.toMap());
  }

  Future<void> deleteTrainer(String id) async {
    await _getTrainersCollection().doc(id).delete();
  }
}
