// app/modules/services/views/service_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/service_controller.dart';
import '../../../data/models/service_model.dart';

class ServiceDetailView extends GetView<ServiceController> {
  const ServiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final String? serviceId = Get.parameters['id'];

    // Safety check
    if (serviceId == null || serviceId.isEmpty) {
      return const Scaffold(body: Center(child: Text('Invalid service ID')));
    }

    // Load service once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getServiceById(serviceId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final Service? service = controller.selectedService.value;

        if (service == null) {
          return const Center(child: Text('Service not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAME
              Text(
                service.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              /// PRICE
              Text(
                '\$${service.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 16),

              /// DESCRIPTION
              Text(service.description, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 24),

              /// METADATA
              _InfoRow(
                label: 'Created',
                value: service.createdAt.toLocal().toString(),
              ),
              _InfoRow(
                label: 'Updated',
                value: service.updatedAt.toLocal().toString(),
              ),

              const SizedBox(height: 24),

              /// BOOKINGS
              if (service.bookings != null && service.bookings!.isNotEmpty) ...[
                const Text(
                  'Bookings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...service.bookings!.map(
                  (booking) => Card(
                    child: ListTile(
                      title: Text('Booking #${booking.id}'),
                      subtitle: Text(booking.status.name.toUpperCase()),
                      trailing: Icon(
                        Icons.circle,
                        color: booking.statusColor,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ] else
                const Text(
                  'No bookings yet',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// REUSABLE INFO ROW
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
