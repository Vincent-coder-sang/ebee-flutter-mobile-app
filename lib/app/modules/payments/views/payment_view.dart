import 'package:ebee/app/modules/orders/views/order_success_view.dart';
import 'package:ebee/app/modules/payments/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentView extends StatelessWidget {
  final String orderId;
  final double amount;

  const PaymentView({super.key, required this.orderId, required this.amount});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _confirmExit(controller),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _orderSummary(),
              const SizedBox(height: 24),
              Expanded(child: _paymentMethods(controller)),
              _helpText(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _orderSummary() {
    final shortId = orderId.length > 8
        ? '#${orderId.substring(0, 8)}...'
        : '#$orderId';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _row('Order ID', shortId),
            const SizedBox(height: 8),
            _row(
              'Amount',
              'KES ${amount.toStringAsFixed(2)}',
              valueColor: Colors.green,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  Widget _paymentMethods(PaymentController controller) {
    return Obx(
      () => Card(
        child: ListTile(
          leading: const Icon(Icons.phone_android, color: Colors.green),
          title: const Text('M-Pesa'),
          subtitle: const Text('You will receive an STK push'),
          trailing: controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: controller.isLoading.value
              ? null
              : () => _mpesaDialog(controller),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  void _mpesaDialog(PaymentController controller) {
    String phone = '';

    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'M-Pesa Payment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '07XXXXXXXX',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => phone = v,
              ),
              const SizedBox(height: 12),
              Text(
                'Amount: KES ${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: Get.back, child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (phone.length != 10) {
                        Get.snackbar(
                          'Invalid Number',
                          'Enter a valid phone number',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      Get.back();
                      _startPayment(controller, phone);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Future<void> _startPayment(PaymentController controller, String phone) async {
    _showBlockingDialog('Sending STK push...');

    final response = await controller.initiateMpesaPayment(
      phone: _formatPhone(phone),
      amount: amount,
      orderId: orderId,
    );

    Get.back(); // close loading dialog

    if (response['success'] != true) {
      Get.snackbar(
        'Payment Failed',
        response['message'] ?? 'Unable to initiate payment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String? checkoutRequestId = response['checkoutRequestId'];

    if (checkoutRequestId == null) {
      Get.snackbar(
        'Payment Error',
        'Invalid payment reference received',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _showBlockingDialog(
      'Waiting for M-Pesa confirmation...\nEnter your PIN on your phone',
    );

    final confirmed = await controller.checkPaymentStatus(checkoutRequestId);

    Get.back(); // close waiting dialog

    if (confirmed) {
      Get.offAll(
        () => OrderSuccessView(
          orderId: orderId,
          amount: amount,
          phoneNumber: _formatPhone(phone),
        ),
      );
    } else {
      Get.snackbar(
        'Payment Pending',
        'Payment was not completed',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // ---------------------------------------------------------------------------
  void _showBlockingDialog(String text) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(text, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // ✅ CORRECT PLACE
    );
  }

  // ---------------------------------------------------------------------------
  String _formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('07')) return '254${digits.substring(1)}';
    if (digits.startsWith('254')) return digits;
    return '254$digits';
  }

  // ---------------------------------------------------------------------------
  void _confirmExit(PaymentController controller) {
    if (controller.isLoading.value) {
      Get.snackbar(
        'Please wait',
        'Payment is in progress',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Cancel payment?'),
        content: const Text('You can complete it later from your orders.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Continue')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _helpText() {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text(
        'Need help? support@ebee.com',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
