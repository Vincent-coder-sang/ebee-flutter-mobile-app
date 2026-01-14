// app/modules/rentals/views/rentals_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentalsView extends StatelessWidget {
  const RentalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Bike Rentals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Available for Rent',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Rental bikes list
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Rental e-bikes will be displayed here'),
            ),
          ),
        ],
      ),
    );
  }
}
