// app/data/repositories/user_repository.dart
import 'package:ebee/app/data/providers/local_storage.dart';
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/user_model.dart';
import '../../utils/constants.dart' show ApiEndpoints;

class UserRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  String _getCurrentUserId() {
    final userId = LocalStorage.getUserId();

    if (userId != null && userId.isNotEmpty) {
      return userId;
    }

    throw Exception('User ID not available. Please login again.');
  }

  void debugUserInfo() {
    LocalStorage.debugStorage(); // Use the storage debug method

    try {
      final userId = _getCurrentUserId();
    } catch (e) {
      print('❌ User ID error: $e');
    }
  }

  // Get all users (admin only)
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getUsers);

      final users = (response['users'] as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList();

      return users;
    } catch (e) {
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      print('🗑️ Deleting user: $userId');
      await _apiProvider.delete(ApiEndpoints.deleteUser(userId));
      print('✅ User deleted: $userId');
    } catch (e) {
      print('❌ Error deleting user $userId: $e');
      rethrow;
    }
  }

  // Approve single user
  Future<UserModel> approveUser(String userId) async {
    try {
      print('✅ Approving user: $userId');
      final response = await _apiProvider.put(
        ApiEndpoints.approveUser(userId),
        {},
      );
      final user = UserModel.fromJson(response['user'] ?? response);
      print('✅ User approved: ${user.name}');
      return user;
    } catch (e) {
      print('❌ Error approving user $userId: $e');
      rethrow;
    }
  }

  // Approve multiple users
  Future<void> approveUsers(List<String> userIds) async {
    try {
      print('✅ Approving users: $userIds');
      await _apiProvider.put(ApiEndpoints.approveUsers, {'userIds': userIds});
      print('✅ Users approved: ${userIds.length} users');
    } catch (e) {
      print('❌ Error approving users: $e');
      rethrow;
    }
  }

  // In UserRepository
  Future<UserModel> getProfile(String userId) async {
    try {
      print('👤 Getting profile for user: $userId');

      // First try to get from local storage
      final userData = LocalStorage.getUserData();

      if (userData != null && userData['id'] == userId) {
        print('✅ User data found in local storage');
        return UserModel.fromJson(userData);
      } else {
        print('🔄 User data not in local storage, fetching from API...');
        // Fall back to API call
        return await getUserById(userId);
      }
    } catch (e) {
      print('❌ Error in getProfile: $e');
      // Final fallback - get from API
      return await getUserById(userId);
    }
  }

  // Update profile - this will update both local storage and make API call if needed
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      print('📝 Updating profile for user: $userId');

      // Get current user data
      final currentUserData = LocalStorage.getUserData();
      if (currentUserData == null) {
        throw Exception('No user data found to update');
      }

      // Create updated data
      final updatedData = Map<String, dynamic>.from(currentUserData);
      if (name != null) updatedData['name'] = name;
      if (email != null) updatedData['email'] = email;
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;

      // Save to local storage
      await LocalStorage.saveUserData(updatedData);

      // If you have an API endpoint for updating profile, call it here:
      // final response = await _apiProvider.put(
      //   ApiEndpoints.updateProfile(userId),
      //   updatedData,
      // );

      print('✅ Profile updated in local storage');
      return UserModel.fromJson(updatedData);
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      // Remove this line: it's shadowing the parameter
      // final userId = _getCurrentUserId();

      print('👤 Fetching user: $userId');
      final response = await _apiProvider.get(ApiEndpoints.getUserById(userId));
      final user = UserModel.fromJson(response['user'] ?? response);
      print('✅ User fetched: ${user.name}');
      return user;
    } catch (e) {
      print('❌ Error fetching user $userId: $e');
      rethrow;
    }
  }

  // Also fix updateUser method
  Future<UserModel> updateUser(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      // Remove this line too
      // final userId = _getCurrentUserId();

      print('📝 Updating user: $userId');
      final response = await _apiProvider.put(
        ApiEndpoints.updateUser(userId),
        updates,
      );
      final user = UserModel.fromJson(response['user'] ?? response);
      print('✅ User updated: ${user.name}');
      return user;
    } catch (e) {
      print('❌ Error updating user $userId: $e');
      rethrow;
    }
  }

  // Change user password
  Future<void> changePassword(
    String userId,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      print('🔑 Changing password for user: $userId');
      await _apiProvider.put(ApiEndpoints.changePassword(userId), {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });
      print('✅ Password changed for user: $userId');
    } catch (e) {
      print('❌ Error changing password: $e');
      rethrow;
    }
  }
}
