// app/modules/rentals/controllers/rental_controller.dart
import 'package:get/get.dart';

import '../../../data/repositories/rental_repository.dart';
import '../../../data/models/rental_model.dart';
import '../../../data/models/product_model.dart';

class RentalController extends GetxController {
  final RentalRepository _rentalRepository = RentalRepository();

  var isLoading = false.obs;
  var rentals = <Rental>[].obs;
  var selectedRental = Rxn<Rental>();

  Future<void> getRentals() async {
    try {
      isLoading.value = true;
      final List<Rental> rentalList = await _rentalRepository.getRentals();
      rentals.assignAll(rentalList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load rentals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMyRentals() async {
    try {
      isLoading.value = true;
      final List<Rental> myRentals = await _rentalRepository.getMyRentals();
      rentals.assignAll(myRentals);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load your rentals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRental(
    String productId,
    double price,
    DateTime rentStart,
    DateTime rentEnd,
  ) async {
    try {
      isLoading.value = true;
      final Rental rental = await _rentalRepository.createRental(
        productId,
        price,
        rentStart,
        rentEnd,
      );
      rentals.insert(0, rental);
      Get.snackbar('Success', 'Rental created successfully');
      Get.offAllNamed('/rentals');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create rental: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRental(
    String rentalId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _rentalRepository.updateRental(rentalId, updates);
      await getRentals(); // Refresh rentals
      Get.snackbar('Success', 'Rental updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update rental: $e');
    }
  }

  Future<void> deleteRental(String rentalId) async {
    try {
      await _rentalRepository.deleteRental(rentalId);
      rentals.removeWhere((rental) => rental.id == rentalId);
      Get.snackbar('Success', 'Rental deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete rental: $e');
    }
  }

  // Filter rentals by status
  List<Rental> get pendingRentals =>
      rentals.where((r) => r.status == RentalStatus.pending).toList();
  List<Rental> get activeRentals =>
      rentals.where((r) => r.status == RentalStatus.paid).toList();
}
