// app/modules/services/views/bookings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text('Service bookings will be displayed here'),
      ),
    );
  }
}
