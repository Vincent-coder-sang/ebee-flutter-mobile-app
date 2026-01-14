// app/modules/services/controllers/service_controller.dart
import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../../data/repositories/service_repository.dart';

class ServiceController extends GetxController {
  final ServiceRepository _serviceRepository = Get.find<ServiceRepository>();

  // UI state
  final isLoading = false.obs;

  // Data
  final services = <Service>[].obs;
  final bookings = <Booking>[].obs;

  // 🔥 REQUIRED FOR SERVICE DETAIL VIEW
  final selectedService = Rxn<Service>();

  @override
  void onInit() {
    super.onInit();
    getServices();
  }

  // ================== SERVICES ==================

  Future<void> getServices() async {
    try {
      isLoading.value = true;
      final result = await _serviceRepository.getServices();
      services.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services');
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 REQUIRED METHOD (WAS MISSING)
  Future<void> getServiceById(String serviceId) async {
    try {
      isLoading.value = true;
      final service = await _serviceRepository.getServiceById(serviceId);
      selectedService.value = service;
    } catch (e) {
      selectedService.value = null;
      Get.snackbar('Error', 'Failed to load service');
    } finally {
      isLoading.value = false;
    }
  }

  // ================== BOOKINGS ==================

  Future<void> getBookings() async {
    try {
      isLoading.value = true;
      final result = await _serviceRepository.getBookings();
      bookings.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookings');
    } finally {
      isLoading.value = false;
    }
  }
}
