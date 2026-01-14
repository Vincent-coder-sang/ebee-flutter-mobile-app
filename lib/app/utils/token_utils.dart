// utils/token_utils.dart
import 'dart:convert';

class TokenUtils {
  static Map<String, dynamic>? extractUserDataFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      var paddedPayload = payload;
      while (paddedPayload.length % 4 != 0) {
        paddedPayload += '=';
      }

      final decoded = utf8.decode(base64Url.decode(paddedPayload));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      return {
        'id': payloadMap['userId'] ?? payloadMap['sub'],
        'name': payloadMap['name'],
        'email': payloadMap['email'],
        'phoneNumber': payloadMap['phoneNumber'],
      };
    } catch (e) {
      print('Error extracting user data from token: $e');
      return null;
    }
  }
}
