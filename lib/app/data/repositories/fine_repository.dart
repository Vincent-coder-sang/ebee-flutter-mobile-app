// app/data/repositories/fine_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/fine_model.dart';
import '../../utils/constants.dart' show ApiEndpoints;

class FineRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  /// Get all fines
  Future<List<Fine>> getFines() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.fines);
      final List fines = response['fines'] ?? response['data'] ?? [];
      return fines.map((fine) => Fine.fromJson(fine)).toList();
    } catch (e) {
      throw 'Failed to fetch fines: $e';
    }
  }

  /// Get fine by ID
  Future<Fine> getFineById(String id) async {
    try {
      final response = await _apiProvider.get('${ApiEndpoints.fines}/$id');
      return Fine.fromJson(response['fine'] ?? response['data']);
    } catch (e) {
      throw 'Failed to fetch fine: $e';
    }
  }

  /// Create a new fine
  Future<Fine> createFine({
    required String reason,
    required double amount,
    required String rentalId,
    required String userId,
  }) async {
    try {
      final response = await _apiProvider.post(ApiEndpoints.fines, {
        'reason': reason,
        'amount': amount,
        'rentalId': rentalId,
        'userId': userId,
      });
      return Fine.fromJson(response['fine'] ?? response['data']);
    } catch (e) {
      throw 'Failed to create fine: $e';
    }
  }

  /// Update an existing fine
  Future<Fine> updateFine(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _apiProvider.put(
        '${ApiEndpoints.fines}/$id',
        updates,
      );
      return Fine.fromJson(response['fine'] ?? response['data']);
    } catch (e) {
      throw 'Failed to update fine: $e';
    }
  }

  /// Delete a fine
  Future<void> deleteFine(String id) async {
    try {
      await _apiProvider.delete('${ApiEndpoints.fines}/$id');
    } catch (e) {
      throw 'Failed to delete fine: $e';
    }
  }

  /// Get fines by user
  Future<List<Fine>> getFinesByUser(String userId) async {
    try {
      final response = await _apiProvider.get(
        '${ApiEndpoints.fines}/user/$userId',
      );
      final List fines = response['fines'] ?? response['data'] ?? [];
      return fines.map((fine) => Fine.fromJson(fine)).toList();
    } catch (e) {
      throw 'Failed to fetch user fines: $e';
    }
  }

  /// Get fines by rental
  Future<List<Fine>> getFinesByRental(String rentalId) async {
    try {
      final response = await _apiProvider.get(
        '${ApiEndpoints.fines}/rental/$rentalId',
      );
      final List fines = response['fines'] ?? response['data'] ?? [];
      return fines.map((fine) => Fine.fromJson(fine)).toList();
    } catch (e) {
      throw 'Failed to fetch rental fines: $e';
    }
  }

  /// Get unpaid fines
  Future<List<Fine>> getUnpaidFines() async {
    try {
      final response = await _apiProvider.get(
        '${ApiEndpoints.fines}?paid=false',
      );
      final List fines = response['fines'] ?? response['data'] ?? [];
      return fines.map((fine) => Fine.fromJson(fine)).toList();
    } catch (e) {
      throw 'Failed to fetch unpaid fines: $e';
    }
  }

  /// Mark fine as paid
  Future<Fine> markAsPaid(String fineId) async {
    try {
      final response = await _apiProvider.put(
        '${ApiEndpoints.fines}/$fineId/pay',
        {},
      );
      return Fine.fromJson(response['fine'] ?? response['data']);
    } catch (e) {
      throw 'Failed to mark fine as paid: $e';
    }
  }

  /// Waive a fine (admin function)
  Future<Fine> waiveFine(String fineId) async {
    try {
      final response = await _apiProvider.put(
        '${ApiEndpoints.fines}/$fineId/waive',
        {},
      );
      return Fine.fromJson(response['fine'] ?? response['data']);
    } catch (e) {
      throw 'Failed to waive fine: $e';
    }
  }
}
