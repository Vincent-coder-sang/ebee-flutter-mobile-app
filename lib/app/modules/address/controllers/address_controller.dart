// app/modules/address/controllers/address_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/models/address_model.dart';

class AddressController extends GetxController {
  final AddressRepository _addressRepo = Get.find<AddressRepository>();

  var addresses = <UserAddress>[].obs;
  var selectedAddress = Rxn<UserAddress>();
  var isLoading = false.obs;
  var isCreatingAddress = false.obs;
  var isUpdatingAddress = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final userAddresses = await _addressRepo.getAddresses();
      addresses.assignAll(userAddresses);
      
      // Select first address by default
      if (addresses.isNotEmpty && selectedAddress.value == null) {
        selectedAddress.value = addresses.first;
      }
      
    } catch (e) {
      errorMessage.value = 'Failed to load addresses: ${e.toString()}';
      print('❌ Error loading addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAddress({
    required String county,
    required String phoneNumber,
    required String postalCode,
    required String street,
    required String subCounty,
    required String ward,
  }) async {
    try {
      isCreatingAddress.value = true;
      errorMessage.value = '';

      final addressData = {
        'county': county,
        'phoneNumber': phoneNumber,
        'postalCode': postalCode,
        'street': street,
        'subCounty': subCounty,
        'ward': ward,
      };

      final newAddress = await _addressRepo.createAddress(addressData);
      addresses.add(newAddress);
      
      // Select new address if it's the first one
      if (addresses.length == 1) {
        selectedAddress.value = newAddress;
      }
      
      Get.back();
      Get.snackbar(
        'Success',
        'Address added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } catch (e) {
      errorMessage.value = 'Failed to add address: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingAddress.value = false;
    }
  }

  Future<void> updateAddress({
    required String addressId,
    required String county,
    required String phoneNumber,
    required String postalCode,
    required String street,
    required String subCounty,
    required String ward,
  }) async {
    try {
      isUpdatingAddress.value = true;
      errorMessage.value = '';

      final updates = {
        'county': county,
        'phoneNumber': phoneNumber,
        'postalCode': postalCode,
        'street': street,
        'subCounty': subCounty,
        'ward': ward,
      };

      final updatedAddress = await _addressRepo.updateAddress(addressId, updates);
      
      final index = addresses.indexWhere((addr) => addr.id == addressId);
      if (index != -1) {
        addresses[index] = updatedAddress;
      }
      
      // Update selected address if it's the same one
      if (selectedAddress.value?.id == addressId) {
        selectedAddress.value = updatedAddress;
      }
      
      Get.back();
      Get.snackbar(
        'Success',
        'Address updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } catch (e) {
      errorMessage.value = 'Failed to update address: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingAddress.value = false;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      isLoading.value = true;
      
      await _addressRepo.deleteAddress(addressId);
      addresses.removeWhere((addr) => addr.id == addressId);
      
      // Clear selection if deleted address was selected
      if (selectedAddress.value?.id == addressId) {
        selectedAddress.value = addresses.isNotEmpty ? addresses.first : null;
      }
      
      Get.snackbar(
        'Success',
        'Address deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } catch (e) {
      errorMessage.value = 'Failed to delete address: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(UserAddress address) {
    selectedAddress.value = address;
  }

  UserAddress? get defaultAddress {
    return addresses.isNotEmpty ? addresses.first : null;
  }

  bool get hasAddresses => addresses.isNotEmpty;
}