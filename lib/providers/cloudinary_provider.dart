import 'dart:io';
import 'package:flutter/material.dart';
import '../services/cloudinary_service.dart';

class CloudinaryProvider with ChangeNotifier {
  final CloudinaryService _cloudinaryService = CloudinaryService();
  bool _isUploading = false;

  bool get isUploading => _isUploading;

  Future<String?> uploadImage(File imageFile) async {
    try {
      _setUploading(true);
      return await _cloudinaryService.uploadImage(imageFile);
    } finally {
      _setUploading(false);
    }
  }

  void _setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }
}
