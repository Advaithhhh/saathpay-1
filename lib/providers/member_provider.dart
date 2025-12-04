import 'package:flutter/material.dart';
import '../models/member_model.dart';
import '../services/member_service.dart';

class MemberProvider with ChangeNotifier {
  final MemberService _service = MemberService();
  List<MemberModel> _members = [];
  bool _isLoading = false;

  List<MemberModel> get members => _members;
  bool get isLoading => _isLoading;

  MemberProvider() {
    _init();
  }

  void _init() {
    _service.getMembers().listen((members) {
      _members = members;
      notifyListeners();
    });
  }

  Future<void> addMember(MemberModel member) async {
    try {
      _setLoading(true);
      await _service.addMember(member);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateMember(MemberModel member) async {
    try {
      _setLoading(true);
      await _service.updateMember(member);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteMember(String id) async {
    try {
      _setLoading(true);
      await _service.deleteMember(id);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
