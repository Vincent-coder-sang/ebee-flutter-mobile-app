// app/data/repositories/booking_repository.dart
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/booking_model.dart';
import '../../utils/constants.dart' show ApiEndpoints;

class BookingRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<Booking>> getBookings() async {
    final response = await _apiProvider.get(ApiEndpoints.bookings);
    final List bookings = response['bookings'] ?? response['data'] ?? [];
    return bookings.map((booking) => Booking.fromJson(booking)).toList();
  }

  Future<List<Booking>> getMyBookings() async {
    final response = await _apiProvider.get(
      '${ApiEndpoints.bookings}/my-bookings',
    );
    final List bookings = response['bookings'] ?? response['data'] ?? [];
    return bookings.map((booking) => Booking.fromJson(booking)).toList();
  }

  Future<Booking> getBookingById(String id) async {
    final response = await _apiProvider.get('${ApiEndpoints.bookings}/$id');
    return Booking.fromJson(response['booking'] ?? response['data']);
  }

  Future<Booking> createBooking(String serviceId, {String? notes}) async {
    final response = await _apiProvider.post(ApiEndpoints.bookings, {
      'serviceId': serviceId,
      'notes': notes,
    });
    return Booking.fromJson(response['booking'] ?? response['data']);
  }

  Future<Booking> updateBooking(String id, Map<String, dynamic> updates) async {
    final response = await _apiProvider.put(
      '${ApiEndpoints.bookings}/$id',
      updates,
    );
    return Booking.fromJson(response['booking'] ?? response['data']);
  }

  Future<void> deleteBooking(String id) async {
    await _apiProvider.delete('${ApiEndpoints.bookings}/$id');
  }

  // Additional booking methods
  Future<List<Booking>> getBookingsByStatus(BookingStatus status) async {
    final response = await _apiProvider.get(
      '${ApiEndpoints.bookings}?status=${status.value}',
    );
    final List bookings = response['bookings'] ?? response['data'] ?? [];
    return bookings.map((booking) => Booking.fromJson(booking)).toList();
  }

  Future<List<Booking>> getTechnicianBookings(String technicianId) async {
    final response = await _apiProvider.get(
      '${ApiEndpoints.bookings}/technician/$technicianId',
    );
    final List bookings = response['bookings'] ?? response['data'] ?? [];
    return bookings.map((booking) => Booking.fromJson(booking)).toList();
  }

  Future<Booking> assignTechnician(
    String bookingId,
    String technicianId,
  ) async {
    final response = await _apiProvider.put(
      '${ApiEndpoints.bookings}/$bookingId/assign',
      {'assignedTo': technicianId},
    );
    return Booking.fromJson(response['booking'] ?? response['data']);
  }

  Future<Booking> updateStatus(String bookingId, BookingStatus status) async {
    final response = await _apiProvider.put(
      '${ApiEndpoints.bookings}/$bookingId/status',
      {'status': status.value},
    );
    return Booking.fromJson(response['booking'] ?? response['data']);
  }
}
