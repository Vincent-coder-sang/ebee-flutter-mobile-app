// app/modules/services/views/services_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/service_controller.dart';

class ServicesView extends GetView<ServiceController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.services.isEmpty) {
          return const Center(
            child: Text(
              'No services available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.services.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final service = controller.services[i];
            return ListTile(
              title: Text(service.name),
              subtitle: Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                'KES ${service.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
