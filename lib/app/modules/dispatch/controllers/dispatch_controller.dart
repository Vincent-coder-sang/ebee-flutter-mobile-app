// app/modules/dispatch/controllers/dispatch_controller.dart
import 'package:get/get.dart';
import 'package:ebee/app/data/models/dispatch_model.dart';
import 'package:ebee/app/data/repositories/dispatch_repository.dart';

class DispatchController extends GetxController {
  final DispatchRepository _dispatchRepository = Get.find<DispatchRepository>();

  var dispatches = <Dispatch>[].obs;
  var isLoading = false.obs;
  var selectedDispatch = Rx<Dispatch?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDispatches();
  }

  // Fetch all dispatches
  Future<void> fetchDispatches() async {
    try {
      isLoading.value = true;
      final List<Dispatch> dispatchList = await _dispatchRepository
          .getDispatches();
      dispatches.value = dispatchList;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Create new dispatch
  Future<bool> createDispatch({
    required String driverId,
    required String orderId,
    required DateTime deliveryDate,
  }) async {
    try {
      isLoading.value = true;
      await _dispatchRepository.createDispatch(
        driverId: driverId,
        orderId: orderId,
        deliveryDate: deliveryDate,
      );

      Get.snackbar('Success', 'Dispatch assigned successfully');
      await fetchDispatches();
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update dispatch status
  Future<bool> updateDispatchStatus(
    String dispatchId,
    DispatchStatus status,
  ) async {
    try {
      await _dispatchRepository.updateDispatchStatus(dispatchId, status);
      Get.snackbar('Success', 'Dispatch status updated');
      await fetchDispatches();
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  // Update dispatch details
  Future<bool> updateDispatch({
    required String dispatchId,
    String? driverId,
    DateTime? deliveryDate,
    DispatchStatus? status,
  }) async {
    try {
      await _dispatchRepository.updateDispatch(
        dispatchId: dispatchId,
        driverId: driverId,
        deliveryDate: deliveryDate,
        status: status,
      );

      Get.snackbar('Success', 'Dispatch updated successfully');
      await fetchDispatches();
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  // Delete dispatch
  Future<bool> deleteDispatch(String dispatchId) async {
    try {
      await _dispatchRepository.deleteDispatch(dispatchId);
      Get.snackbar('Success', 'Dispatch deleted successfully');
      await fetchDispatches();
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  // Filter dispatches by status
  List<Dispatch> getDispatchesByStatus(DispatchStatus status) {
    return dispatches.where((dispatch) => dispatch.status == status).toList();
  }

  // Get dispatches for a specific driver
  List<Dispatch> getDispatchesForDriver(String driverId) {
    return dispatches
        .where((dispatch) => dispatch.driverId == driverId)
        .toList();
  }

  // Select dispatch for detailed view
  void selectDispatch(Dispatch dispatch) {
    selectedDispatch.value = dispatch;
  }

  // Clear selected dispatch
  void clearSelectedDispatch() {
    selectedDispatch.value = null;
  }
}
