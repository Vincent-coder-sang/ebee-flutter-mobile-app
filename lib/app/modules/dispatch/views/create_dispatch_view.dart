// app/modules/dispatch/views/create_dispatch_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebee/app/modules/dispatch/controllers/dispatch_controller.dart';

class CreateDispatchView extends StatefulWidget {
  const CreateDispatchView({super.key});

  @override
  State<CreateDispatchView> createState() => _CreateDispatchViewState();
}

class _CreateDispatchViewState extends State<CreateDispatchView> {
  final DispatchController controller = Get.find<DispatchController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Dispatch'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _onBackPressed(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver ID Field
              Text(
                'Driver Information',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: driverIdController,
                decoration: const InputDecoration(
                  labelText: 'Driver ID',
                  hintText: 'Enter driver ID',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Order ID Field
              Text(
                'Order Information',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: orderIdController,
                decoration: const InputDecoration(
                  labelText: 'Order ID',
                  hintText: 'Enter order ID',
                  prefixIcon: Icon(Icons.shopping_cart),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter order ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Delivery Date Picker
              Text(
                'Delivery Schedule',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.blue),
                  title: const Text('Delivery Date'),
                  subtitle: Text(
                    _formatDate(selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the expected delivery date',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),

              const Spacer(),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _assignDispatch,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Assign Dispatch',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Delivery Date',
      confirmText: 'CONFIRM',
      cancelText: 'CANCEL',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _assignDispatch() {
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Dispatch Assignment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Driver ID: ${driverIdController.text}'),
            Text('Order ID: ${orderIdController.text}'),
            Text('Delivery Date: ${_formatDate(selectedDate)}'),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to assign this dispatch?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _submitDispatch();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _submitDispatch() {
    controller
        .createDispatch(
          driverId: driverIdController.text.trim(),
          orderId: orderIdController.text.trim(),
          deliveryDate: selectedDate,
        )
        .then((success) {
          if (success) {
            Get.back();
          }
        });
  }

  void _onBackPressed() {
    if (driverIdController.text.isNotEmpty ||
        orderIdController.text.isNotEmpty) {
      _showExitConfirmation();
    } else {
      Get.back();
    }
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue Editing'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    driverIdController.dispose();
    orderIdController.dispose();
    super.dispose();
  }
}
