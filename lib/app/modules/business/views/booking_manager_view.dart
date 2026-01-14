// app/modules/bookings/views/booking_manager_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingManagerView extends StatelessWidget {
  const BookingManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBookingList('Upcoming'),
                  _buildBookingList('In Progress'),
                  _buildBookingList('Completed'),
                  _buildBookingList('Cancelled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.calendar_today)),
          title: Text('Booking #${1000 + index}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: Customer ${index + 1}'),
              Text('Service: ${_getServiceType(index)}'),
              Text('Date: ${DateTime.now().add(Duration(days: index))}'),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(status),
                backgroundColor: _getStatusColor(status),
              ),
              if (status == 'Upcoming')
                TextButton(
                  onPressed: () => _manageBooking(index),
                  child: const Text('Manage', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
          onTap: () => _viewBookingDetails(index),
        ),
      ),
    );
  }

  String _getServiceType(int index) {
    List<String> services = [
      'E-Bike Rental',
      'Maintenance',
      'Repair',
      'Battery Replacement',
    ];
    return services[index % services.length];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewBookingDetails(int bookingId) {
    Get.toNamed('/bookings/$bookingId');
  }

  void _manageBooking(int bookingId) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Manage Booking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Reschedule'),
              onTap: () => _rescheduleBooking(bookingId),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel Booking'),
              onTap: () => _cancelBooking(bookingId),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assign Technician'),
              onTap: () => _assignTechnician(bookingId),
            ),
          ],
        ),
      ),
    );
  }

  void _rescheduleBooking(int bookingId) {
    Get.back();
    // Implement reschedule logic
    Get.snackbar('Reschedule', 'Rescheduling booking #$bookingId');
  }

  void _cancelBooking(int bookingId) {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('No')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Cancelled',
                'Booking #$bookingId has been cancelled',
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _assignTechnician(int bookingId) {
    Get.back();
    Get.toNamed('/dispatch', arguments: {'bookingId': bookingId});
  }
}
