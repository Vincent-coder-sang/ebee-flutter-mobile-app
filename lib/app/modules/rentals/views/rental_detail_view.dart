// app/modules/rentals/views/rental_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentalDetailView extends StatelessWidget {
  const RentalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final rentalId = Get.parameters['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rental Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Rental details will be displayed here'),
          ],
        ),
      ),
    );
  }
}
