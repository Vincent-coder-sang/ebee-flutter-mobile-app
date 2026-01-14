// app/modules/payments/views/payment_history_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentHistoryView extends StatelessWidget {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(child: Text('Payment history will be displayed here')),
    );
  }
}
