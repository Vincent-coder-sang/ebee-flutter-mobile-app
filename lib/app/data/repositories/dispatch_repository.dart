// app/data/repositories/dispatch_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart';
import 'package:get/get.dart';
import 'package:ebee/app/data/models/dispatch_model.dart';
import 'package:ebee/app/utils/constants.dart';

class DispatchRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Fetch all dispatches
  Future<List<Dispatch>> getDispatches() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getDispatches);

      if (response['success'] == true) {
        final List<dynamic> dispatchData = response['data'] ?? [];
        return dispatchData.map((data) => Dispatch.fromJson(data)).toList();
      } else {
        throw response['message'] ?? 'Failed to fetch dispatches';
      }
    } catch (e) {
      throw 'Failed to fetch dispatches: $e';
    }
  }

  // Fetch dispatch by ID
  Future<Dispatch> getDispatchById(String dispatchId) async {
    try {
      // If you have a specific endpoint for single dispatch, use it here
      // For now, we'll fetch all and filter
      final dispatches = await getDispatches();
      final dispatch = dispatches.firstWhere(
        (d) => d.id == dispatchId,
        orElse: () => throw 'Dispatch not found',
      );
      return dispatch;
    } catch (e) {
      throw 'Failed to fetch dispatch: $e';
    }
  }

  // Create new dispatch
  Future<Dispatch> createDispatch({
    required String driverId,
    required String orderId,
    required DateTime deliveryDate,
  }) async {
    try {
      final response = await _apiProvider.post(ApiEndpoints.createDispatch, {
        'driverId': driverId,
        'orderId': orderId,
        'deliveryDate': deliveryDate.toIso8601String().split('T')[0],
      });

      if (response['success'] == true) {
        return Dispatch.fromJson(response['data']);
      } else {
        throw response['message'] ?? 'Failed to create dispatch';
      }
    } catch (e) {
      throw 'Failed to create dispatch: $e';
    }
  }

  // Update dispatch
  Future<Dispatch> updateDispatch({
    required String dispatchId,
    String? driverId,
    DateTime? deliveryDate,
    DispatchStatus? status,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};
      if (driverId != null) updateData['driverId'] = driverId;
      if (deliveryDate != null) {
        updateData['deliveryDate'] = deliveryDate.toIso8601String().split(
          'T',
        )[0];
      }
      if (status != null) {
        updateData['status'] = status.toString().split('.').last;
      }

      final response = await _apiProvider.put(
        ApiEndpoints.updateDispatch(dispatchId),
        updateData,
      );

      if (response['success'] == true) {
        return Dispatch.fromJson(response['data']);
      } else {
        throw response['message'] ?? 'Failed to update dispatch';
      }
    } catch (e) {
      throw 'Failed to update dispatch: $e';
    }
  }

  // Update dispatch status only
  Future<Dispatch> updateDispatchStatus(
    String dispatchId,
    DispatchStatus status,
  ) async {
    try {
      final response = await _apiProvider.put(
        ApiEndpoints.updateDispatch(dispatchId),
        {'status': status.toString().split('.').last},
      );

      if (response['success'] == true) {
        return Dispatch.fromJson(response['data']);
      } else {
        throw response['message'] ?? 'Failed to update dispatch status';
      }
    } catch (e) {
      throw 'Failed to update dispatch status: $e';
    }
  }

  // Delete dispatch
  Future<void> deleteDispatch(String dispatchId) async {
    try {
      final response = await _apiProvider.delete(
        ApiEndpoints.deleteDispatch(dispatchId),
      );

      if (response['success'] != true) {
        throw response['message'] ?? 'Failed to delete dispatch';
      }
    } catch (e) {
      throw 'Failed to delete dispatch: $e';
    }
  }

  // Get dispatches by driver ID
  Future<List<Dispatch>> getDispatchesByDriver(String driverId) async {
    try {
      final dispatches = await getDispatches();
      return dispatches
          .where((dispatch) => dispatch.driverId == driverId)
          .toList();
    } catch (e) {
      throw 'Failed to fetch dispatches by driver: $e';
    }
  }

  // Get dispatches by status
  Future<List<Dispatch>> getDispatchesByStatus(DispatchStatus status) async {
    try {
      final dispatches = await getDispatches();
      return dispatches.where((dispatch) => dispatch.status == status).toList();
    } catch (e) {
      throw 'Failed to fetch dispatches by status: $e';
    }
  }
}
