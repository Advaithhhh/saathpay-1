import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  List<AttendanceModel> _todayAttendance = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  List<AttendanceModel> get todayAttendance => _todayAttendance;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;

  AttendanceProvider() {
    _init();
  }

  void _init() {
    _fetchAttendanceForDate(_selectedDate);
  }
  
  void setDate(DateTime date) {
    _selectedDate = date;
    _fetchAttendanceForDate(date);
    notifyListeners();
  }

  void _fetchAttendanceForDate(DateTime date) {
    _service.getAttendanceForDate(date).listen((attendance) {
      _todayAttendance = attendance;
      notifyListeners();
    });
  }

  Future<void> markAttendance(AttendanceModel attendance) async {
    try {
      _setLoading(true);
      await _service.markAttendance(attendance);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
