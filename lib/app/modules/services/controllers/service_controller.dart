// app/modules/services/controllers/service_controller.dart
import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../../data/repositories/service_repository.dart';

class ServiceController extends GetxController {
  final ServiceRepository _serviceRepository = Get.find<ServiceRepository>();

  final isLoading = false.obs;

  final services = <Service>[].obs;
  final bookings = <Booking>[].obs;

  final selectedService = Rxn<Service>();

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  // ================== SERVICES ==================

  Future<void> fetchServices() async {
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

  Future<void> fetchServiceById(String serviceId) async {
    try {
      isLoading.value = true;
      selectedService.value = await _serviceRepository.getServiceById(
        serviceId,
      );
    } catch (_) {
      selectedService.value = null;
      Get.snackbar('Error', 'Failed to load service');
    } finally {
      isLoading.value = false;
    }
  }

  // ================== BOOKINGS ==================

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final result = await _serviceRepository.getBookings();
      bookings.assignAll(result);
    } catch (_) {
      Get.snackbar('Error', 'Failed to load bookings');
    } finally {
      isLoading.value = false;
    }
  }
}
