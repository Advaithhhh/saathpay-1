import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  // TODO: Replace with your actual Cloudinary credentials
  final String cloudName = 'dhgfdjfb8';
  final String uploadPreset = 'saathpay';

  Future<String?> uploadImage(File imageFile) async {
    try {
      // Verify file exists
      if (!await imageFile.exists()) {
        debugPrint('Cloudinary Error: File does not exist at path: ${imageFile.path}');
        return null;
      }

      debugPrint('Cloudinary: Starting upload for file: ${imageFile.path}');
      debugPrint('Cloudinary: File size: ${await imageFile.length()} bytes');

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      debugPrint('Cloudinary: Sending request to: $url');
      
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      
      debugPrint('Cloudinary: Response status: ${response.statusCode}');
      debugPrint('Cloudinary: Response body: $responseString');

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(responseString);
        final secureUrl = jsonMap['secure_url'] as String?;
        debugPrint('Cloudinary: Upload successful! URL: $secureUrl');
        return secureUrl;
      } else {
        debugPrint('Cloudinary Upload Failed: ${response.statusCode} - $responseString');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('Error uploading to Cloudinary: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }
}
