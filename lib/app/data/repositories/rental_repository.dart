// app/data/repositories/rental_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/rental_model.dart';
import '../../utils/constants.dart' show ApiEndpoints;

class RentalRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<Rental>> getRentals() async {
    final response = await _apiProvider.get(ApiEndpoints.getRental);
    final List rentals = response['rentals'] ?? response['data'] ?? [];
    return rentals.map((rental) => Rental.fromJson(rental)).toList();
  }

  Future<List<Rental>> getMyRentals() async {
    final response = await _apiProvider.get(ApiEndpoints.myRentals);
    final List rentals = response['rentals'] ?? response['data'] ?? [];
    return rentals.map((rental) => Rental.fromJson(rental)).toList();
  }

  Future<Rental> createRental(
    String productId,
    double price,
    DateTime rentStart,
    DateTime rentEnd,
  ) async {
    final response = await _apiProvider.post(ApiEndpoints.createRental, {
      'productId': productId,
      'price': price,
      'rentStart': rentStart.toIso8601String(),
      'rentEnd': rentEnd.toIso8601String(),
    });
    return Rental.fromJson(response['rental'] ?? response['data']);
  }

  Future<Rental> updateRental(String id, Map<String, dynamic> updates) async {
    final response = await _apiProvider.put(
      '${ApiEndpoints.updateRental}/$id',
      updates,
    );
    return Rental.fromJson(response['rental'] ?? response['data']);
  }

  Future<void> deleteRental(String id) async {
    await _apiProvider.delete('${ApiEndpoints.deleteRental}/$id');
  }
}
