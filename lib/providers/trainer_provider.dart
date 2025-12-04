import 'dart:async';
import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import '../services/trainer_service.dart';

class TrainerProvider with ChangeNotifier {
  final TrainerService _service = TrainerService();
  List<TrainerModel> _trainers = [];
  bool _isLoading = false;

  List<TrainerModel> get trainers => _trainers;
  bool get isLoading => _isLoading;

  TrainerProvider() {
    // Don't listen immediately
  }

  StreamSubscription<List<TrainerModel>>? _subscription;

  void startListening() {
    if (_subscription != null) return;
    
    _subscription = _service.getTrainers().listen((trainers) {
      _trainers = trainers;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to trainers: $error");
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  Future<void> addTrainer(TrainerModel trainer) async {
    try {
      _setLoading(true);
      await _service.addTrainer(trainer);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTrainer(TrainerModel trainer) async {
    try {
      _setLoading(true);
      await _service.updateTrainer(trainer);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTrainer(String id) async {
    try {
      _setLoading(true);
      await _service.deleteTrainer(id);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
