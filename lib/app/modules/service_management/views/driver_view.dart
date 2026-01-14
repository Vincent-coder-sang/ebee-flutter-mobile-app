// app/modules/service_management/views/driver_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverView extends StatelessWidget {
  const DriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Assignments'),
        actions: [
          IconButton(icon: const Icon(Icons.map), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDeliveryCard(
            'Pickup #123',
            'Customer Location A',
            'Service Center',
            'Ready',
            Colors.blue,
          ),
          _buildDeliveryCard(
            'Delivery #456',
            'Service Center',
            'Customer Location B',
            'In Transit',
            Colors.orange,
          ),
          _buildDeliveryCard(
            'Pickup #789',
            'Customer Location C',
            'Service Center',
            'Scheduled',
            Colors.grey,
          ),
          _buildDeliveryCard(
            'Delivery #101',
            'Service Center',
            'Customer Location D',
            'Completed',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(
    String id,
    String from,
    String to,
    String status,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(status),
                  backgroundColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('From: $from')),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('To: $to')),
              ],
            ),
            const SizedBox(height: 12),
            if (status == 'Ready' || status == 'Scheduled')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateDeliveryStatus(id, 'In Transit'),
                      child: const Text('Start Delivery'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewRoute(id),
                      child: const Text('View Route'),
                    ),
                  ),
                ],
              ),
            if (status == 'In Transit')
              ElevatedButton(
                onPressed: () => _updateDeliveryStatus(id, 'Completed'),
                child: const Text('Mark Delivered'),
              ),
          ],
        ),
      ),
    );
  }

  void _updateDeliveryStatus(String deliveryId, String status) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Status Update'),
        content: Text('Update $deliveryId to $status?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Status Updated', '$deliveryId is now $status');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _viewRoute(String deliveryId) {
    Get.toNamed('/map', arguments: {'deliveryId': deliveryId});
  }
}
