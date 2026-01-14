// app/data/repositories/service_repository.dart
import 'package:get/get.dart';
import '../models/service_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';

class ServiceRepository {
  final ApiProvider _api = Get.find<ApiProvider>();

  Future<List<Service>> getServices() async {
    final res = await _api.get(ApiEndpoints.allServices);
    final list = res['services'] ?? res['data'] ?? [];
    return List<Service>.from(list.map(Service.fromJson));
  }

  Future<Service> getServiceById(String id) async {
    final res = await _api.get('${ApiEndpoints.getService}/$id');
    return Service.fromJson(res['service'] ?? res['data'] ?? res);
  }

  Future<Service> createService(Map<String, dynamic> data) async {
    final res = await _api.post(ApiEndpoints.createService, data);
    return Service.fromJson(res['service'] ?? res['data'] ?? res);
  }

  Future<void> deleteService(String id) async {
    await _api.delete('${ApiEndpoints.deleteService}/$id');
  }

  Future<List<Booking>> getBookings() async {
    final res = await _api.get(ApiEndpoints.getBookings);
    final list = res['bookings'] ?? res['data'] ?? [];
    return List<Booking>.from(list.map(Booking.fromJson));
  }

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    final res = await _api.post(ApiEndpoints.createBooking, data);
    return Booking.fromJson(res['booking'] ?? res['data'] ?? res);
  }
}
