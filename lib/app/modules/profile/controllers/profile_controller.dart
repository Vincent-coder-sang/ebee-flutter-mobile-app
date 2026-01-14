// app/modules/profile/controllers/profile_controller.dart
import 'dart:convert';
import 'package:ebee/app/data/models/address_model.dart';
import 'package:ebee/app/data/models/order_model.dart';
import 'package:ebee/app/data/models/rental_model.dart';
import 'package:ebee/app/data/models/user_model.dart';
import 'package:ebee/app/data/providers/local_storage.dart';
import 'package:ebee/app/data/repositories/user_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';
// REMOVE THIS: import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final OrderRepository _orderRepository = Get.find<OrderRepository>();
  final AddressRepository _addressRepository = Get.find<AddressRepository>();

  // Observables
  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var orders = <Order>[].obs;
  var rentals = <Rental>[].obs;
  var addresses = <UserAddress>[].obs;
  var selectedTab = 0.obs;
  var isRefreshing = false.obs;
  var isProfileLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      // Get user ID first
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        print('❌ No user ID found in storage');
        Get.snackbar('Error', 'Please login again');
        return;
      }

      print('✅ User ID found: $userId');
      await getProfile();

      // Load orders and addresses in parallel
      await Future.wait([getMyOrders(), getAddresses()]);

      print('✅ All profile data loaded successfully');
    } catch (e) {
      print('❌ Error loading user data: $e');
      Get.snackbar('Error', 'Failed to load profile data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      await Future.wait([getProfile(), getMyOrders(), getAddresses()]);
    } catch (e) {
      print('Refresh error: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> getProfile() async {
    try {
      isProfileLoading.value = true;
      print('🔄 ProfileController.getProfile() called');

      // Use LocalStorage instead of SharedPreferences
      final userId = LocalStorage.getUserId();

      if (userId == null) {
        print('❌ No user ID found in LocalStorage');
        throw Exception('User ID not found. Please login again.');
      }

      print('✅ User ID from LocalStorage: $userId');

      // Get profile from local storage
      final userData = await _userRepository.getProfile(userId);
      user.value = userData;

      print('✅ Profile loaded successfully: ${userData.name}');
    } catch (e) {
      print('❌ ProfileController.getProfile() error: $e');
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isProfileLoading.value = false;
    }
  }

  // Also update updateProfile method
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? email,
  }) async {
    print('🔄 ProfileController.updateProfile() called');
    print('   - Name: $name, Phone: $phoneNumber, Email: $email');
    try {
      isLoading.value = true;

      // Use LocalStorage instead of SharedPreferences
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        print('❌ No user ID found for update');
        Get.snackbar('Error', 'User ID not found');
        return;
      }

      final updatedUser = await _userRepository.updateProfile(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
      );

      user.value = updatedUser;
      print('✅ Profile updated successfully: ${updatedUser.name}');
      Get.snackbar('Success', 'Profile updated successfully');
      Get.back();
    } catch (e) {
      print('❌ ProfileController.updateProfile() error: $e');
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update changePassword method as well
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    print('🔄 ProfileController.changePassword() called');
    try {
      isLoading.value = true;

      // Use LocalStorage instead of SharedPreferences
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        print('❌ No user ID found for password change');
        Get.snackbar('Error', 'User ID not found');
        return;
      }

      await _userRepository.changePassword(
        userId,
        currentPassword,
        newPassword,
        confirmPassword,
      );

      print('✅ Password changed successfully');
      Get.snackbar('Success', 'Password changed successfully');
      Get.back();
    } catch (e) {
      print('❌ ProfileController.changePassword() error: $e');
      Get.snackbar('Error', 'Failed to change password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMyOrders() async {
    print('🔄 ProfileController.getMyOrders() called');
    try {
      final myOrders = await _orderRepository.getMyOrders();
      orders.assignAll(myOrders);
      print('✅ Orders loaded: ${myOrders.length} orders');
      print('   - Order status breakdown:');
      print('     - Pending: ${pendingOrders}');
      print('     - Processing: ${processingOrders}');
      print('     - Delivered: ${deliveredOrders}');
      print('     - Cancelled: ${cancelledOrders}');
    } catch (e) {
      print('❌ ProfileController.getMyOrders() error: $e');
    }
  }

  // 🔹 Addresses
  Future<void> getAddresses() async {
    print('🔄 ProfileController.getAddresses() called');
    try {
      final addressList = await _addressRepository.getAddresses();
      addresses.assignAll(addressList);
      print('✅ Addresses loaded: ${addressList.length} addresses');
    } catch (e) {
      print('❌ ProfileController.getAddresses() error: $e');
    }
  }

  // 🔹 FIXED: Add Address - Accept Map instead of UserAddress
  Future<void> addAddress({
    required String county,
    required String phoneNumber,
    required String postalCode,
    required String street,
    required String subCounty,
    required String ward,
  }) async {
    print('🔄 ProfileController.addAddress() called');
    print('   - Address: $street, $ward, $county');
    try {
      isLoading.value = true;

      // Create address data as Map
      final addressData = {
        'county': county,
        'phoneNumber': phoneNumber,
        'postalCode': postalCode,
        'street': street,
        'subCounty': subCounty,
        'ward': ward,
      };

      final newAddress = await _addressRepository.createAddress(addressData);
      addresses.add(newAddress);
      print('✅ Address added successfully: ${newAddress.id}');
      Get.snackbar('Success', 'Address added successfully');
      Get.back();
    } catch (e) {
      print('❌ ProfileController.addAddress() error: $e');
      Get.snackbar('Error', 'Failed to add address: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 FIXED: Update Address - Accept addressId and Map
  Future<void> updateAddress({
    required String addressId,
    required String county,
    required String phoneNumber,
    required String postalCode,
    required String street,
    required String subCounty,
    required String ward,
  }) async {
    print('🔄 ProfileController.updateAddress() called for: $addressId');
    try {
      isLoading.value = true;

      // Create update data as Map
      final updateData = {
        'county': county,
        'phoneNumber': phoneNumber,
        'postalCode': postalCode,
        'street': street,
        'subCounty': subCounty,
        'ward': ward,
      };

      final updatedAddress = await _addressRepository.updateAddress(
        addressId,
        updateData,
      );

      final index = addresses.indexWhere((a) => a.id == addressId);
      if (index != -1) {
        addresses[index] = updatedAddress;
        print('✅ Address updated successfully: $addressId');
      } else {
        print('⚠️  Address not found in local list: $addressId');
      }
      Get.snackbar('Success', 'Address updated successfully');
      Get.back();
    } catch (e) {
      print('❌ ProfileController.updateAddress() error: $e');
      Get.snackbar('Error', 'Failed to update address: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Delete Address
  Future<void> deleteAddress(String addressId) async {
    print('🔄 ProfileController.deleteAddress() called for: $addressId');
    try {
      await _addressRepository.deleteAddress(addressId);
      addresses.removeWhere((a) => a.id == addressId);
      print('✅ Address deleted successfully: $addressId');
      Get.snackbar('Success', 'Address deleted successfully');
    } catch (e) {
      print('❌ ProfileController.deleteAddress() error: $e');
      Get.snackbar('Error', 'Failed to delete address: $e');
    }
  }

  // 🔹 FIXED: Save locally using LocalStorage instead of SharedPreferences
  Future<void> _saveUser(UserModel user) async {
    print('🔄 ProfileController._saveUser() called for: ${user.name}');
    try {
      // Use LocalStorage instead of SharedPreferences
      await LocalStorage.saveUserData(user.toJson());
      print('✅ User saved to local storage using LocalStorage');
    } catch (e) {
      print('❌ Error saving user to local storage: $e');
    }
  }

  // 🔹 Helper methods
  void changeTab(int index) {
    print('🔄 ProfileController.changeTab() called: $index');
    selectedTab.value = index;
  }

  // 🔹 Computed statistics
  int get totalOrders {
    final count = orders.length;
    print('📊 totalOrders getter called: $count');
    return count;
  }

  int get totalRentals => rentals.length;

  int get totalAddresses {
    final count = addresses.length;
    print('📊 totalAddresses getter called: $count');
    return count;
  }

  // FIXED: Use OrderStatus enum values
  int get pendingOrders {
    final count = orders
        .where((o) => o.orderStatus == OrderStatus.pending)
        .length;
    print('📊 pendingOrders getter called: $count');
    return count;
  }

  int get processingOrders {
    final count = orders
        .where((o) => o.orderStatus == OrderStatus.processing)
        .length;
    print('📊 processingOrders getter called: $count');
    return count;
  }

  int get deliveredOrders {
    final count = orders
        .where((o) => o.orderStatus == OrderStatus.delivered)
        .length;
    print('📊 deliveredOrders getter called: $count');
    return count;
  }

  int get cancelledOrders {
    final count = orders
        .where((o) => o.orderStatus == OrderStatus.cancelled)
        .length;
    print('📊 cancelledOrders getter called: $count');
    return count;
  }

  // 🔹 Computed user info
  String get userName {
    final name = user.value?.name ?? 'Guest';
    print('📊 userName getter called: $name');
    return name;
  }

  String get userEmail => user.value?.email ?? '';
  String get userPhone => user.value?.phoneNumber ?? '';
  bool get isApproved => user.value?.isApproved ?? false;
  bool get isAdmin => user.value?.isAdmin ?? false;

  // 🔹 Profile completion
  double get profileCompletion {
    double completion = 0.0;
    final currentUser = user.value;

    if (currentUser != null) {
      if (currentUser.name.isNotEmpty) completion += 25;
      if (currentUser.email.isNotEmpty) completion += 25;
      if (currentUser.phoneNumber.isNotEmpty) completion += 25;
      if (addresses.isNotEmpty) completion += 25;
    }

    print('📊 profileCompletion getter called: $completion%');
    return completion;
  }
}
