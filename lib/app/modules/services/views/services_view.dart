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

        return ListView.builder(
          itemCount: controller.services.length,
          itemBuilder: (_, i) {
            final service = controller.services[i];
            return ListTile(
              title: Text(service.name),
              subtitle: Text(service.description),
              trailing: Text('\$${service.price}'),
            );
          },
        );
      }),
    );
  }
}
