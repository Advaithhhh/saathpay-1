import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trainer_model.dart';

class TrainerService {
  final CollectionReference _trainersCollection =
      FirebaseFirestore.instance.collection('trainers');

  Stream<List<TrainerModel>> getTrainers() {
    return _trainersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TrainerModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addTrainer(TrainerModel trainer) async {
    await _trainersCollection.add(trainer.toMap());
  }

  Future<void> updateTrainer(TrainerModel trainer) async {
    await _trainersCollection.doc(trainer.id).update(trainer.toMap());
  }

  Future<void> deleteTrainer(String id) async {
    await _trainersCollection.doc(id).delete();
  }
}
