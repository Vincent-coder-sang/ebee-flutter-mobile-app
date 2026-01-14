// app/data/repositories/service_repository.dart
import 'package:get/get.dart';
import '../models/service_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';

class ServiceRepository {
  final ApiProvider _api = Get.find<ApiProvider>();

  Future<List<Service>> getServices() async {
    final res = await _api.get(ApiEndpoints.allServices);
    final list = res['data'] as List? ?? [];
    return list.map((e) => Service.fromJson(e)).toList();
  }

  Future<Service> getServiceById(String id) async {
    final res = await _api.get('${ApiEndpoints.getService}/$id');
    return Service.fromJson(res['data']);
  }

  Future<Service> createService(Map<String, dynamic> data) async {
    final res = await _api.post(ApiEndpoints.createService, data);
    return Service.fromJson(res['data']);
  }

  Future<void> deleteService(String id) async {
    await _api.delete('${ApiEndpoints.deleteService}/$id');
  }

  Future<List<Booking>> getBookings() async {
    final res = await _api.get(ApiEndpoints.getBookings);
    final list = res['data'] as List? ?? [];
    return list.map((e) => Booking.fromJson(e)).toList();
  }

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    final res = await _api.post(ApiEndpoints.createBooking, data);
    return Booking.fromJson(res['data']);
  }
}
