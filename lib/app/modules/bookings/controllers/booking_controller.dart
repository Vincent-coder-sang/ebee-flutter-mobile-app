// app/modules/bookings/controllers/booking_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/models/booking_model.dart';

class BookingController extends GetxController {
  final BookingRepository _bookingRepository = BookingRepository();

  var isLoading = false.obs;
  var bookings = <Booking>[].obs;
  var filteredBookings = <Booking>[].obs;
  var selectedBooking = Rxn<Booking>();
  var selectedStatus = BookingStatus.pending.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    getBookings();
    super.onInit();
  }

  Future<void> getBookings() async {
    try {
      isLoading.value = true;
      final List<Booking> bookingList = await _bookingRepository.getBookings();
      bookings.assignAll(bookingList);
      filterBookings();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMyBookings() async {
    try {
      isLoading.value = true;
      final List<Booking> myBookings = await _bookingRepository.getMyBookings();
      bookings.assignAll(myBookings);
      filterBookings();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load your bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createBooking(String serviceId, {String? notes}) async {
    try {
      isLoading.value = true;
      final Booking booking = await _bookingRepository.createBooking(
        serviceId,
        notes: notes,
      );
      bookings.insert(0, booking);
      filterBookings();
      Get.snackbar('Success', 'Booking created successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create booking: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBooking(
    String bookingId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final Booking updatedBooking = await _bookingRepository.updateBooking(
        bookingId,
        updates,
      );
      final index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index] = updatedBooking;
      }
      filterBookings();
      Get.snackbar('Success', 'Booking updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking: $e');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _bookingRepository.deleteBooking(bookingId);
      bookings.removeWhere((booking) => booking.id == bookingId);
      filterBookings();
      Get.snackbar('Success', 'Booking deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete booking: $e');
    }
  }

  Future<void> assignTechnician(String bookingId, String technicianId) async {
    try {
      final Booking updatedBooking = await _bookingRepository.assignTechnician(
        bookingId,
        technicianId,
      );
      final index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index] = updatedBooking;
      }
      filterBookings();
      Get.snackbar('Success', 'Technician assigned successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign technician: $e');
    }
  }

  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      final Booking updatedBooking = await _bookingRepository.updateStatus(
        bookingId,
        status,
      );
      final index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index] = updatedBooking;
      }
      filterBookings();
      Get.snackbar('Success', 'Booking status updated to ${status.value}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking status: $e');
    }
  }

  void filterBookings() {
    var filtered = bookings.where((booking) {
      final matchesStatus =
          selectedStatus.value == BookingStatus.pending ||
          booking.status == selectedStatus.value;
      final matchesSearch =
          searchQuery.value.isEmpty ||
          booking.serviceName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          booking.customerName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
      return matchesStatus && matchesSearch;
    }).toList();

    filteredBookings.assignAll(filtered);
  }

  void setStatusFilter(BookingStatus status) {
    selectedStatus.value = status;
    filterBookings();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterBookings();
  }

  void clearFilters() {
    selectedStatus.value = BookingStatus.pending;
    searchQuery.value = '';
    filterBookings();
  }

  // Statistics
  int get totalBookings => bookings.length;
  int get pendingBookings => bookings.where((b) => b.isPending).length;
  int get confirmedBookings => bookings.where((b) => b.isConfirmed).length;
  int get completedBookings => bookings.where((b) => b.isCompleted).length;
  int get cancelledBookings => bookings.where((b) => b.isCancelled).length;

  // Get bookings that require attention
  List<Booking> get attentionRequiredBookings {
    return bookings.where((booking) => booking.requiresAttention).toList();
  }

  // Get recent bookings (last 7 days)
  List<Booking> get recentBookings {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return bookings
        .where((booking) => booking.createdAt.isAfter(weekAgo))
        .toList();
  }

  // Get unassigned bookings
  List<Booking> get unassignedBookings {
    return bookings
        .where((booking) => !booking.isTechnicianAssigned && booking.isPending)
        .toList();
  }
}
