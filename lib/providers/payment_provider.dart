import 'dart:async';
import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _service = PaymentService();
  List<PaymentModel> _payments = [];
  bool _isLoading = false;

  List<PaymentModel> get payments => _payments;
  bool get isLoading => _isLoading;

  PaymentProvider() {
    // Don't listen immediately
  }

  StreamSubscription<List<PaymentModel>>? _subscription;

  void startListening() {
    if (_subscription != null) return;
    
    _subscription = _service.getPayments().listen((payments) {
      _payments = payments;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to payments: $error");
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void reset() {
    stopListening();
    _payments = [];
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  Future<void> addPayment(PaymentModel payment) async {
    try {
      _setLoading(true);
      await _service.addPayment(payment);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePayment(PaymentModel payment) async {
    try {
      _setLoading(true);
      await _service.updatePayment(payment);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePayment(String id) async {
    try {
      _setLoading(true);
      await _service.deletePayment(id);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
