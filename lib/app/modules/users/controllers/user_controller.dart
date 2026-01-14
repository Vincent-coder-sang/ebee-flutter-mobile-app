// app/modules/user/controllers/user_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user_model.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;
  var selectedUser = Rxn<UserModel>();

  // Get all users (admin only)
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final userList = await _userRepository.getUsers();
      users.assignAll(userList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      isLoading.value = true;
      final updatedUser = await _userRepository.updateUser(userId, updates);

      // Update in local list
      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users[index] = updatedUser;
      }

      Get.snackbar('Success', 'User updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Approve user
  Future<void> approveUser(String userId) async {
    try {
      isLoading.value = true;
      final approvedUser = await _userRepository.approveUser(userId);

      // Update in local list
      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users[index] = approvedUser;
      }

      Get.snackbar('Success', 'User approved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      await _userRepository.deleteUser(userId);

      // Remove from local list
      users.removeWhere((user) => user.id == userId);

      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
