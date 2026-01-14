// app/data/repositories/address_repository.dart
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/address_model.dart';

class AddressRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<UserAddress>> getAddresses() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getAddresses);
      final List addresses = response['addresses'] ?? response['data'] ?? [];
      return addresses
          .map((addressJson) => UserAddress.fromJson(addressJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserAddress> createAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoints.createAddress,
        addressData, // Pass the map directly
      );
      return UserAddress.fromJson(response['address'] ?? response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // FIXED: Accept addressId and Map instead of UserAddress
  Future<UserAddress> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final response = await _apiProvider.put(
        ApiEndpoints.updateAddress(addressId),
        addressData, // Pass the map directly
      );
      return UserAddress.fromJson(response['address'] ?? response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _apiProvider.delete(ApiEndpoints.deleteAddress(addressId));
    } catch (e) {
      rethrow;
    }
  }
}
