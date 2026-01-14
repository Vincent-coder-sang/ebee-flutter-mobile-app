// app/data/providers/local_storage.dart
import 'dart:convert';
import 'package:ebee/app/utils/constants.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // Token management
  static Future<void> saveToken(String token) async {
    await _box.write(AppConstants.tokenKey, token);

    // AUTO-EXTRACT: Extract user data from JWT and save it
    final userData = _extractUserDataFromToken(token);
    if (userData != null) {
      await _box.write(AppConstants.userKey, userData);
    }
  }

  static String? getToken() {
    return _box.read<String>(AppConstants.tokenKey);
  }

  static Future<void> removeToken() async {
    await _box.remove(AppConstants.tokenKey);
  }

  // User data management
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(AppConstants.userKey, userData);
  }

  static Map<String, dynamic>? getUserData() {
    return _box.read<Map<String, dynamic>>(AppConstants.userKey);
  }

  static Future<void> removeUserData() async {
    await _box.remove(AppConstants.userKey);
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    await removeToken();
    await removeUserData();
  }

  // Clear ALL data from storage (complete logout)
  static Future<void> eraseEverything() async {
    await _box.erase();
    print('🧹 ALL data erased from GetStorage');
  }

  // Check if user is logged in
  static bool get isLoggedIn {
    final token = getToken();
    final userData = getUserData();
    return token != null && token.isNotEmpty && userData != null;
  }

  // Get user ID from stored data
  static String? getUserId() {
    final userData = getUserData();
    print("userData in getUserId: $userData");
    if (userData != null && userData.containsKey('id')) {
      final userId = userData['id'].toString();
      return userId;
    }

    // If no user data, try to extract from token
    final token = getToken();
    if (token != null) {
      final userDataFromToken = _extractUserDataFromToken(token);
      if (userDataFromToken != null && userDataFromToken.containsKey('id')) {
        final userId = userDataFromToken['id'].toString();
        // Save it for future use
        saveUserData(userDataFromToken);
        print("userId in getUserId extractUserDataFromToken: $userId");
        return userId;
      }
    }

    return null;
  }

  // Extract complete user data from JWT token
  static Map<String, dynamic>? _extractUserDataFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      var decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      // Create user data from JWT payload
      final userData = {
        'id': payloadMap['id']?.toString(),
        'userType': payloadMap['userType'],
        'email': payloadMap['email'],
        'name': payloadMap['name'],
        'phoneNumber': payloadMap['phoneNumber'],
        'isApproved': payloadMap['isApproved'],
      };

      // Remove null values
      userData.removeWhere((key, value) => value == null);

      if (userData.containsKey('id')) {
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Debug method to check stored data
  static void debugStorage() {
    final token = getToken();
    final userData = getUserData();

    print("\n🔍 LOCAL STORAGE DEBUG:");
    print(
      "   - Token: ${token != null ? 'exists (${token.length} chars)' : 'null'}",
    );
    print("   - User Data: $userData");
    print("   - User ID: ${getUserId()}");

    // Show all keys in storage
    final allKeys = _box.getKeys();
    print("   - All storage keys: $allKeys");
    print("---\n");
  }
}
