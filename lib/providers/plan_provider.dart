import 'dart:async';
import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../services/plan_service.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _service = PlanService();
  List<PlanModel> _plans = [];
  bool _isLoading = false;

  List<PlanModel> get plans => _plans;
  bool get isLoading => _isLoading;

  PlanProvider() {
    // Don't listen immediately to avoid permission errors before login
  }

  StreamSubscription<List<PlanModel>>? _subscription;

  void startListening() {
    if (_subscription != null) return; // Already listening
    
    _subscription = _service.getPlans().listen((plans) {
      _plans = plans;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to plans: $error");
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

  Future<void> addPlan(PlanModel plan) async {
    try {
      _setLoading(true);
      await _service.addPlan(plan);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePlan(PlanModel plan) async {
    try {
      _setLoading(true);
      await _service.updatePlan(plan);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePlan(String id) async {
    try {
      _setLoading(true);
      await _service.deletePlan(id);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
